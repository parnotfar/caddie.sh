#!/usr/bin/env bash

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TMP_DIR="$(mktemp -d)"
MARKER="$TMP_DIR/ran"
trap 'rm -rf "$TMP_DIR"' EXIT

# shellcheck disable=SC1090
source "$ROOT/dot_caddie"

function caddie_dispatchtest_run() {
    printf '%s\n' "$*" > "$MARKER"
    printf '%s\n' "ran:$*"
    return 0
}

function caddie_dispatchtest_help() {
    printf '%s\n' "explicit module help"
    return 0
}

function caddie_dispatchtest_staging_help() {
    printf '%s\n' "explicit namespace help"
    return 0
}

function caddie_dispatchtest_command_help() {
    case "$1" in
        dispatchtest:run) printf '%s\n' "Usage: caddie $1" ;;
        dispatchtest:group) printf '%s\n' "Usage: caddie $1:<command>" ;;
        *) return 1 ;;
    esac
    return 0
}

output="$(caddie dispatchtest:run --help)"
[ "$output" = "Usage: caddie dispatchtest:run" ]
[ ! -e "$MARKER" ]

output="$(caddie dispatchtest:run:help)"
[ "$output" = "Usage: caddie dispatchtest:run" ]
[ ! -e "$MARKER" ]

output="$(caddie dispatchtest:run value)"
[ "$output" = "ran:value" ]
[ "$(cat "$MARKER")" = "value" ]

output="$(caddie dispatchtest:help)"
[ "$output" = "explicit module help" ]

output="$(caddie dispatchtest:staging --help)"
[ "$output" = "explicit namespace help" ]

output="$(caddie dispatchtest:staging -h)"
[ "$output" = "explicit namespace help" ]

output="$(caddie dispatchtest:group --help)"
[ "$output" = "Usage: caddie dispatchtest:group:<command>" ]

output="$(caddie dispatchtest:group:help)"
[ "$output" = "Usage: caddie dispatchtest:group:<command>" ]

printf '%s\n' 'PASS command-level help dispatch'
