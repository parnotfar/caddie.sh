# Ledger Module

The Ledger module adds local-first "Checkpoint Capsules" for agentic workflows.

## Command Syntax

All commands use:

```bash
caddie ledger:<command> [args]
```

Phase 1 commands:

- `caddie ledger:project:init`
- `caddie ledger:session:start [agents...]` (also sets watched agents for session)
- `caddie ledger:session:end`
- `caddie ledger:agent:watch <agents...>`
- `caddie ledger:agent:watch:list`
- `caddie ledger:agent:watch:clear`
- `caddie ledger:collect`
- `caddie ledger:checkpoint [message]` (also runs `ledger:collect` automatically)
- `caddie ledger:artifact <path>`
- `caddie ledger:list`
- `caddie ledger:restore <checkpoint_id> [target_dir]`

Phase 2 sync commands:

- `caddie ledger:schema:sql`
- `caddie ledger:schema:init [db_host|postgres_url]`
- `caddie ledger:schema:init:dry:run`
- `caddie ledger:schema:db:url:set <db_host|postgres_url>`
- `caddie ledger:schema:db:url:get`
- `caddie ledger:schema:db:url:unset`
- `caddie ledger:schema:db:user:set <user>`
- `caddie ledger:schema:db:user:get`
- `caddie ledger:schema:db:user:unset`
- `caddie ledger:schema:db:port:set <port>`
- `caddie ledger:schema:db:port:get`
- `caddie ledger:schema:db:port:unset`
- `caddie ledger:schema:db:name:set <database_name>`
- `caddie ledger:schema:db:name:get`
- `caddie ledger:schema:db:name:unset`
- `caddie ledger:schema:db:password:set [password]` (prompts securely when omitted)
- `caddie ledger:schema:db:password:get`
- `caddie ledger:schema:db:password:unset`
- `caddie ledger:auth:set <supabase_url> <supabase_anon_key> <project_id> [snapshots_bucket] [transcripts_bucket] [artifacts_bucket]`
- `caddie ledger:auth:get`
- `caddie ledger:auth:unset`
- `caddie ledger:sync:check`
- `caddie ledger:sync:push [checkpoint_id|latest|all]`
- `caddie ledger:sync:pull <checkpoint_id>`

Support commands:

- `caddie ledger:info`
- `caddie ledger:help`

Verification config commands:

- `caddie ledger:verify:command:set <command>`
- `caddie ledger:verify:command:get`
- `caddie ledger:verify:command:unset`

## Local Storage Layout

Ledger data is stored per repository at:

```text
.caddie/ledger/
```

Structure:

```text
.caddie/ledger/
  project.json
  current_session
  current_checkpoint
  sessions/<session_id>/session.json
  sessions/<session_id>/watch_agents
  sessions/<session_id>/checkpoints/<checkpoint_id>/
    snapshot.zip
    manifest.json
    transcripts/checkpoint.md
    artifacts/index.jsonl
    verification/verify.log
    verification/files.sha256
```

Supabase auth config is stored outside the git worktree:

```text
~/.caddie_state/ledger/config.json
```

Schema DB base settings (admin use) are stored outside the worktree:

```text
~/.caddie_state/ledger/db_host
~/.caddie_state/ledger/db_user   # optional override (default: postgres)
~/.caddie_state/ledger/db_port   # optional override (default: 5432)
~/.caddie_state/ledger/db_name   # optional override (default: postgres)
```

Schema DB password (admin use) can be stored in macOS Keychain:

- service: `caddie.ledger.schema.db.password`
- account: DB host from `schema:db:url:set` (fallback: `<project_id>`, then `default`)

## Checkpoint Behavior

- Snapshot mode is snapshot-over-diff.
- Snapshot capture respects `.gitignore` when inside a git repository.
- `manifest.json` is the single source of truth and records:
  - repo root, branch, git SHA (if available)
  - timestamp and message
  - file counts and hashes
  - verification command, status, and log path

## Verification Config

Verification resolution order:

1. `CADDIE_LEDGER_VERIFY_COMMAND` (set via `ledger:verify:command:set`)
2. `caddie verify` (if available)
3. `caddie core:lint`

By default, checkpoint verification output is captured to:

```text
.caddie/ledger/sessions/<session_id>/checkpoints/<checkpoint_id>/verification/verify.log
```

## Agent Watch + Collect

Session-level watch list:

- `ledger:agent:watch <agents...>` stores watched agents for the active session.
- `ledger:agent:watch:list` shows watched agents and whether each source is currently available.
- `ledger:agent:watch:clear` removes watched agents from the active session.

Current collector behavior:

- `ledger:collect` appends collected snippets into the active checkpoint transcript.
- `ledger:checkpoint` runs `ledger:collect` automatically after the checkpoint is created.
- You can still run `ledger:collect` manually between checkpoints.
- Sources:
  - `codex` from `~/.codex/history.jsonl` (last N lines)
  - `caddie` from `~/.caddie_history` (last N lines)
  - `cursor` source detection only (collector not yet implemented)
  - `claude` unsupported in this build
- `ledger:collect` requires both:
  - an active session
  - an active checkpoint (`ledger:checkpoint ...`)

Optional line limit override:

```bash
export CADDIE_LEDGER_COLLECT_LINES=200
```

## Supabase Sync (Phase 2)

The sync workflow is opt-in and local-first:

1. Initialize backend schema (admin):
   - `caddie ledger:schema:db:url:set db.<project>.supabase.co`
   - `caddie ledger:schema:db:password:set`
   - `caddie ledger:schema:init` (or inspect with `schema:init:dry:run` / `schema:sql`)
2. Configure auth:
   - `caddie ledger:auth:set ...`
3. Validate environment before pushing:
   - `caddie ledger:sync:check`
4. Push local checkpoints:
   - `caddie ledger:sync:push latest` or `all`
5. Pull a remote checkpoint snapshot:
   - `caddie ledger:sync:pull <checkpoint_id>`

`ledger:sync:check` validates:

- Supabase endpoint reachability
- Bucket listing and required bucket existence
- Table read access (`projects`, `sessions`, `checkpoints`, `artifacts`, `events`)
- Table write probes (upsert/insert) with cleanup
- Storage write/delete probe in snapshots bucket

Push behavior:

- Uploads `snapshot.zip` to the configured snapshots bucket.
- Uploads transcript and artifacts when present.
- Upserts metadata rows to `projects`, `sessions`, `checkpoints`, and `artifacts`.
- Emits a `sync_push` event into `events` (best effort).

Pull behavior:

- Fetches checkpoint metadata from Supabase.
- Downloads snapshot archive.
- Imports it into local `.caddie/ledger/sessions/...`.
- Restores into a new local restore directory by default.

`ledger:schema:init` applies the baseline schema and policies:

- Tables: `projects`, `sessions`, `checkpoints`, `artifacts`, `events`
- Buckets: `snapshots`, `transcripts`, `artifacts`
- Grants + baseline RLS policies for `anon` and `authenticated` roles

## Usage Example

```bash
caddie ledger:project:init
caddie ledger:session:start codex cursor
caddie ledger:checkpoint "phase-1 local MVP"
caddie ledger:artifact ./tmp/build.log
caddie ledger:list
caddie ledger:session:end
caddie ledger:restore checkpoint-20260218T120000Z
caddie ledger:schema:db:url:set db.<project>.supabase.co
caddie ledger:schema:db:password:set
caddie ledger:schema:init
caddie ledger:auth:set https://<project>.supabase.co <anon_key> <project_id>
caddie ledger:sync:check
caddie ledger:sync:push latest
caddie ledger:sync:pull checkpoint-20260218T120000Z
```
