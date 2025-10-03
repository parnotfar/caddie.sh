#!/usr/bin/env bash

# Caddie.sh - CSV/TSV analytics helpers
# Provides wrappers around csvql.py for querying and plotting data

source "$HOME/.caddie_modules/.caddie_cli"

function caddie_csv_init_globals() {
    declare -gA CADDIE_CSV_ENV_MAP=(
        [file]=CADDIE_CSV_FILE
        [x]=CADDIE_CSV_X
        [y]=CADDIE_CSV_Y
        [sep]=CADDIE_CSV_SEP
        [plot]=CADDIE_CSV_PLOT
        [title]=CADDIE_CSV_TITLE
        [limit]=CADDIE_CSV_LIMIT
        [save]=CADDIE_CSV_SAVE
        [success_filter]=CADDIE_CSV_SUCCESS_FILTER
        [scatter_filter]=CADDIE_CSV_SCATTER_FILTER
        [sql]=CADDIE_CSV_SQL
        [circle]=CADDIE_CSV_CIRCLE
        [rings]=CADDIE_CSV_RINGS
        [circle_x]=CADDIE_CSV_CIRCLE_X
        [circle_y]=CADDIE_CSV_CIRCLE_Y
        [circle_r]=CADDIE_CSV_CIRCLE_R
        [circle_radii]=CADDIE_CSV_CIRCLE_RADII
    )

    declare -ga CADDIE_CSV_KEY_ORDER=(
        file x y sep plot title limit save success_filter scatter_filter sql circle rings circle_x circle_y circle_r circle_radii
    )

    return 0
}

caddie_csv_init_globals

function caddie_csv_env_name() {
    local alias="$1"
    local env_name="${CADDIE_CSV_ENV_MAP[$alias]}"
    if [ -z "$env_name" ]; then
        caddie cli:red "Internal error: unknown csv key '$alias'"
        return 1
    fi
    printf '%s' "$env_name"
    return 0
}

function caddie_csv_set_alias_internal() {
    local alias="$1"
    local usage="$2"
    shift 2
    local value="$*"

    if [ -z "$value" ]; then
        caddie cli:red "Error: value required"
        caddie cli:usage "$usage"
        return 1
    fi

    local env
    env=$(caddie_csv_env_name "$alias") || return 1
    export "$env=$value"
    caddie cli:check "Set ${alias//_/ } to $value"
    return 0
}

function caddie_csv_show_alias_internal() {
    local alias="$1"
    local env
    env=$(caddie_csv_env_name "$alias") || return 1
    local value="${!env:-}"

    if [ -n "$value" ]; then
        caddie cli:package "${alias//_/ } = $value"
    else
        caddie cli:warning "${alias//_/ } not set"
    fi
    return 0
}

function caddie_csv_unset_alias_internal() {
    local alias="$1"
    local env
    env=$(caddie_csv_env_name "$alias") || return 1
    if [ -n "${!env-}" ]; then
        unset "$env"
        caddie cli:check "Cleared ${alias//_/ }"
    else
        caddie cli:warning "${alias//_/ } already unset"
    fi
    return 0
}

function caddie_csv_list() {
    caddie cli:title "CSV session defaults"
    local alias
    local env
    local value
    for alias in "${CADDIE_CSV_KEY_ORDER[@]}"; do
        env="${CADDIE_CSV_ENV_MAP[$alias]}"
        value="${!env:-}"
        if [ -n "$value" ]; then
            printf '  %-17s %s\n' "$alias" "$value"
        else
            printf '  %-17s (unset)\n' "$alias"
        fi
    done
    return 0
}

function caddie_csv_set_file()          { caddie_csv_set_alias_internal file "caddie csv:set:file <path>" "$@"; return $?; }
function caddie_csv_get_file()          { caddie_csv_show_alias_internal file; return $?; }
function caddie_csv_unset_file()        { caddie_csv_unset_alias_internal file; return $?; }

