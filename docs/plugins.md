# Optional plugins (ecosystem modules)

Caddie can load modules that are **not** shipped in the core [caddie.sh](https://github.com/parnotfar/caddie.sh) repository. Those live in separate repos (for example [caddie-git-tools](https://github.com/parnotfar/caddie-git-tools) and [caddie-csv-tools](https://github.com/parnotfar/caddie-csv-tools)).

## Why git left core (11.0)

Caddie 11 treats git as an optional plugin because **git is a choice, not a requirement**.

Core caddie is the shared language for toolchains and agents. Git is one workflow in that language. Shipping it in every install — and printing branch status in every prompt — made version control look mandatory. That is a bad default for agent shells, sandboxes, and work that is not a git checkout.

Install [caddie-git-tools](https://github.com/parnotfar/caddie-git-tools) when you want `caddie git:*`. Turn the prompt on per repository with `caddie git:prompt:on`. If the plugin is not installed, agents should use native git or skip it, and say so.

## Architecture

```text
caddie.sh
  make install  →  ~/.caddie_modules/.caddie_<core modules>
                   ~/.caddie_modules/skills/caddie   (core agent skill)

plugin repo (separate)
  make install  →  ~/.caddie_modules/.caddie_<plugin>

caddie reload   →  sources every ~/.caddie_modules/.caddie_*
caddie <mod>:*  →  same dispatch for core and plugins
```

| Concern | Owner |
|---------|--------|
| Core CLI, install, discovery protocol, core skill | caddie.sh |
| Plugin commands, docs, version, optional thin skill | Plugin repository |
| Application config (compose, `supabase/`, `.env.local`, …) | Application repository |

## Agent skill boundary

The **core** skill teaches *how* to discover and run modules. It does **not** catalog optional plugins. Agents should:

1. Discover with `caddie agent:exec core:module:commands <module>` or `caddie <module>:help`
2. Run only listed commands
3. If the module is not installed, use repo-native tools and say so

Plugin-specific agent pitfalls belong in a thin skill shipped by that plugin (when needed).

The decision is intentional, not automatic. Use the [agent skill architecture](skill-architecture.md) to decide whether a plugin needs a skill, and record ecosystem-wide decisions in the [agent skill audit](skill-audit-2026-08-27.md).

## Writing a plugin

Follow the same module conventions as core (`caddie_<module>_*`, `caddie cli:*`, `caddie_<module>_commands`). Do **not** `export -f` module functions (caddie 10.0+): they are available once the module is sourced, and child shells should use `caddie` / `caddie agent:exec`. In addition:

- Ship in a separate repo with its own `Makefile` `install` → `~/.caddie_modules/.caddie_<name>`
- Version independently of `CADDIE_SH_VERSION`
- Keep documentation in the plugin repo
- Do **not** add per-plugin pages under core `docs/modules/` (CSV is the historical ecosystem example; new plugins document themselves)

See [Module documentation index](modules/README.md) and [Contributing](contributing.md) for core module conventions.
