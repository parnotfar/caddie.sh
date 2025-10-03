#!/usr/bin/env bash

# Caddie.sh - CSV/TSV analytics helpers
# Provides wrappers around csvql.py for querying and plotting data

source "$HOME/.caddie_modules/.caddie_cli"

function caddie_csv__initialize_globals() {
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
        [hole]=CADDIE_CSV_HOLE
        [rings]=CADDIE_CSV_RINGS
        [hole_x]=CADDIE_CSV_HOLE_X
        [hole_y]=CADDIE_CSV_HOLE_Y
        [hole_r]=CADDIE_CSV_HOLE_R
        [ring_radii]=CADDIE_CSV_RING_RADII
    )

    declare -ga CADDIE_CSV_KEY_ORDER=(
        file x y sep plot title limit save success_filter scatter_filter sql hole rings hole_x hole_y hole_r ring_radii
    )
}

caddie_csv__initialize_globals

function caddie_csv__env_name() {
    local alias="$1"
    local env_name="${CADDIE_CSV_ENV_MAP[$alias]}"
    if [ -z "$env_name" ]; then
        caddie cli:red "Internal error: unknown csv key '$alias'"
        return 1
    fi
    printf '%s' "$env_name"
    return 0
}

function caddie_csv__set_alias() {
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
    env=$(caddie_csv__env_name "$alias") || return 1
    export "$env=$value"
    caddie cli:check "Set ${alias//_/ } to $value"
    return 0
}

function caddie_csv__show_alias() {
    local alias="$1"
    local env
    env=$(caddie_csv__env_name "$alias") || return 1
    local value="${!env:-}"

    if [ -n "$value" ]; then
        caddie cli:package "${alias//_/ } = $value"
    else
        caddie cli:warning "${alias//_/ } not set"
    fi
    return 0
}

