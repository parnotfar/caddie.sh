# Agent skill architecture

Caddie uses one shared agent language and optional domain-specific guidance. Skills support the CLI; they do not replace command discovery.

## Four layers

| Layer | Owner | Responsibility |
|---|---|---|
| Core `caddie` skill | `caddie.sh` | Discovery, `agent:exec`, CLI authority, fallback policy |
| Module CLI and help | Core harness plus owning module repository | Core generates command and namespace help from registered metadata; a module may override it with richer current usage |
| Thin `caddie-<module>` skill | Owning plugin repository | Domain semantics, safety, sequencing, and agent pitfalls |
| `AGENTS.md` | Repository being changed | Contributor and implementation rules |

There is no cross-agent skill inheritance mechanism that behaves consistently across Cursor, Codex, and Claude. Module skills therefore **compose** with the core skill and repeat only its critical execution guardrails. This is composition, not inheritance: the core skill owns the shared command structure, while an installed module skill supplies only its domain layer.

Caddie 11.5 generates baseline help for every registered command and namespace. Both `<command> --help` and `<command>:help` are valid. An optional `caddie_<module>_command_help` hook can replace that baseline with richer authoritative output, as PNF does.

## When a module needs a skill

Create a separate module skill only when at least one of these is true:

- Commands mutate production or another difficult-to-recover environment.
- Correct use requires an ordered workflow that help text alone cannot communicate safely.
- Domain terms have meanings agents commonly confuse.
- The module has important forbidden shortcuts, ownership boundaries, or fallback rules.
- Agent and noninteractive execution differs materially from interactive use.

Do not create a module skill merely because a module exists. Language managers, path inspectors, formatters, and straightforward local wrappers should use the core skill plus live discovery.

## Thin skill contract

A conforming `caddie-<module>` skill:

1. Uses a precise trigger description and the `caddie-<module>` name.
2. Tells agents to discover commands with `caddie agent:exec core:module:commands <module>` or `<module>:help`.
3. States that the installed CLI is authoritative and forbids invented shortcuts.
4. Uses `caddie agent:exec <module>:<command>` in agent shells.
5. Contains module-specific semantics, safety rules, sequencing, and fallback behavior only.
6. Avoids exhaustive command catalogs; a short non-authoritative family overview is acceptable.
7. Versions with the owning plugin and declares the plugin version in frontmatter.
8. Installs the canonical skill directory for Cursor, Codex, and Claude.
9. Keeps repository-development rules in `AGENTS.md` instead of the shipped skill.

## Installation targets

The core skill supports user-level installs at:

- `~/.cursor/skills/caddie`
- `~/.codex/skills/caddie`
- `~/.claude/skills/caddie`

Project-local installs use the corresponding `.cursor/skills`, `.codex/skills`, and `.claude/skills` directories. Installers should symlink a canonical directory rather than copy it, so updates cannot drift by agent or project.

## Versioning

The core skill version matches `CADDIE_SH_VERSION`. A plugin skill version matches its plugin release and changes independently of Caddie core. Material skill-contract or installation changes require a minor release in the owning repository.

See [Agent skill audit](skill-audit-2026-08-27.md) for the current module decisions.
