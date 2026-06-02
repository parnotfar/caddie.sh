# Skill Module

The Skill module installs and audits the **caddie** agent skill for Cursor and Codex. One canonical copy lives under `~/.caddie_modules/skills/caddie`; installs are symlinks so `caddie skill:update` refreshes every link at once.

## Version model

The skill version **matches `CADDIE_SH_VERSION`**. When you release caddie, update `dot_caddie_version`, `skills/caddie/SKILL.md` frontmatter (`caddie-version`), and `RELEASE_NOTES.md` together. Users run `make install-dot`, `caddie reload`, and `caddie skill:update`.

## Overview

| Path | Role |
|------|------|
| `~/.caddie_modules/skills/caddie/` | Canonical skill tree (from repo `skills/caddie/` on install) |
| `~/.cursor/skills/caddie` | Typical Cursor user install (symlink) |
| `~/.codex/skills/caddie` | Typical Codex user install (symlink) |
| `.cursor/skills/caddie` | Project install in current directory (symlink) |
| `~/.caddie_data/skill-installs.registry` | Install audit registry |

Each install is one `install|…` line. User installs use fixed ids (`cursor-user`, `codex-user`). Project installs use a per-path id (`cursor-project-<hash>`) so multiple repositories stay registered. `skill:update` refreshes the registry header and rewrites every install line’s `recorded_version` to match caddie.

## Commands

### Install

#### `caddie skill:install` / `caddie skill:install:project`

Refresh canonical, then symlink `.cursor/skills/caddie` in the **current directory** to canonical.

```bash
cd ~/work/my-project
caddie skill:install
```

Consider adding `.cursor/skills/caddie` to `.gitignore` if the link should stay local.

#### `caddie skill:install:cursor`

Symlink `~/.cursor/skills/caddie` → canonical.

#### `caddie skill:install:codex`

Symlink `~/.codex/skills/caddie` → canonical.

#### `caddie skill:install:all`

User-level Cursor + Codex installs.

### Maintenance

#### `caddie skill:update`

Copy the packaged skill from `~/.caddie_modules/skills/caddie` (refreshed by `make install-dot`) into the canonical directory, update the registry header version, and sync `recorded_version` on all registered install lines.

```bash
make install-dot
caddie reload
caddie skill:update
```

#### `caddie skill:audit`

Verify canonical `SKILL.md` exists, registry version matches caddie, each registered install is a symlink to canonical, check `~/.cursor/skills/caddie` and `~/.codex/skills/caddie` (including directory copies that are not yet symlinked), and list unregistered symlinks that still point at canonical.

If `~/.codex/skills/caddie` (or Cursor’s user path) is a copied directory from an older setup, `caddie skill:install:codex` backs it up and replaces it with a symlink to canonical.

#### `caddie skill:info`

Show caddie version, canonical path, registry path, and install count.

## Typical workflow

```bash
# From caddie.sh repo after clone
make install-dot
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
- **Canonical missing** — run `caddie skill:update` or `make install-dot`.
- **Version mismatch in audit** — run `caddie skill:update` after upgrading caddie.

## Skill package layout

```
skills/caddie/
├── SKILL.md
├── agents/openai.yaml
└── references/repo-guide.md
```

Do not install into `~/.cursor/skills-cursor/` (reserved for Cursor built-ins).
