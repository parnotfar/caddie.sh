#!/usr/bin/env bash

# Caddie.sh - CSV/TSV analytics helpers
# Provides wrappers around csvql.py for querying and plotting data

source "$HOME/.caddie_modules/.caddie_cli"

function caddie_csv__initialize_globals() {
    if [ -z "${CADDIE_CSV_CONFIG_FILE:-}" ]; then
        CADDIE_CSV_CONFIG_FILE="$HOME/.caddie_data/csv_config"
    fi

    declare -gA CADDIE_CSV_CONFIG_KEYS=(
        [file]=CADDIE_CSV_FILE
        [x]=CADDIE_CSV_X
        [y]=CADDIE_CSV_Y
        [sep]=CADDIE_CSV_SEP
        [plot]=CADDIE_CSV_PLOT
        [title]=CADDIE_CSV_TITLE
        [limit]=CADDIE_CSV_LIMIT
        [save]=CADDIE_CSV_SAVE
        [success-filter]=CADDIE_CSV_SUCCESS_FILTER
        [scatter-filter]=CADDIE_CSV_SCATTER_FILTER
        [sql]=CADDIE_CSV_SQL
        [hole]=CADDIE_CSV_HOLE
        [hole:x]=CADDIE_CSV_HOLE_X
        [hole:y]=CADDIE_CSV_HOLE_Y
        [hole:r]=CADDIE_CSV_HOLE_R
        [rings]=CADDIE_CSV_RINGS
        [ring:radii]=CADDIE_CSV_RING_RADII
    )

    declare -ga CADDIE_CSV_CONFIG_ALIAS_ORDER=(
        file x y sep plot title limit save success-filter scatter-filter sql hole rings hole:x hole:y hole:r ring:radii
    )
}

caddie_csv__initialize_globals

function caddie_csv__ensure_data_dir() {
    mkdir -p "$HOME/.caddie_data"
    return 0
}

function caddie_csv__ensure_config_file() {
    caddie_csv__ensure_data_dir
    if [ ! -f "$CADDIE_CSV_CONFIG_FILE" ]; then
        : > "$CADDIE_CSV_CONFIG_FILE"
    fi
    return 0
}

function caddie_csv__resolve_env_key() {
    local alias="$1"
    if [ -z "$alias" ]; then
        caddie cli:red "Error: Configuration key required"
        return 1
    fi

    if [[ -z "${CADDIE_CSV_CONFIG_KEYS[$alias]-}" ]]; then
        caddie cli:red "Unknown csv configuration key: $alias"
        caddie cli:thought "Use 'caddie csv:config:list' to view available keys"
        return 1
    fi

    printf '%s' "${CADDIE_CSV_CONFIG_KEYS[$alias]}"
    return 0
}