function caddie_csv_set_x()             { caddie_csv_set_alias_internal x "caddie csv:set:x <column>" "$@"; return $?; }
function caddie_csv_get_x()             { caddie_csv_show_alias_internal x; return $?; }
function caddie_csv_unset_x()           { caddie_csv_unset_alias_internal x; return $?; }

function caddie_csv_set_y()             { caddie_csv_set_alias_internal y "caddie csv:set:y <column>" "$@"; return $?; }
function caddie_csv_get_y()             { caddie_csv_show_alias_internal y; return $?; }
function caddie_csv_unset_y()           { caddie_csv_unset_alias_internal y; return $?; }

function caddie_csv_set_sep()           { caddie_csv_set_alias_internal sep "caddie csv:set:sep <separator>" "$@"; return $?; }
function caddie_csv_get_sep()           { caddie_csv_show_alias_internal sep; return $?; }
function caddie_csv_unset_sep()         { caddie_csv_unset_alias_internal sep; return $?; }

function caddie_csv_set_plot()          { caddie_csv_set_alias_internal plot "caddie csv:set:plot <scatter|line|bar>" "$@"; return $?; }
function caddie_csv_get_plot()          { caddie_csv_show_alias_internal plot; return $?; }
function caddie_csv_unset_plot()        { caddie_csv_unset_alias_internal plot; return $?; }

function caddie_csv_set_title()         { caddie_csv_set_alias_internal title "caddie csv:set:title <text>" "$@"; return $?; }
function caddie_csv_get_title()         { caddie_csv_show_alias_internal title; return $?; }
function caddie_csv_unset_title()       { caddie_csv_unset_alias_internal title; return $?; }

function caddie_csv_set_limit()         { caddie_csv_set_alias_internal limit "caddie csv:set:limit <rows>" "$@"; return $?; }
function caddie_csv_get_limit()         { caddie_csv_show_alias_internal limit; return $?; }
function caddie_csv_unset_limit()       { caddie_csv_unset_alias_internal limit; return $?; }

function caddie_csv_set_save()          { caddie_csv_set_alias_internal save "caddie csv:set:save <path>" "$@"; return $?; }
function caddie_csv_get_save()          { caddie_csv_show_alias_internal save; return $?; }
function caddie_csv_unset_save()        { caddie_csv_unset_alias_internal save; return $?; }

function caddie_csv_set_success_filter(){ caddie_csv_set_alias_internal success_filter "caddie csv:set:success_filter <predicate>" "$@"; return $?; }
function caddie_csv_get_success_filter(){ caddie_csv_show_alias_internal success_filter; return $?; }
function caddie_csv_unset_success_filter(){ caddie_csv_unset_alias_internal success_filter; return $?; }

function caddie_csv_set_scatter_filter(){ caddie_csv_set_alias_internal scatter_filter "caddie csv:set:scatter_filter <predicate>" "$@"; return $?; }
function caddie_csv_get_scatter_filter(){ caddie_csv_show_alias_internal scatter_filter; return $?; }
function caddie_csv_unset_scatter_filter(){ caddie_csv_unset_alias_internal scatter_filter; return $?; }

function caddie_csv_set_sql()           { caddie_csv_set_alias_internal sql "caddie csv:set:sql <query>" "$@"; return $?; }
function caddie_csv_get_sql()           { caddie_csv_show_alias_internal sql; return $?; }
function caddie_csv_unset_sql()         { caddie_csv_unset_alias_internal sql; return $?; }

function caddie_csv_set_circle()        { caddie_csv_set_alias_internal circle "caddie csv:set:circle <on|off>" "$@"; return $?; }
function caddie_csv_get_circle()        { caddie_csv_show_alias_internal circle; return $?; }
function caddie_csv_unset_circle()      { caddie_csv_unset_alias_internal circle; return $?; }

