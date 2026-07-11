# Command workspace guide

## Skill vs CLI

| | Skill | Caddie CLI |
|--|-------|------------|
| Purpose | How to use caddie | Actual commands |
| Command list | Never authoritative | Always authoritative |

Query the CLI before running module commands.

## Agent shells — use `caddie agent:exec`

**Module-agnostic** — works for every installed module, not JavaScript only:

| Module | Discover | Example run |
|--------|----------|-------------|
| `js` | `caddie agent:exec core:module:commands js` | `caddie agent:exec js:project:test` |
| `rust` | `caddie agent:exec core:module:commands rust` | `caddie agent:exec rust:test:unit` |
| `python` | `caddie agent:exec core:module:commands python` | `caddie agent:exec python:test` |
| `git` | `caddie agent:exec core:module:commands git` | `caddie agent:exec git:status` |
| `github` | `caddie agent:exec core:module:commands github` | `caddie agent:exec github:account:get` |
| `core` | `caddie agent:exec core:module:commands core` | `caddie agent:exec core:lint` |

Codex and similar tools often inherit a broken Bash environment. The public entry point:

```bash
caddie agent:exec <module:command> [args...]
```

`~/bin/caddie` dispatches `agent:exec` to a clean subprocess before loading caddie in the parent shell. Do **not** use internal `~/.caddie_modules/bin/` paths.

`caddie core:agent:exec` is equivalent when caddie already works in the parent shell.

### When the parent shell already works

```bash
caddie core:module:commands js
caddie js:help
caddie js:project:test
```

## Command discovery

```bash
caddie agent:exec core:module:commands js   # best in agent shells
caddie js:help                              # when caddie loads normally
```

**Wrong:** `js:project:help`, `js:build`, `js:dev`, `js:init`.

**Right:** `js:project:build`, `js:project:test`, `js:package:run build`.

## JavaScript workflows

```bash
caddie agent:exec js:project:install
caddie agent:exec js:project:test
caddie agent:exec js:project:build
caddie agent:exec js:project:serve
caddie agent:exec js:package:run <script>
caddie agent:exec js:package:run typecheck -- --incremental false
```

Pass npm script arguments after `--`. Each `agent:exec` is a new subprocess — use **`.nvmrc`** for Node version (not a separate `js:use` call). Check the exit code; failures must not be treated as success.

## When to use caddie vs direct commands

| Use caddie | Use direct command |
|------------|-------------------|
| Command listed by `core:module:commands` or module help | No wrapper exists |
| User standardized on caddie for this stack | `caddie agent:exec` fails after install is verified |

Always state when you bypass caddie.

## Other modules

```bash
caddie agent:exec core:module:commands git
caddie agent:exec core:module:commands python
caddie agent:exec git:status
```
