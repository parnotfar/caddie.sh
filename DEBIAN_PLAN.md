# Debian Portability Plan (Feature/Debian)

## Understanding

Goal: Evaluate the legacy bashy Makefile and supporting scripts, assess portability to caddie, and propose a Debian-ready path that keeps caddie modular, production-friendly, and consistent with current standards. Work happens on branch `feature/debian` in worktree `../caddie.sh-debian`.

## Bashy Makefile Dependency Map (Old System)

### OS Prerequisites (Makefile targets)
- **macOS**: Homebrew, Docker Desktop, `jq`, `ack`, `gnumeric`, `heroku`, `bash`, `tree`
- **Ubuntu/Debian**: `apt-get update`, `apt-get install jq ack linuxbrew-wrapper gnumeric`, `snap install heroku`

### Files Copied Into `$HOME` (install-base)
- Shell: `dot_bash_profile`, `dot_bashrc`
- Prompts/versions: `dot_bashy_version`, `dot_bashy_prompt`, `dot_bash_profile_data_shell`, `dot_bash_profile_ram_shell`, `dot_ram_shell_prompt`, `dot_pg_prompt`, `dot_api_prompt`, `dot_ruby_warning_prompt`
- Carrum secrets: `dot_carrum_app_secret`, `dot_carrum_id_secret`, `dot_slack_api_token`
- Command functions: `dot_ch_function`, `dot_csv_function`, `dot_s_function`, `dot_h_function`, `dot_sftp_server_function`, `dot_job_server_function`, `dot_redirect_server_function`
- Support prompts: `dot_ch_prompt`, `dot_csv_prompt`, `dot_s_prompt`, `dot_h_prompt`
- Make helpers: `dot_makecommons` -> `${HOME}/.make-commons`

### Library Trees Copied Into `$HOME`
- `lib/ch_function/`, `lib/csv_function/`, `lib/h_function/`
- `lib/sftp_server_function/`, `lib/job_server_function/`, `lib/redirect_server_function/`
- (Legacy) `lib/ingest_mirror_server_function/` referenced by uninstall

### Notable Uninstall Items
- Removes legacy CI and ingest-mirror function files that are no longer installed. This signals historical drift and reinforces the need for a scoped, modular Debian plan.

## Reusable Patterns from bashy `lib/`

1) **Get/Set/Reset env workflows**
   - Example: `*_get`, `*_set`, `*_reset` functions for environment variables and selections.
   - Maps cleanly to caddie’s `get/set/unset` pattern.

2) **Help/usage functions**
   - `*_list_help` files centralize command help and discovery.
   - Caddie can absorb this into module `help` with CLI formatting.

3) **Remote server administration**
   - SSH-based actions such as apt update/upgrade, config edits, and host targeting.
   - Useful for a production-focused Debian module (server ops + package mgmt).

4) **Operational grouping**
   - Commands grouped by domain: server, pipeline, app, data, etc.
   - Mirrors caddie module boundaries.

## Portability Assessment to Current Caddie

### Good Fits
- Env variable workflows can be re-expressed using caddie get/set/unset commands.
- Server/ops commands are modular and can be isolated into new Debian-focused modules.
- Help patterns map to `caddie <module>:help`.

### Poor Fits / Adjustments Needed
- Hard-coded secrets and Carrum-specific files are not suitable for caddie core.
- Many bashy functions use `echo`, hyphenated function names, and direct env access.
- macOS-specific tooling (Homebrew, Docker Desktop, Terminal behaviors) doesn’t map to Debian servers.
- Snap usage for Heroku may be undesired on production machines.

## Proposed Debian Module Set (Draft)

### Core (existing)
- `core`, `cli`, `git`, `debug`

### Dev-Friendly Modules (optional on servers)
- `python`, `rust`, `js`, `cross`, `mcp` (if needed)

### New Debian/Production Modules (proposed)
- `debian`: apt/apt-get helpers, package audit, upgrade, autoremove, clean
- `server`: SSH helpers, host/user config get/set/unset, systemd shortcuts
- `audit`: security updates, unattended-upgrades checks, log summaries
- `service`: `systemctl` wrappers for restart/status/logs

Each module must follow caddie patterns: help/description, exported functions, get/set/unset for config.

## Install Target Outline (caddie Makefile)

1) **New target**: `install-debian`
   - Installs only Debian-appropriate modules.
   - Avoids macOS-only modules (`ios`, `swift`, `cursor`, etc.).

2) **New prereqs target**: `setup-debian` or `prereqs-debian`
   - `apt-get update`
   - Install baseline tools: `curl`, `git`, `jq`, `ripgrep`, `ca-certificates`, `build-essential`, `bash`
   - Optional tools for dev work: `python3`, `pip`, `node`, `cargo` (or leave to modules)

3) **Module install segregation**
   - Keep `install-dot` as the general copy logic, but allow a Debian install path that copies only the chosen modules.
   - Consider an OS guard in install steps or a module manifest list.

## Minimal Debian MVP (First Release Scope)

### Must-Have
- Debian install target + prerequisites
- Core modules (core, cli, git, debug)
- New `debian` module with:
  - `debian:pkg:update`, `debian:pkg:upgrade`, `debian:pkg:install`, `debian:pkg:remove`, `debian:pkg:clean`
  - `debian:pkg:autoremove`, `debian:pkg:search`
- Simple `server` module with:
  - `server:host:set|get|unset`, `server:user:set|get|unset`
  - `server:ssh`, `server:service:status`, `server:service:restart`

### Nice-to-Have (Post-MVP)
- `audit` module with security update checks
- `service` module for journald logs and service list
- Debian-specific docs and troubleshooting

## Documentation Plan

- Add `docs/installation.md` Debian section with `make install-debian` flow
- Add `docs/modules/debian.md` and `docs/modules/server.md`
- Update `README.md` feature list to mention Debian support

## Worktree / Branch Workflow

- Branch: `feature/debian`
- Worktree: `../caddie.sh-debian`
- All Debian work lands here to keep macOS work isolated.

## Next Actions (Execution Order)

1) Inventory current caddie modules and label as mac-only vs cross-platform.
2) Define Debian module list and install target semantics.
3) Draft Debian install docs and module docs.
4) Implement Debian targets and modules in the worktree.
5) Run `caddie core:lint` on all modified shell files.