function caddie_csv_set_rings()         { caddie_csv_set_alias_internal rings "caddie csv:set:rings <on|off>" "$@"; return $?; }
function caddie_csv_get_rings()         { caddie_csv_show_alias_internal rings; return $?; }
function caddie_csv_unset_rings()       { caddie_csv_unset_alias_internal rings; return $?; }

function caddie_csv_set_circle_x()      { caddie_csv_set_alias_internal circle_x "caddie csv:set:circle_x <value>" "$@"; return $?; }
function caddie_csv_get_circle_x()      { caddie_csv_show_alias_internal circle_x; return $?; }
function caddie_csv_unset_circle_x()    { caddie_csv_unset_alias_internal circle_x; return $?; }

function caddie_csv_set_circle_y()      { caddie_csv_set_alias_internal circle_y "caddie csv:set:circle_y <value>" "$@"; return $?; }
function caddie_csv_get_circle_y()      { caddie_csv_show_alias_internal circle_y; return $?; }
function caddie_csv_unset_circle_y()    { caddie_csv_unset_alias_internal circle_y; return $?; }

function caddie_csv_set_circle_r()      { caddie_csv_set_alias_internal circle_r "caddie csv:set:circle_r <value>" "$@"; return $?; }
function caddie_csv_get_circle_r()      { caddie_csv_show_alias_internal circle_r; return $?; }
function caddie_csv_unset_circle_r()    { caddie_csv_unset_alias_internal circle_r; return $?; }

function caddie_csv_set_circle_radii()  { caddie_csv_set_alias_internal circle_radii "caddie csv:set:circle_radii <r1,r2,...>" "$@"; return $?; }
function caddie_csv_get_circle_radii()  { caddie_csv_show_alias_internal circle_radii; return $?; }
function caddie_csv_unset_circle_radii(){ caddie_csv_unset_alias_internal circle_radii; return $?; }

function caddie_csv_script_path_internal() {
    local module_dir
    local repo_candidate
    module_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
    repo_candidate="${module_dir%/modules}/bin/csvql.py"

    local candidates=(
        "$HOME/.caddie_modules/bin/csvql.py"
        "$repo_candidate"
    )

    if [ -n "$CADDIE_HOME" ]; then
        candidates+=(
            "$CADDIE_HOME/bin/csvql.py"
            "$CADDIE_HOME/csvql.py"
            "$CADDIE_HOME/scripts/csvql.py"
        )
    fi

    local candidate
    for candidate in "${candidates[@]}"; do
        if [ -f "$candidate" ]; then
            printf '%s\n' "$candidate"
            return 0
        fi
    done

    caddie cli:red "csvql.py not found"
    caddie cli:thought "Run 'make install-dot' or set CADDIE_HOME to your caddie.sh checkout"
    return 1
}

function caddie_csv_require_axes_internal() {
    local x_value="${CADDIE_CSV_X:-}"
    local y_value="${CADDIE_CSV_Y:-}"

    if [ -z "$x_value" ] || [ -z "$y_value" ]; then
        caddie cli:red "Set csv axes before plotting"
        caddie cli:thought "Example: caddie csv:set:x aim_offset_x"
        caddie cli:thought "         caddie csv:set:y aim_offset_y"
        return 1
    fi
    return 0
}

function caddie_csv_resolve_file_argument_internal() {
    local provided="$1"
    if [ -n "$provided" ]; then
        printf '%s' "$provided"
        return 0
    fi
    printf '%s' "${CADDIE_CSV_FILE:-}"
    return 0
}

