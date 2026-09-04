# Skill Module

The Skill module installs and audits the **caddie** agent skill for Cursor, Codex, and Claude. One canonical copy lives under `~/.caddie_modules/skills/caddie`; installs are symlinks so `caddie skill:update` refreshes every link at once.

## Version model

The skill version **matches `CADDIE_SH_VERSION`**. When you release caddie, update `dot_caddie_version`, `skills/caddie/SKILL.md` frontmatter (`caddie-version`), and `RELEASE_NOTES.md` together. Users upgrade with **`make install`**, then `caddie reload` and `caddie skill:update`.

## What the skill covers

The shipped skill teaches agents **how to use caddie** — the module/plugin pattern, discovery, `caddie <module>:<command>`, prefer caddie wrappers for workspace consistency, and fall back to direct tools when needed. It does **not** catalog every module or optional plugin, and it does **not** include caddie.sh development guidelines (those live in repo `AGENTS.md` and `docs/caddie-repo-agent-guide.md` for contributors only).

Agents discover subcommands with `caddie <module>:help` or `caddie agent:exec core:module:commands <module>`. They can inspect a command with `<command> --help` or `<command>:help`, and inspect a namespace with forms such as `js:project --help` or `js:project:help`. Optional ecosystem plugins use the same discovery pattern when installed; if a module is missing, agents should use repo-native tools and say so. Plugin-specific pitfalls belong in a thin skill shipped by that plugin, not in the core skill.

See [Agent skill architecture](../skill-architecture.md) for the thin-skill contract and [Agent skill audit](../skill-audit-2026-08-27.md) for current module decisions.

### Using caddie from agents (Cursor / Codex / Claude)

The skill teaches agents to run **`caddie agent:exec`** — a **module-agnostic** wrapper that works for any **installed** module (core or plugin):

```bash
# Discover commands (works for core modules and installed plugins)
caddie agent:exec core:module:commands js
caddie agent:exec core:module:commands rust

# Run workflows
caddie agent:exec js:project:test
caddie agent:exec rust:test:unit
```

See **[Core Module — Agent and automation](core.md#agent-and-automation)** for details. The skill does not include caddie.sh development rules.

## Overview

| Path | Role |
|------|------|
| `~/.caddie_modules/skills/caddie/` | Canonical skill tree (from repo `skills/caddie/` on install) |
| `~/.cursor/skills/caddie` | Typical Cursor user install (symlink) |
| `~/.codex/skills/caddie` | Typical Codex user install (symlink) |
| `~/.claude/skills/caddie` | Typical Claude user install (symlink) |
| `.cursor/skills/caddie` | Project install in current directory (symlink) |
| `.codex/skills/caddie` | Optional project Codex install (symlink) |
| `.claude/skills/caddie` | Optional project Claude install (symlink) |
| `~/.caddie_data/skill-installs.registry` | Install audit registry |

Each install is one `install|…` line. User installs use fixed ids (`cursor-user`, `codex-user`, `claude-user`). Project installs use a per-path id (`<agent>-project-<hash>`) so multiple repositories stay registered. `skill:update` refreshes the registry header and rewrites every install line’s `recorded_version` to match caddie.

## Commands

### Install

#### `caddie skill:install` / `caddie skill:install:project`

Refresh canonical, then symlink `.cursor/skills/caddie` in the **current directory** to canonical. This legacy default remains Cursor for compatibility. Use the explicit project commands for other agents or all three.

```bash
cd ~/work/my-project
caddie skill:install
```

Consider adding `.cursor/skills/caddie` to `.gitignore` if the link should stay local.

#### Project targets

```bash
caddie skill:install:project:cursor
caddie skill:install:project:codex
caddie skill:install:project:claude
caddie skill:install:project:all
```

These link the corresponding project-local skill directories to canonical.

#### `caddie skill:install:cursor`

Symlink `~/.cursor/skills/caddie` → canonical.

#### `caddie skill:install:codex`

Symlink `~/.codex/skills/caddie` → canonical.

#### `caddie skill:install:claude`

Symlink `~/.claude/skills/caddie` → canonical.

#### `caddie skill:install:all`

User-level Cursor + Codex + Claude installs.

### Maintenance

#### `caddie skill:update`

Copy the packaged skill from `~/.caddie_modules/skills/caddie` (refreshed by **`make install`**) into the canonical directory, update the registry header version, and sync `recorded_version` on all registered install lines.

```bash
make install
caddie reload
caddie skill:update
```

#### `caddie skill:audit`

Verify canonical `SKILL.md` exists, registry version matches caddie, each registered install is a symlink to canonical, check the Cursor, Codex, and Claude user paths (including directory copies that are not yet symlinked), and list unregistered symlinks that still point at canonical.

If a user skill path is a copied directory from an older setup, its targeted `caddie skill:install:<agent>` command backs it up and replaces it with a symlink to canonical.

#### `caddie skill:info`

Show caddie version, canonical path, registry path, and install count.

## Typical workflow

```bash
# First install or upgrade from caddie.sh repo
make install
caddie reload

# User-wide agent skills
caddie skill:install:all
caddie skill:audit

# Per-repo (optional)
cd ~/work/caddie.sh
caddie skill:install
```

## Error handling

- **Target path exists but is not a symlink** — install fails; move the directory aside manually, then retry.
- **Canonical missing** — run `caddie skill:update` or **`make install`** from the caddie.sh repo.
- **Version mismatch in audit** — run `caddie skill:update` after upgrading caddie.

## Skill package layout

```
skills/caddie/
├── SKILL.md
├── agents/openai.yaml
└── references/using-caddie.md
```

Do not install into `~/.cursor/skills-cursor/` (reserved for Cursor built-ins).
