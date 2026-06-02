---
name: caddie
description: Guide for working in the Par Not Far caddie.sh repository. Use when modifying or reviewing caddie modules, adding a new module, updating caddie-specific Bash workflows, touching Makefile installation logic, adjusting command completion, or validating repo conventions such as `caddie cli:*` output, linting, reload, and release-note/version requirements.
caddie-version: "9.3.4"
---

# Caddie

Treat this repository as a modular Bash system with project-specific conventions. Start by reading the local `AGENTS.md`, then inspect only the relevant module files, docs, and Makefile sections before editing.

## Core workflow

1. Identify the affected module or root file.
2. Read the local guidance in `AGENTS.md` plus the specific module docs or implementation files you need.
3. Make the smallest coherent change that fits existing naming and output conventions.
4. Validate with repo-native commands before stopping.

## Implementation rules

- Keep module files in `modules/dot_caddie_<module>`. Do not create module files at repo root.
- Keep function names in `caddie_<module>_<command>` form and export public functions with `export -f`.
- Source the CLI formatter in module files and use `caddie cli:*` helpers for user-facing output. Avoid raw `echo` or `printf` except for description functions or machine-readable output.
- Prefer descriptive subcommands over flags for user-facing behaviors.
- When a module depends on environment variables for configuration, provide `get` / `set` / `unset` commands instead of relying on direct environment-variable usage in help text.
- For new modules, update the Makefile install flow and expose completion with `caddie_<module>_commands()` or `caddie_completion_register`. Do not edit `_caddie_completion` directly. Do not modify `dot_caddie_modules` manually.
- If the work introduces release-visible functionality, update the version and `RELEASE_NOTES.md`. The agent skill version matches `CADDIE_SH_VERSION` — bump both together.

## Validation

Run the repo workflow whenever feasible:

- `caddie core:lint` on changed files or the repo
- `make install-dot`
- `caddie reload`
- `caddie <module>:help`
- Targeted command checks for the changed behavior

If a command cannot run in the current environment, say so explicitly and note what remains unverified.

## Agent skill installs

Users install this skill via caddie (canonical copy + symlinks):

- `caddie skill:install` — project `.cursor/skills/caddie` in the current directory
- `caddie skill:install:cursor` / `:codex` / `:all` — user-level agent paths
- `caddie skill:update` — refresh canonical skill after `make install-dot`
- `caddie skill:audit` — verify symlinks and version match installed caddie

## References

- Read `references/repo-guide.md` for the repo map, checklists, and high-signal rules.
- For Codex-specific automation or review behavior, inspect the local `docs/modules/codex.md` and `modules/dot_caddie_codex`.
- For profile and PATH setup, see `docs/modules/profile.md` and `modules/dot_caddie_profile`.
