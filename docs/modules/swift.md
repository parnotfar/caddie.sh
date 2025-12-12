# Swift Module

The Swift module mirrors the Rust workflow but for Swift Package Manager projects. It keeps SwiftPM tasks consistent across the team and bundles common formatting/linting helpers.

## Overview

- **Project Management** – `swift:init`, `swift:build`, `swift:run`, and `swift:test`.
- **Package Utilities** – Resolve/update/clean/describe dependency graphs.
- **Code Quality** – `swift:format` (swift-format) and `swift:lint` (SwiftLint).
- **Git Hygiene** – Generate a Swift-focused `.gitignore`.

## Commands

### `caddie swift:init <name> [--type executable|library]`

Scaffolds a Swift package and writes a `.gitignore`. Example:

```bash
caddie swift:init short-game --type library
cd short-game && caddie swift:build
```

### `caddie swift:build [args]`

Runs `swift build`, forwarding extra flags (e.g., `--configuration release`).

### `caddie swift:run [args]` / `caddie swift:run:tool <target>`

Execute the default executable or a named target with additional arguments.

### `caddie swift:test [args]` / `caddie swift:test:filter <pattern>`

Wraps `swift test`, optionally filtering to `TestCase/testMethod`.

### `caddie swift:package:resolve|update|clean|describe`

Direct wrappers around `swift package` subcommands for dependency management.

### `caddie swift:format [--lint]`

Invokes `swift-format` (if installed). Default formats Sources/Tests in place; `--lint` runs read-only checks.

### `caddie swift:lint`

Runs `swiftlint` with any extra flags you pass.

### `caddie swift:gitignore`

Writes a Swift/Xcode-friendly `.gitignore` containing `.build`, `DerivedData`, `.swiftpm`, and IDE metadata.

### `caddie swift:help`

Prints a concise command reference.

## Requirements

- Xcode or the Swift command line tools (`swift` CLI must exist).
- Optional: `swift-format` and `swiftlint` (Homebrew installs recommended).

## Troubleshooting

- **"Swift toolchain not found"** – run `xcode-select --install` or install Xcode.
- **`swift-format` / `swiftlint` missing** – install via `brew install swift-format swiftlint`.
- **Not a Swift package** – ensure you run commands in a directory containing `Package.swift`.
