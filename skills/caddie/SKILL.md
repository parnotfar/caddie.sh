---
name: caddie
description: Use the caddie CLI to keep development commands consistent across projects. The skill is usage guidance only — never treat it as the command list. Discover commands with caddie core:module:commands or caddie module:help. In agent shells use caddie agent:exec. Prefer caddie module:command over ad-hoc npm/cargo/git when wrappers exist.
caddie-version: "9.3.5"
---

# Caddie — command workspace

**This skill is not the command list.** It tells you *how* to use caddie. The CLI is authoritative — always query it before running module commands.

```bash
caddie <module>:<command> [args]
```

## Agent rules (read first)

1. **Skill ≠ CLI** — Do not infer commands from the skill text, completion metadata, or memory. Query the installed CLI.
2. **Discover commands** — `caddie agent:exec core:module:commands js` or `caddie js:help` (when the shell already loads caddie).
3. **No nested `:help`** — `js:project:help` does not exist. Use `caddie js:help`.
4. **No invented shortcuts** — `js:build`, `js:dev`, `js:start` are **wrong**. Use `js:project:build`, `js:project:serve`, `js:package:run <script>`.
5. **Prefer caddie** when a listed command matches the task; **fall back explicitly** to native tools when caddie cannot load.
6. **Agent shells** — Use **`caddie agent:exec`** for any module (JS, Rust, Python, git, …). Do not use internal install paths.

## Agent / Codex shells (all modules)

`caddie agent:exec` is **not JavaScript-only**. Pass any valid caddie command:

```bash
caddie agent:exec core:module:commands rust
caddie agent:exec rust:test:unit
caddie agent:exec python:test
caddie agent:exec git:status
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

**`references/using-caddie.md`** — full usage guide and fallback policy.

## Skill updates

After the user upgrades caddie: `caddie skill:update`.
