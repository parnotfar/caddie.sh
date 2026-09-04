# Agent skill audit — August 27, 2026 (updated September 4, 2026)

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
| `caddie-weeve` / `weeve` | Keep thin skill | Conforms: multi-process sequencing, database ownership, Redis, and secret handling |
| `caddie-git-tools` / `git` | Keep thin skill | Aligned in 1.2.0 with the core 11.5 help harness; skill remains Git-policy-only |
| `caddie-cavad` / `cavad` | Keep thin skill | Aligned locally in 0.3.0 with canonical workspace paths and the core 11.5 help harness |
| `caddie-cloudflare-plugin` / `cloudflare` | Keep thin skill | Aligned in 1.2.0; skill owns production publish and verification policy, not command discovery |
| `caddie-supabase-plugin` / `supabase` | Keep thin skill | Aligned in 2.4.0; skill owns destructive and hosted-operation safeguards, not command discovery |
| `caddie-checkpt` / `ckpt` | Keep thin skill | Local 1.1.0 copy aligned with the core 11.5 help harness and canonical `/Users/wes/work/caddie` path |
| `caddie-docker-plugin` / `docker` | No separate skill | Runtime setup/start/stop is explicit and local; README intentionally documents the boundary |
| `caddie-csv-tools` / `csv` | No separate skill | Interactive analytics commands are discoverable and non-production |
| `caddie-video-tools` / `capture` | No separate skill | Local media-export wrapper; no additional agent policy |
| `caddie-markdown-preview` / `doc` | No separate skill or release | Historical worktree with stale Git metadata; audit-only until deliberately restored |
| `caddie.sh-debian` | No separate skill or release | Historical worktree with stale Git metadata; audit-only until deliberately restored |
| `caddie-cursor-plugin` | Keep bundled core guidance | Aligned in 0.3.0 with core 11.5 help while preserving live discovery and supplemental module skills |

The former `caddie-ledger` workspace was retired; Checkpt is its successor. Ledger is not an active subproject or release target.

## Release actions

- Caddie core 11.5.0 owns generated command and namespace help from registered module metadata.
- Active module repositories adopt the common help hook; PNF keeps its richer authoritative override.
- Git 1.2.0, Cavad 0.3.0, Checkpt 1.1.0, Cloudflare 1.2.0, CSV 2.5, Docker 1.1.0, PNF 2.19.0, Supabase 2.4.0, and Video 0.2.0 carry the aligned contract.
- Cursor marketplace plugin 0.3.0 documents the same live-discovery and composed-skill model.
- Historical stale worktrees are not release targets. Local Cavad and Checkpt copies cannot be committed or pushed until they have valid Git repositories/remotes.

Re-run this audit whenever a module adds production mutation, noninteractive behavior, or a workflow whose correctness depends on domain knowledge beyond CLI help.