function caddie_csv__config_lookup() {
    local env_key="$1"

    if [ -z "$env_key" ] || [ ! -f "$CADDIE_CSV_CONFIG_FILE" ]; then
        return 0
    fi

    local line value
    line=$(grep -E "^export[[:space:]]+$env_key=" "$CADDIE_CSV_CONFIG_FILE" | tail -n 1 || true)
    if [ -z "$line" ]; then
        return 0
    fi

    value=${line#*=}
    value=${value#"}
    value=${value%"}
    value=${value#\'}
    value=${value%\'}

    printf '%s' "$value"
    return 0
}

function caddie_csv__config_set_env() {
    local env_key="$1"
    shift
    local value="$*"

    if [ -z "$env_key" ]; then
        return 1
    fi

    caddie_csv__ensure_config_file

    local tmp_file
    tmp_file=$(mktemp) || return 1

    if [ -f "$CADDIE_CSV_CONFIG_FILE" ]; then
        grep -Ev "^export[[:space:]]+$env_key=" "$CADDIE_CSV_CONFIG_FILE" > "$tmp_file"
    fi

    printf 'export %s=%q\n' "$env_key" "$value" >> "$tmp_file"
    mv "$tmp_file" "$CADDIE_CSV_CONFIG_FILE"
    return 0
}

function caddie_csv__config_unset_env() {
    local env_key="$1"

    if [ -z "$env_key" ] || [ ! -f "$CADDIE_CSV_CONFIG_FILE" ]; then
        return 0
    fi

    local tmp_file
    tmp_file=$(mktemp) || return 1
    grep -Ev "^export[[:space:]]+$env_key" "$CADDIE_CSV_CONFIG_FILE" > "$tmp_file"
    mv "$tmp_file" "$CADDIE_CSV_CONFIG_FILE"
    return 0
}

function caddie_csv__load_config_into_env() {
    if [ -f "$CADDIE_CSV_CONFIG_FILE" ]; then
        # shellcheck disable=SC1090
        source "$CADDIE_CSV_CONFIG_FILE"
    fi
}

function caddie_csv__invoke_with_config() {
    local script_path="$1"
    shift

    (
        caddie_csv__load_config_into_env
        "$script_path" "$@"
    )
    return $?
}

function caddie_csv__get_effective_value() {
    local alias="$1"
    local env_key

    env_key=$(caddie_csv__resolve_env_key "$alias") || return 1

    local current="${!env_key:-}"
    if [ -n "$current" ]; then
        printf '%s' "$current"
        return 0
    fi

    caddie_csv__config_lookup "$env_key"
    return 0
}

function caddie_csv_config_set() {
    local alias="$1"
    shift || true

    if [ -z "$alias" ]; then
        caddie cli:red "Error: Configuration key required"
        caddie cli:usage "caddie csv:config:set <key> <value>"
        return 1
    fi

    if [ $# -lt 1 ]; then
        caddie cli:red "Error: Value required"
        caddie cli:usage "caddie csv:config:set <key> <value>"
        return 1
    fi

    local env_key
    env_key=$(caddie_csv__resolve_env_key "$alias") || return 1

    local value="$*"
    caddie_csv__config_set_env "$env_key" "$value"
    export "$env_key=$value"
    caddie cli:check "Set csv default '$alias' to '$value'"
    return 0
}

function caddie_csv_config_get() {
    local alias="$1"

    if [ -z "$alias" ]; then
        caddie cli:red "Error: Configuration key required"
        caddie cli:usage "caddie csv:config:get <key>"
        return 1
    fi

    local env_key
    env_key=$(caddie_csv__resolve_env_key "$alias") || return 1

    local value
    value=$(caddie_csv__get_effective_value "$alias")

    if [ -z "$value" ]; then
        caddie cli:warning "No value set for '$alias'"
        return 0
    fi

    caddie cli:package "$alias = $value"
    return 0
}

function caddie_csv_config_unset() {
    local alias="$1"

    if [ -z "$alias" ]; then
        caddie cli:red "Error: Configuration key required"
        caddie cli:usage "caddie csv:config:unset <key>"
        return 1
    fi

    local env_key
    env_key=$(caddie_csv__resolve_env_key "$alias") || return 1

    caddie_csv__config_unset_env "$env_key"
    unset "$env_key"
    caddie cli:check "Cleared csv default '$alias'"
    return 0
}

function caddie_csv_config_list() {
    caddie cli:title "CSV module defaults"

    local alias env_key value
    for alias in "${CADDIE_CSV_CONFIG_ALIAS_ORDER[@]}"; do
        env_key="${CADDIE_CSV_CONFIG_KEYS[$alias]}"
        value=$(caddie_csv__get_effective_value "$alias")
        if [ -n "$value" ]; then
            caddie cli:indent "$(printf '%-17s %s' "$alias" "$value")"
        else
            caddie cli:indent "$(printf '%-17s (unset)' "$alias")"
        fi
    done

    return 0
}

function caddie_csv__script_path() {
    local module_dir script_candidates
    module_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

    script_candidates=(
        "$module_dir/bin/csvql.py"
        "$module_dir/../bin/csvql.py"
        "$module_dir/csv/csvql.py"
        "$module_dir/../csv/csvql.py"
        "$HOME/.caddie_modules/bin/csvql.py"
        "$HOME/.caddie_modules/csv/csvql.py"
    )

    if [ -n "$CADDIE_HOME" ]; then
        script_candidates+=("$CADDIE_HOME/bin/csvql.py")
        script_candidates+=("$CADDIE_HOME/csvql.py")
        script_candidates+=("$CADDIE_HOME/scripts/csvql.py")
    fi

    local candidate
    for candidate in "${script_candidates[@]}"; do
        if [ -f "$candidate" ]; then
            printf '%s\n' "$candidate"
            return 0
        fi
    done

    caddie cli:red "csvql.py not found"
    caddie cli:thought "Run 'make install-dot' or set CADDIE_HOME to your caddie.sh checkout"
    return 1
}

function caddie_csv__require_axes() {
    local x_value y_value

    x_value=$(caddie_csv__get_effective_value x)
    y_value=$(caddie_csv__get_effective_value y)

    if [ -z "$x_value" ] || [ -z "$y_value" ]; then
        caddie cli:red "Set csv defaults for 'x' and 'y' axes before plotting"
        caddie cli:thought "Example: caddie csv:config:set x aim_offset_x"
        caddie cli:thought "         caddie csv:config:set y aim_offset_y"
        return 1
    fi

    return 0
}

function caddie_csv_description() {
    echo 'CSV SQL + plotting helpers with persistent defaults'
    return 0
}

function caddie_csv_help() {
    caddie cli:title "CSV / TSV Analytics"
    caddie cli:indent "csv:init                      Bootstrap csvql virtual environment"
    caddie cli:indent "csv:query <file> [sql] [...]  Run csvql with custom SQL/flags"
    caddie cli:indent "csv:scatter <file> [out]      Plot filtered scatter chart"
    caddie cli:blank
    caddie cli:title "Configuration Commands"
    caddie cli:indent "csv:config:set <key> <value>  Persist a default (e.g., file, x, y)"
    caddie cli:indent "csv:config:get <key>          Show the current value"
    caddie cli:indent "csv:config:unset <key>        Clear a stored value"
    caddie cli:indent "csv:config:list               List all stored defaults"
    caddie cli:blank
    caddie cli:title "Config Keys"
    caddie cli:indent "file, x, y, sep, plot, title, limit, save"
    caddie cli:indent "success-filter, scatter-filter, sql"
    caddie cli:indent "hole, hole:x, hole:y, hole:r"
    caddie cli:indent "rings, ring:radii"
    caddie cli:blank
    caddie cli:thought "Defaults live in ~/.caddie_data/csv_config (created on first save)"
    return 0
}

function caddie_csv__resolve_file_argument() {
    local provided="$1"
    if [ -n "$provided" ]; then
        printf '%s' "$provided"
        return 0
    fi
    caddie_csv__get_effective_value file
}

function caddie_csv_init() {
    local script_path
    script_path=$(caddie_csv__script_path) || return 1

    caddie cli:title "Setting up csvql environment"
    caddie_csv__invoke_with_config "$script_path" --init
    local status=$?
    if [ $status -ne 0 ]; then
        caddie cli:red "csvql init failed"
        return $status
    fi
    caddie cli:check "csvql environment ready"
    return 0
}

function caddie_csv_query() {
    local script_path
    script_path=$(caddie_csv__script_path) || return 1

    local csv_file
    if [ $# -gt 0 ] && [[ "$1" != --* ]]; then
        csv_file="$1"
        shift
    else
        csv_file=$(caddie_csv__resolve_file_argument "")
    fi

    if [ -z "$csv_file" ]; then
        caddie cli:red "Error: CSV file required"
        caddie cli:usage "caddie csv:config:set file /path/to/data.csv"
        caddie cli:thought "Or pass the file explicitly: caddie csv:query data.csv"
        return 1
    fi

    caddie cli:title "Running csvql on $csv_file"
    caddie_csv__invoke_with_config "$script_path" "$csv_file" "$@"
    local status=$?
    if [ $status -ne 0 ]; then
        caddie cli:red "csvql execution failed"
        return $status
    fi
    return 0
}

function caddie_csv_scatter() {
    local script_path
    script_path=$(caddie_csv__script_path) || return 1

    caddie_csv__require_axes || return 1

    local csv_file
    if [ $# -gt 0 ] && [[ "$1" != --* ]]; then
        csv_file="$1"
        shift
    else
        csv_file=$(caddie_csv__resolve_file_argument "")
    fi

    if [ -z "$csv_file" ]; then
        caddie cli:red "Error: CSV file required"
        caddie cli:usage "caddie csv:config:set file /path/to/data.csv"
        caddie cli:thought "Or pass the file explicitly: caddie csv:scatter data.csv"
        return 1
    fi

    local output_path=""
    if [ $# -gt 0 ] && [[ "$1" != --* ]]; then
        output_path="$1"
        shift
    fi

    local scatter_filter
    scatter_filter=$(caddie_csv__get_effective_value scatter-filter)
    if [ -z "$scatter_filter" ]; then
        scatter_filter=$(caddie_csv__get_effective_value success-filter)
    fi
    if [ -z "$scatter_filter" ]; then
        scatter_filter="miss = FALSE"
    fi

    local -a args
    args=("$csv_file" "--plot" "scatter")

    if [ -n "$scatter_filter" ]; then
        args+=("--success-filter" "$scatter_filter")
    fi

    if [ -n "$output_path" ]; then
        args+=("--save" "$output_path")
    fi

    if [ $# -gt 0 ]; then
        args+=("$@")
    fi

    caddie cli:title "Rendering scatter plot for $csv_file"
    caddie_csv__invoke_with_config "$script_path" "${args[@]}"
    local status=$?
    if [ $status -ne 0 ]; then
        caddie cli:red "Scatter plot failed"
        return $status
    fi
    return 0
}

export -f caddie_csv_description
export -f caddie_csv_help
export -f caddie_csv_init
export -f caddie_csv_query
export -f caddie_csv_scatter
export -f caddie_csv_config_set
export -f caddie_csv_config_get
export -f caddie_csv_config_unset
export -f caddie_csv_config_list
