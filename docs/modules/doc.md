# Doc Module

The Doc module provides markdown preview with user-selectable backends: terminal viewers (mdview, glow, mdcat) or PDF opened in Preview (macOS).

## Overview

Use this module to:

- Preview markdown files in the terminal (with optional Mermaid diagram support via mdview)
- Set a preferred backend (mdview, glow, mdcat, or pdf)
- Render markdown to PDF and open in Preview; output is stored in a Caddie-managed directory
- Clean up rendered PDFs when done

## Commands

### Setup

- `caddie doc:setup` - Interactive: lists backends and install commands, then prompts "Install which? (mdview/glow/mdcat/pandoc)". Runs the corresponding install and sets preference.
- `caddie doc:setup:mdview` - Install mdview (curl install script). Sets preference to mdview when done.
- `caddie doc:setup:glow` - Install glow via Homebrew. Sets preference to glow when done.
- `caddie doc:setup:mdcat` - Install mdcat via Cargo (requires Rust; use `caddie rust:setup` first if needed). Sets preference to mdcat when done.
- `caddie doc:setup:pandoc` - Install pandoc via Homebrew (for PDF preview). Sets preference to pdf when done.
- `caddie doc:install:mdview`, `doc:install:glow`, `doc:install:mdcat`, `doc:install:pandoc` - Aliases for the corresponding `doc:setup:*` commands (for consistency with other modules).

### Preview

- `caddie doc:preview [file]` - Preview markdown using your preferred backend or the first available (mdview → glow → mdcat → pandoc). Default file: README.md.
- `caddie doc:preview:mdview [file]` - Preview with mdview (terminal + Mermaid as ASCII).
- `caddie doc:preview:glow [file]` - Preview with glow.
- `caddie doc:preview:mdcat [file]` - Preview with mdcat.
- `caddie doc:preview:pdf <file>` - Render markdown to PDF, save to the rendered directory, and open in Preview (or system PDF viewer).
- `caddie doc:preview:clean` - Remove all files in the Caddie doc-rendered directory.

### Preference

- `caddie doc:prefer:set <backend>` - Set preferred backend: mdview, glow, mdcat, or pdf.
- `caddie doc:prefer:get` - Show current preference.
- `caddie doc:prefer:unset` - Clear preference (use auto fallback order).

### Rendered directory (PDF output)

- `caddie doc:rendered:dir:set <path>` - Set directory for PDF output (default: ~/.caddie_doc_rendered).
- `caddie doc:rendered:dir:get` - Show configured rendered directory.
- `caddie doc:rendered:dir:unset` - Reset to default.

### Info

- `caddie doc:info` - Show which backends are installed, current preference, default backend for doc:preview, and rendered directory path.

## Installing backends

Use Caddie to install (and set preference):

- **mdview**: `caddie doc:setup:mdview`
- **glow**: `caddie doc:setup:glow` (requires Homebrew)
- **mdcat**: `caddie doc:setup:mdcat` (requires Rust/Cargo)
- **pandoc** (for PDF): `caddie doc:setup:pandoc` (requires Homebrew)

Or run `caddie doc:setup` and choose one when prompted.

## Examples

```bash
caddie doc:setup
caddie doc:preview README.md
caddie doc:prefer:set mdview
caddie doc:preview docs/guide.md
caddie doc:preview:pdf docs/guide.md
caddie doc:preview:clean
caddie doc:info
```
