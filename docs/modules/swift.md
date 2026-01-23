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

## Xcode Project Integration

These commands help manage Swift Package dependencies in Xcode projects and build/test them from the command line.

### `caddie swift:xcode:packages:check`

Checks if Swift Package dependencies are configured in the current Xcode project. Lists both local and remote package references.

### `caddie swift:xcode:packages:add <target> <package_path1> <product1> [package_path2 product2 ...]`

Adds local Swift Package dependencies to an Xcode project programmatically. This command:

- Requires Ruby with the `xcodeproj` gem (automatically uses `caddie ruby:gem:install` if needed)
- Uses RVM Ruby if available, otherwise falls back to system Ruby
- Automatically finds the script in installed or development locations

**Example:**
```bash
caddie swift:xcode:packages:add vCaddie ../physics-core-swift PhysicsCore ../golf-agent-swift GolfSimulator
```

**Requirements:**
- Ruby must be available (run `caddie ruby:setup` if needed)
- Must be run from a directory containing an `.xcodeproj` file

### `caddie swift:xcode:resolve`

Resolves Swift Package dependencies for the Xcode project. Equivalent to running "Resolve Package Versions" in Xcode.

### `caddie swift:xcode:build [scheme] [simulator|device] [sim_name]`

Builds an Xcode project from the command line with error-only output for concise logs.

- `scheme` (optional): Xcode scheme name (defaults to app scheme like `vCaddie`, or project name)
- `simulator|device` (optional): Build destination (defaults to `simulator`)
- `sim_name` (optional): Simulator name for simulator builds (defaults to "iPhone 16")

**Examples:**
```bash
caddie swift:xcode:build
caddie swift:xcode:build vCaddie simulator "iPhone 16 Pro"
caddie swift:xcode:build vCaddie device
```

### `caddie swift:xcode:build:log [scheme] [simulator|device] [sim_name]`

Builds an Xcode project with full `xcodebuild` output (useful for verbose logs).

**Example:**
```bash
caddie swift:xcode:build:log vCaddie simulator "iPhone 16 Pro"
```

### `caddie swift:xcode:target:get|set|unset`

Manage the preferred Xcode run target used by `swift:xcode:play`.

- `get` shows the current target.
- `set` stores a target name (simulator or device).
- `unset` clears the stored target.

**Examples:**
```bash
caddie swift:xcode:target:get
caddie swift:xcode:target:set Icaruus
caddie swift:xcode:target:unset
```

When a target is set, the prompt shows `[xcode:target <name>]`. Target matching is case-insensitive and allows partial matches (for example, `Icaruus` can match `Icaruus’s iPhone`).

### `caddie swift:xcode:play [scheme] [target]`

Builds the Xcode project and launches the app on the specified target.

- `scheme` (optional): Xcode scheme name (defaults to app scheme like `vCaddie`, or project name)
- `target` (optional): Simulator or device name (defaults to the stored target, or "iPhone 16")

The command installs and launches the app on the simulator via `simctl`. For devices, it uses `xcrun devicectl` to install and launch the app.

**Examples:**
```bash
caddie swift:xcode:play
caddie swift:xcode:play vCaddie "iPhone 16 Pro"
caddie swift:xcode:play vCaddie Icaruus
```

### `caddie swift:xcode:test [scheme] [sim_name]`

Runs tests for an Xcode project and writes full output to a log file. A preflight build-for-testing runs first; tests are skipped if the build fails.

- `scheme` (optional): Xcode scheme name (defaults to app scheme like `vCaddie`, or project name)
- `sim_name` (optional): Simulator name (defaults to "iPhone 16")

**Example:**
```bash
caddie swift:xcode:test vCaddie "iPhone 16 Pro"
```

### `caddie swift:xcode:test:unit [scheme] [sim_name]`

Runs Xcode unit tests (skipping UI targets) and writes the full output to a log file. A preflight build-for-testing runs first; tests are skipped if the build fails.

**Example:**
```bash
caddie swift:xcode:test:unit vCaddie "iPhone 16 Pro"
```

The most recent unit test log path is stored for reuse:

```bash
caddie swift:xcode:test:unit:log:get
```

### `caddie swift:xcode:test:unit:failed [scheme] [sim_name]`

Re-runs failed unit tests from the most recent unit test log, running each test individually and reporting pass/fail results.

**Example:**
```bash
caddie swift:xcode:test:unit:failed vCaddie "iPhone 16 Pro"
```

### `caddie swift:xcode:test:unit:log:get|set|unset`

Manage the stored unit test log path used by `swift:xcode:test:unit:failed`.

**Examples:**
```bash
caddie swift:xcode:test:unit:log:get
caddie swift:xcode:test:unit:log:set /path/to/test.log
caddie swift:xcode:test:unit:log:unset
```

### `caddie swift:xcode:clean [scheme]`

Cleans the Xcode project build artifacts.

- `scheme` (optional): Xcode scheme name (defaults to project name)

### `caddie swift:help`

Prints a concise command reference.

## Requirements

- Xcode or the Swift command line tools (`swift` CLI must exist).
- Optional: `swift-format` and `swiftlint` (Homebrew installs recommended).
- For Xcode package commands: Ruby with `xcodeproj` gem (automatically installed via `caddie ruby:setup`).

## Troubleshooting

- **"Swift toolchain not found"** – run `xcode-select --install` or install Xcode.
- **`swift-format` / `swiftlint` missing** – install via `brew install swift-format swiftlint`.
- **Not a Swift package** – ensure you run commands in a directory containing `Package.swift`.
- **Xcode package commands fail** – ensure Ruby is set up with `caddie ruby:setup` and the `xcodeproj` gem is installed.
- **"add_swift_packages.rb script not found"** – run `make install` from the caddie.sh directory or ensure you're in a development environment where the script can be found.