function caddie_csv__unset_alias() {
    local alias="$1"
    local env
    env=$(caddie_csv__env_name "$alias") || return 1
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
    local alias env value
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

function caddie_csv_set_file()          { caddie_csv__set_alias file "caddie csv:set:file <path>" "$@"; }
function caddie_csv_get_file()          { caddie_csv__show_alias file; }
function caddie_csv_unset_file()        { caddie_csv__unset_alias file; }

function caddie_csv_set_x()             { caddie_csv__set_alias x "caddie csv:set:x <column>" "$@"; }
function caddie_csv_get_x()             { caddie_csv__show_alias x; }
function caddie_csv_unset_x()           { caddie_csv__unset_alias x; }

function caddie_csv_set_y()             { caddie_csv__set_alias y "caddie csv:set:y <column>" "$@"; }
function caddie_csv_get_y()             { caddie_csv__show_alias y; }
function caddie_csv_unset_y()           { caddie_csv__unset_alias y; }

function caddie_csv_set_sep()           { caddie_csv__set_alias sep "caddie csv:set:sep <separator>" "$@"; }
function caddie_csv_get_sep()           { caddie_csv__show_alias sep; }
function caddie_csv_unset_sep()         { caddie_csv__unset_alias sep; }

function caddie_csv_set_plot()          { caddie_csv__set_alias plot "caddie csv:set:plot <scatter|line|bar>" "$@"; }
function caddie_csv_get_plot()          { caddie_csv__show_alias plot; }
function caddie_csv_unset_plot()        { caddie_csv__unset_alias plot; }

function caddie_csv_set_title()         { caddie_csv__set_alias title "caddie csv:set:title <text>" "$@"; }
function caddie_csv_get_title()         { caddie_csv__show_alias title; }
function caddie_csv_unset_title()       { caddie_csv__unset_alias title; }

function caddie_csv_set_limit()         { caddie_csv__set_alias limit "caddie csv:set:limit <rows>" "$@"; }
function caddie_csv_get_limit()         { caddie_csv__show_alias limit; }
function caddie_csv_unset_limit()       { caddie_csv__unset_alias limit; }

function caddie_csv_set_save()          { caddie_csv__set_alias save "caddie csv:set:save <path>" "$@"; }
function caddie_csv_get_save()          { caddie_csv__show_alias save; }
function caddie_csv_unset_save()        { caddie_csv__unset_alias save; }

function caddie_csv_set_success_filter(){ caddie_csv__set_alias success_filter "caddie csv:set:success_filter <predicate>" "$@"; }
function caddie_csv_get_success_filter(){ caddie_csv__show_alias success_filter; }
function caddie_csv_unset_success_filter(){ caddie_csv__unset_alias success_filter; }

function caddie_csv_set_scatter_filter(){ caddie_csv__set_alias scatter_filter "caddie csv:set:scatter_filter <predicate>" "$@"; }
function caddie_csv_get_scatter_filter(){ caddie_csv__show_alias scatter_filter; }
function caddie_csv_unset_scatter_filter(){ caddie_csv__unset_alias scatter_filter; }

function caddie_csv_set_sql()           { caddie_csv__set_alias sql "caddie csv:set:sql <query>" "$@"; }
function caddie_csv_get_sql()           { caddie_csv__show_alias sql; }
function caddie_csv_unset_sql()         { caddie_csv__unset_alias sql; }

function caddie_csv_set_hole()          { caddie_csv__set_alias hole "caddie csv:set:hole <on|off>" "$@"; }
function caddie_csv_get_hole()          { caddie_csv__show_alias hole; }
function caddie_csv_unset_hole()        { caddie_csv__unset_alias hole; }

function caddie_csv_set_rings()         { caddie_csv__set_alias rings "caddie csv:set:rings <on|off>" "$@"; }
function caddie_csv_get_rings()         { caddie_csv__show_alias rings; }
function caddie_csv_unset_rings()       { caddie_csv__unset_alias rings; }

function caddie_csv_set_hole_x()        { caddie_csv__set_alias hole_x "caddie csv:set:hole_x <value>" "$@"; }
function caddie_csv_get_hole_x()        { caddie_csv__show_alias hole_x; }
function caddie_csv_unset_hole_x()      { caddie_csv__unset_alias hole_x; }

function caddie_csv_set_hole_y()        { caddie_csv__set_alias hole_y "caddie csv:set:hole_y <value>" "$@"; }
function caddie_csv_get_hole_y()        { caddie_csv__show_alias hole_y; }
function caddie_csv_unset_hole_y()      { caddie_csv__unset_alias hole_y; }

function caddie_csv_set_hole_r()        { caddie_csv__set_alias hole_r "caddie csv:set:hole_r <value>" "$@"; }
function caddie_csv_get_hole_r()        { caddie_csv__show_alias hole_r; }
function caddie_csv_unset_hole_r()      { caddie_csv__unset_alias hole_r; }

function caddie_csv_set_ring_radii()    { caddie_csv__set_alias ring_radii "caddie csv:set:ring_radii <r1,r2,...>" "$@"; }
function caddie_csv_get_ring_radii()    { caddie_csv__show_alias ring_radii; }
function caddie_csv_unset_ring_radii()  { caddie_csv__unset_alias ring_radii; }

function caddie_csv__script_path() {
    # Prefer the installed helper under ~/.caddie_modules/bin, fall back to repo copy.
    local module_dir repo_candidate
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

function caddie_csv__require_axes() {
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

function caddie_csv__resolve_file_argument() {
    local provided="$1"
    if [ -n "$provided" ]; then
        printf '%s' "$provided"
        return 0
    fi
    printf '%s' "${CADDIE_CSV_FILE:-}"
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
    caddie cli:blank
    caddie cli:title "Session Defaults"
    caddie cli:indent "csv:list                 Show all current defaults"
    caddie cli:blank
    caddie cli:title "Set Commands"
    caddie cli:indent "csv:set:<key> <value>    Keys: file, x, y, sep, plot, title, limit, save, success_filter, scatter_filter, sql, hole, rings, hole_x, hole_y, hole_r, ring_radii"
    caddie cli:title "Get Commands"
    caddie cli:indent "csv:get:<key>            Show current value"
    caddie cli:title "Unset Commands"
    caddie cli:indent "csv:unset:<key>          Clear value in this shell"
    caddie cli:blank
    caddie cli:thought "Defaults live only in the current shell session"
    return 0
}

function caddie_csv_init() {
    local script_path
    script_path=$(caddie_csv__script_path) || return 1

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
    "$script_path" "${args[@]}"
    local status=$?
    if [ $status -ne 0 ]; then
        caddie cli:red "Scatter plot failed"
        return $status
    fi
    return 0
}

export -f caddie_csv_description
export -f caddie_csv_help
export -f caddie_csv_list
export -f caddie_csv_init
export -f caddie_csv_query
export -f caddie_csv_scatter
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
export -f caddie_csv_set_hole
export -f caddie_csv_get_hole
export -f caddie_csv_unset_hole
export -f caddie_csv_set_rings
export -f caddie_csv_get_rings
export -f caddie_csv_unset_rings
export -f caddie_csv_set_hole_x
export -f caddie_csv_get_hole_x
export -f caddie_csv_unset_hole_x
export -f caddie_csv_set_hole_y
export -f caddie_csv_get_hole_y
export -f caddie_csv_unset_hole_y
export -f caddie_csv_set_hole_r
export -f caddie_csv_get_hole_r
export -f caddie_csv_unset_hole_r
export -f caddie_csv_set_ring_radii
export -f caddie_csv_get_ring_radii
export -f caddie_csv_unset_ring_radii
