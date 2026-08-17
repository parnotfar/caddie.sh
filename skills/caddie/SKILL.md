---
name: caddie
description: Use the caddie CLI to keep development commands consistent across projects. The skill is usage guidance only — never treat it as the command list. Discover commands with caddie core:module:commands or caddie module:help. In agent shells use caddie agent:exec. Prefer caddie module:command over ad-hoc npm/cargo/git when wrappers exist. Optional plugins use the same discovery pattern when installed.
caddie-version: "11.0.0"
---

# Caddie — command workspace

**This skill is not the command list.** It tells you *how* to use caddie. The CLI is authoritative — always query it before running module commands.

```bash
caddie <module>:<command> [args]
```

## Agent rules (read first)

1. **Skill ≠ CLI** — Do not infer commands from the skill text, completion metadata, or memory. Query the installed CLI.
2. **Discover commands** — `caddie agent:exec core:module:commands <module>` or `caddie <module>:help` (when the shell already loads caddie).
3. **No nested `:help`** — `js:project:help` does not exist. Use `caddie js:help`.
4. **No invented shortcuts** — `js:build`, `js:dev`, `js:start` are **wrong**. Use `js:project:build`, `js:project:serve`, `js:package:run <script>`.
5. **Prefer caddie** when a listed command matches the task; **fall back explicitly** to native tools when caddie cannot load or the module is not installed.
6. **Agent shells** — Use **`caddie agent:exec`** for any module (core or plugin). Never use `~/.caddie_modules/bin/caddie-agent-exec` or other internal install paths.
7. **Exit codes** — Treat non-zero exit from `caddie agent:exec` as command failure; do not assume success from output alone.
8. **Node version** — Each `agent:exec` starts a fresh subprocess. Pin Node with a project **`.nvmrc`** (honored automatically), not a prior `js:use` in another invocation.
9. **Optional plugins** — Ecosystem modules may be installed separately. Never assume a plugin exists; discover it, then use it. If discovery fails, use repo-native tools and say so.
10. **No inherited caddie functions** — Caddie 10+ does not export module functions into `BASH_FUNC_*`. If a child shell needs caddie, source it or use `caddie agent:exec` / `~/bin/caddie`.

## Modules and plugins (same pattern)

Core modules ship with caddie. Optional plugins install into the same module directory and use the same command shape:

```bash
caddie <module>:<command>
caddie agent:exec <module>:<command>
```

**Do not memorize plugin command lists in this skill.** For any module name (known or suspected):

```bash
caddie agent:exec core:module:commands <module>
caddie agent:exec <module>:help
```

If the module is not installed, discovery fails — fall back to the project's native commands (Make, CLI, etc.) and state that the caddie module was unavailable.

Plugin-specific agent pitfalls (when needed) belong in a **separate** thin skill shipped by that plugin — not in this core skill.

## Agent / Codex shells (all modules)

`caddie agent:exec` is **not JavaScript-only**. Pass any valid caddie command for an **installed** module:

```bash
caddie agent:exec core:module:commands rust
caddie agent:exec rust:test:unit
caddie agent:exec python:test
caddie agent:exec rust:test:unit
caddie agent:exec js:project:build
```

If `caddie agent:exec` fails, use native project commands (`npm test`, etc.) and state that caddie was unavailable.

## JavaScript mapping (common mistakes)

| Wrong | Right |
|-------|-------|
| `js:build` | `js:project:build` |
| `js:test` | `js:project:test` |
| `js:dev` / `js:start` | `js:project:serve` or `js:package:run <script>` |
| `js:init` | `js:project:init` |
| `js:add` | `js:package:install` |

## Reference

**`references/using-caddie.md`** — full usage guide, discovery pattern, and fallback policy.

## Skill updates

After the user upgrades caddie from the caddie.sh repo: **`make install`**, `caddie reload`, then `caddie skill:update`.

After installing or updating an optional plugin in another repo (`make install`), refresh that module without leaving the shell:

```bash
caddie core:module:reload csv
# or inside caddie|csv> type: reload
```
