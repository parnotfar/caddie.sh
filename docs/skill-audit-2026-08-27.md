# Agent skill audit — August 27, 2026

This audit applies the [agent skill architecture](skill-architecture.md) to the core modules and locally available ecosystem repositories. “No separate skill” is an intentional compliant outcome when live CLI discovery is sufficient.

## Core modules

All core modules are covered by the shared `caddie` skill. None currently justify a second shipped skill.

| Module | Decision | Reason |
|---|---|---|
| `core` | No separate skill | Defines the shared runtime and discovery protocol |
| `skill` | No separate skill | Installation behavior is documented by core skill and module help |
| `cli`, `debug`, `profile` | No separate skill | Internal/local support utilities |
| `system`, `homebrew`, `mac` | No separate skill | Direct inspection and local utility commands |
| `python`, `ruby`, `rust`, `swift`, `js` | No separate skill | Language wrappers are discoverable and have no domain policy |
| `cross`, `doc`, `mcp` | No separate skill | Straightforward local workflows |
| `cursor`, `codex`, `claude` | No separate skill | Agent-tool integrations remain command-driven |
| `github` | No separate skill | Account/repository operations are represented by explicit commands |
| `ios` | No separate skill currently | Distribution commands remain explicit; reassess if release policy grows beyond CLI safeguards |

## Ecosystem modules

| Repository / module | Decision | Audit result or required action |
|---|---|---|
| `caddie-pnf` / `pnf` | Keep thin skill | Conforms: substantial environment, production, migration, and data-safety semantics |
| `caddie-canada` / `canada` | Keep thin skill | Conforms: publish safety and workspace-specific ownership boundaries |
| `caddie-checkpt` / `ckpt` | Keep thin skill | Conforms: product/command boundary and production publish policy |
| `caddie-weeve` / `weeve` | Keep thin skill | Conforms: multi-process sequencing, database ownership, Redis, and secret handling |
| `caddie-git-tools` / `git` | Keep and normalize skill | Aligned in 1.1.0: canonical Cursor, Codex, and Claude installation lifecycle |
| `caddie-cavad` / `cavad` | Keep and normalize skill | Aligned in 0.2.0: version metadata, Codex support, and canonical directory links |
| `caddie-cloudflare-plugin` / `cloudflare` | Add thin skill | Added in 1.1.0 for production publish, pinned Wrangler, build verification, and live verification policy |
| `caddie-supabase-plugin` / `supabase` | Add thin skill | Added in 2.3.0 for destructive rebuilds, hosted operations, migration identity, and explicit noninteractive forms |
| `caddie-ledger` / `ledger` | Skill required before release | Agent-state restore/sync semantics justify a skill, but repository is an in-progress core fork and must first become a versioned plugin package |
| `caddie-docker-plugin` / `docker` | No separate skill | Runtime setup/start/stop is explicit and local; README intentionally documents the boundary |
| `caddie-csv-tools` / `csv` | No separate skill | Interactive analytics commands are discoverable and non-production |
| `caddie-video-tools` / `capture` | No separate skill | Local media-export wrapper; no additional agent policy |
| `caddie-sh-markdown-preview` / `doc` | No separate skill | Historical worktree/fork, not a separately released skill owner |
| `caddie-cursor-plugin` | Replace stale bundled guidance | Aligned in 0.2.0: bundled skills now use live discovery and no longer present optional modules as core |

## Release actions

- Caddie core 11.3.0: cross-agent contract and Claude installation/audit support.
- Git 1.1.0, Cavad 0.2.0, Cloudflare 1.1.0, and Supabase 2.3.0: skill lifecycle or new thin skills.
- Cursor marketplace plugin 0.2.0: live-discovery replacement for its stale command catalog.
- PNF, Canada, Checkpt, and Weeve: no skill-only release required from this audit because their existing skills already conform.
- Ledger: no release until plugin extraction and version ownership are resolved.

Re-run this audit whenever a module adds production mutation, noninteractive behavior, or a workflow whose correctness depends on domain knowledge beyond CLI help.
