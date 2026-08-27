# Caddie Repo Guide (contributors only)

Use this reference when working **inside the `caddie.sh` repository**. It is **not** shipped with the agent skill install — end-user agents get `skills/caddie/SKILL.md`, which covers **using** caddie, not developing it.

## Repository map

- `dot_caddie`: main entry point
- `dot_caddie_modules`, `dot_caddie_prompt`, `dot_caddie_version`, `dot_caddie_debug`: root system files
- `modules/dot_caddie_*`: all module implementations, including `modules/dot_caddie_core`
- `skills/caddie/`: agent skill shipped with caddie (installed to `~/.caddie_modules/skills/caddie`)
- `docs/modules/*.md`: per-module documentation for **core** modules
- `docs/plugins.md`: how optional ecosystem plugins relate to core (plugins own their own command docs)
- `Makefile`: install and development flow
- `RELEASE_NOTES.md`: required companion for release/version changes

## Core modules vs plugins

- **Core modules** live in this repo under `modules/dot_caddie_*` and are installed by `make install` / `make install-dot`.
- **Plugins** live in separate repositories. They `make install` into the same `~/.caddie_modules` directory and use the same `caddie <module>:<command>` dispatch. Do not add new plugin command docs under `docs/modules/` in this repo; document them in the plugin repo. See `docs/plugins.md`.
- **Git is a plugin (11.0+)**: `caddie git:*` and the branch prompt live in [caddie-git-tools](https://github.com/parnotfar/caddie-git-tools), not this repo. Git is a choice for agentic workflows, not a core requirement. `caddie github:*` remains in core.

## High-signal rules

- Keep module files under `modules/`.
- Name module files `dot_caddie_<module>`.
- Keep commands in `<module>:<command>` form.
- Keep functions in `caddie_<module>_<command>` form.
- Do **not** `export -f` module functions. Rely on `source` in the shell that runs commands; child shells use `~/bin/caddie` / `caddie agent:exec`.
- Source `"$HOME/.caddie_modules/.caddie_cli"` in module files.
- Use `caddie cli:*` for user-facing output.
- Include explicit `return 0` / `return 1` statements.
- Declare local variables explicitly and avoid shadowing.
- Prefer human-readable subcommands over flags.

## Output rules

Use:

- `caddie cli:red` for errors
- `caddie cli:usage` for usage lines
- `caddie cli:check` or `caddie cli:green` for success
- `caddie cli:title` for section headers
- `caddie cli:indent` for normal text
- `printf '%s\n'` for description functions that return plain text

Avoid:

- raw `echo` for normal user-facing messaging
- direct environment-variable instructions in help text when a `get` / `set` / `unset` command should exist

## New module checklist

1. Create `modules/dot_caddie_<module>`.
2. Add `caddie_<module>_description`.
3. Add `caddie_<module>_help`.
4. Add the command functions.
5. Do not export functions; modules are sourced and child shells use `caddie agent:exec`.
6. Update `Makefile` install targets so the module is copied into `~/.caddie_modules`.
7. Update `skills/caddie/` when **user-facing command usage** for agents changes (same version as `dot_caddie_version`). Do not put caddie development rules in the shipped skill.
8. Expose completion with `caddie_<module>_commands()` or `caddie_completion_register`.
9. Add or update docs in `docs/modules/`.
10. Validate with lint, install, reload, help, and targeted command checks.

Do not edit `_caddie_completion` directly.
Do not edit `dot_caddie_modules` manually.

## Existing module change checklist

1. Read the relevant module implementation and matching doc file.
2. Preserve existing command names unless the user explicitly wants a rename.
3. Update help output when commands change.
4. Keep CLI formatting and explicit returns consistent.
5. Re-run lint and the smallest meaningful runtime checks.

## Validation commands

Use the caddie-native flow:

```bash
caddie core:lint
caddie core:lint modules/dot_caddie_<module>
caddie core:lint:limit 5 modules/dot_caddie_<module>
make install          # users and releases
make install-dot      # caddie development only (fast module reinstall)
caddie reload
caddie <module>:help
```

Add targeted command execution for the change you made.

## Release rule

If the change is release-visible:

1. Update the version number in `dot_caddie_version`.
2. Update `skills/caddie/SKILL.md` `caddie-version` frontmatter to match.
3. Add the matching section in `RELEASE_NOTES.md`.
4. Ask the user which release type to use if major/minor/bugfix is not clear.

After release, users run **`make install`**, `caddie reload`, and `caddie skill:update`. Use `make install-dot` only when developing caddie itself.

## Useful local references

- `AGENTS.md`: repo-specific operating instructions
- `README.md`: project overview and architecture
- `docs/modules/core.md`: core and lint/reload behavior
- `docs/modules/profile.md`: profile sourcing and PATH snippets
- `docs/modules/skill.md`: agent skill install and audit
- `docs/modules/codex.md`: Codex CLI and review automation behavior

When the task is about a specific module, prefer that module's doc file in `docs/modules/` plus its implementation in `modules/`.