function caddie_csv_preview_internal() {
    local preview_cmd="$1"
    local action_label="$2"
    local usage="$3"
    shift 3

    if [ $# -gt 0 ]; then
        case "$1" in
            --help|-h)
                caddie cli:title "$action_label"
                caddie cli:usage "$usage"
                caddie cli:thought "Set a default file with caddie csv:set:file <path>"
                return 0
                ;;
        esac
    fi

    local file_candidate=""
    if [ $# -gt 0 ] && [[ "$1" != -* ]]; then
        file_candidate="$1"
        shift
    fi

    local csv_file
    csv_file=$(caddie_csv_resolve_file_argument_internal "$file_candidate")

    if [ -z "$csv_file" ]; then
        caddie cli:red "Error: CSV file required"
        caddie cli:usage "$usage"
        caddie cli:thought "Provide a file or set a default with caddie csv:set:file <path>"
        return 1
    fi

    if [ ! -f "$csv_file" ]; then
        caddie cli:red "File not found: $csv_file"
        return 1
    fi

    caddie cli:title "$action_label for $csv_file"

    if [ $# -gt 0 ]; then
        command "$preview_cmd" "$@" "$csv_file"
    else
        command "$preview_cmd" "$csv_file"
    fi

    local status=$?
    if [ $status -ne 0 ]; then
        caddie cli:red "$preview_cmd command failed"
        return $status
    fi

    return 0
}

function caddie_csv_description() {
    echo 'CSV SQL + plotting helpers using session defaults'
    return 0
}


function caddie_csv_help() {
    caddie cli:title "CSV / TSV Analytics"
    caddie cli:indent "csv:init                 Bootstrap csvql virtual environment"
    caddie cli:indent "csv:query [file] ...     Run csvql with optional SQL/flags"
    caddie cli:indent "csv:scatter [file] ...   Render scatter plot using defaults"
    caddie cli:indent "csv:head [file] ...      Preview the first rows of a CSV file"
    caddie cli:indent "csv:tail [file] ...      Preview the last rows of a CSV file"
    caddie cli:blank
    caddie cli:title "Session Defaults"
    caddie cli:indent "csv:list                 Show all current defaults"
    caddie cli:blank
    caddie cli:title "Set Commands"
    caddie cli:indent "csv:set:<key> <value>    Keys: file, x, y, sep, plot, title, limit, save, success_filter, scatter_filter, sql, circle, rings, circle_x, circle_y, circle_r, ring_radii"
    caddie cli:title "Get Commands"
    caddie cli:indent "csv:get:<key>            Show current value"
    caddie cli:title "Unset Commands"
    caddie cli:indent "csv:unset:<key>          Clear value in this shell"
    caddie cli:blank
    caddie cli:thought "Defaults live only in the current shell session"
    return 0
}

function caddie_csv_sh_description() {
    caddie_csv_description "$@"
    return $?
}

function caddie_csv_sh_help() {
    caddie_csv_help "$@"
    return $?
}

function caddie_csv_init() {
    local script_path
    script_path=$(caddie_csv_script_path_internal) || return 1

    caddie cli:title "Setting up csvql environment"

    "$script_path" --init

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
    script_path=$(caddie_csv_script_path_internal) || return 1

    local csv_file
    if [ $# -gt 0 ] && [[ "$1" != --* ]]; then
        csv_file="$1"
        shift
    else
        csv_file=$(caddie_csv_resolve_file_argument_internal "")
    fi

    if [ -z "$csv_file" ]; then
        caddie cli:red "Error: CSV file required"
        caddie cli:usage "caddie csv:set:file <path>"
        caddie cli:thought "Or pass the file explicitly: caddie csv:query data.csv"
        return 1
    fi

    caddie cli:title "Running csvql on $csv_file"
    "$script_path" "$csv_file" "$@"
    local status=$?
    if [ $status -ne 0 ]; then
        caddie cli:red "csvql execution failed"
        return $status
    fi
    return 0
}

function caddie_csv_scatter() {
    local script_path
    script_path=$(caddie_csv_script_path_internal) || return 1

    caddie_csv_require_axes_internal || return 1

    local csv_file
    if [ $# -gt 0 ] && [[ "$1" != --* ]]; then
        csv_file="$1"
        shift
    else
        csv_file=$(caddie_csv_resolve_file_argument_internal "")
    fi

    if [ -z "$csv_file" ]; then
        caddie cli:red "Error: CSV file required"
        caddie cli:usage "caddie csv:set:file <path>"
        caddie cli:thought "Or pass the file explicitly: caddie csv:scatter data.csv"
        return 1
    fi

    local output_path=""
    if [ $# -gt 0 ] && [[ "$1" != --* ]]; then
        output_path="$1"
        shift
    fi

    local scatter_filter="${CADDIE_CSV_SCATTER_FILTER:-}"

    local scatter_args=()
    scatter_args+=("$csv_file" "--plot" "scatter")

    if [ -n "$scatter_filter" ]; then
        scatter_args+=("--success-filter" "$scatter_filter")
    fi

    if [ -n "$output_path" ]; then
        scatter_args+=("--save" "$output_path")
    fi

    if [ $# -gt 0 ]; then
        scatter_args+=("$@")
    fi

    caddie cli:title "Rendering scatter plot for $csv_file"
    "$script_path" "${scatter_args[@]}"
    local status=$?
    if [ $status -ne 0 ]; then
        caddie cli:red "Scatter plot failed"
        return $status
    fi
    return 0
}

function caddie_csv_head() {
    caddie_csv_preview_internal head "Previewing first rows" "caddie csv:head [file] [head options]" "$@"
    return $?
}

function caddie_csv_tail() {
    caddie_csv_preview_internal tail "Previewing last rows" "caddie csv:tail [file] [tail options]" "$@"
    return $?
}

export -f caddie_csv_description
export -f caddie_csv_help
export -f caddie_csv_sh_description
export -f caddie_csv_sh_help
export -f caddie_csv_list
export -f caddie_csv_init
export -f caddie_csv_query
export -f caddie_csv_scatter
export -f caddie_csv_head
export -f caddie_csv_tail
export -f caddie_csv_set_file
export -f caddie_csv_get_file
export -f caddie_csv_unset_file
export -f caddie_csv_set_x
export -f caddie_csv_get_x
export -f caddie_csv_unset_x
export -f caddie_csv_set_y
export -f caddie_csv_get_y
export -f caddie_csv_unset_y
export -f caddie_csv_set_sep
export -f caddie_csv_get_sep
export -f caddie_csv_unset_sep
export -f caddie_csv_set_plot
export -f caddie_csv_get_plot
export -f caddie_csv_unset_plot
export -f caddie_csv_set_title
export -f caddie_csv_get_title
export -f caddie_csv_unset_title
export -f caddie_csv_set_limit
export -f caddie_csv_get_limit
export -f caddie_csv_unset_limit
export -f caddie_csv_set_save
export -f caddie_csv_get_save
export -f caddie_csv_unset_save
export -f caddie_csv_set_success_filter
export -f caddie_csv_get_success_filter
export -f caddie_csv_unset_success_filter
export -f caddie_csv_set_scatter_filter
export -f caddie_csv_get_scatter_filter
export -f caddie_csv_unset_scatter_filter
export -f caddie_csv_set_sql
export -f caddie_csv_get_sql
export -f caddie_csv_unset_sql
export -f caddie_csv_set_circle
export -f caddie_csv_get_circle
export -f caddie_csv_unset_circle
export -f caddie_csv_set_rings
export -f caddie_csv_get_rings
export -f caddie_csv_unset_rings
export -f caddie_csv_set_circle_x
export -f caddie_csv_get_circle_x
export -f caddie_csv_unset_circle_x
export -f caddie_csv_set_circle_y
export -f caddie_csv_get_circle_y
export -f caddie_csv_unset_circle_y
export -f caddie_csv_set_circle_r
export -f caddie_csv_get_circle_r
export -f caddie_csv_unset_circle_r
export -f caddie_csv_set_circle_radii
export -f caddie_csv_get_circle_radii
export -f caddie_csv_unset_circle_radii
