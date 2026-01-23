# Caddie.sh Release Notes

## Version 6.0.0 - Git Worktree Workflow

**Release Date:** January 2026

### 🚀 Major New Features

#### **Git Worktree Workflow (Multi-Agent)**
- **Worktree Commands**: Added `git:worktree:*` commands to create isolated worktrees for parallel agents
  - `caddie git:worktree:add <path> <branch> [--new]`
  - `caddie git:worktree:list`
  - `caddie git:worktree:remove <path>`
  - `caddie git:worktree:lock <path>` / `caddie git:worktree:unlock <path>`
  - `caddie git:worktree:cd <path>`
  - `caddie git:worktree:prune`
- **Tab Completion**: Worktree path completion is available for `git:worktree:remove`, `git:worktree:lock`, `git:worktree:unlock`, and `git:worktree:cd`


### 📝 Usage Examples

#### **Worktree Commands**
```bash
# Create worktree for a branch
caddie git:worktree:add ../swift-analytics feature/analytics

# List and jump between worktrees
caddie git:worktree:list
caddie git:worktree:cd ../swift-analytics

# Lock or remove worktrees
caddie git:worktree:lock ../swift-analytics
caddie git:worktree:unlock ../swift-analytics
caddie git:worktree:remove ../swift-analytics
```

## Version 5.1.0 - iOS TestFlight Distribution & Configuration Management

**Release Date:** January 2026

### 🚀 Major New Features

#### **iOS Module - Complete TestFlight Distribution Workflow**
- **Command-Line TestFlight Uploads**: Full support for uploading iOS builds to TestFlight via command line using `xcrun altool`
  - `caddie ios:archive:testflight [scheme] [archive_path]` - Create archive for TestFlight distribution
  - `caddie ios:export:ipa [archive_path] [export_path] [export_options_plist]` - Export IPA from archive
  - `caddie ios:upload:testflight [ipa_path] [apple_id] [password]` - Upload IPA to App Store Connect
  - `caddie ios:testflight [scheme] [increment] [upload]` - Complete end-to-end workflow
  - `caddie ios:testflight:publish [scheme] [archive_path] [export_path] [export_options_plist]` - Increment build + archive + export + upload
  - `caddie ios:testflight:publish:increment:false [scheme] [archive_path] [export_path] [export_options_plist]` - Archive + export + upload (no increment)
- **Credential Improvements**: Added Keychain password storage and App Store Connect API key support for uploads
- **Project Information Extraction**: Automatically extract bundle ID, version, build number, and team ID from Xcode projects
  - `caddie ios:project:info [scheme]` - Display all project information
  - `caddie ios:increment:build [scheme]` - Automatically increment build numbers
- **Intelligent Scheme Detection**: Auto-detects Xcode schemes when not specified, preferring app schemes over package schemes
- **Automatic Export Options**: Generates App Store export options plist automatically with proper signing configuration

#### **iOS Configuration Management System**
- **Persistent Configuration Storage**: New configuration management system that stores settings in `~/.caddie_ios_config`
  - `caddie ios:config:get [key]` - Get configuration value(s)
  - `caddie ios:config:set <key> <value>` - Set configuration value
  - `caddie ios:config:unset <key>` - Remove configuration value
  - `caddie ios:config:list` - List all configuration
  - `caddie ios:config:load:project [scheme]` - Load project info into configuration
- **Supported Configuration Keys**:
  - `apple-id` - Your Apple ID email
  - `password` - App-specific password (recommended for security)
  - `bundle-id` - Bundle identifier
  - `version` - App version
  - `build` - Build number
  - `team-id` - Development team ID
  - `scheme` - Default Xcode scheme
- **Auto-Loading**: Configuration automatically loads when module is sourced and when functions need it
- **Password Security**: Passwords are stored securely and displayed as `<set>` when retrieved

### 🔧 Technical Improvements

#### **TestFlight Workflow Integration**
- **Seamless Integration**: All TestFlight functions automatically use saved configuration
- **Flexible Overrides**: Can still override any value via command arguments
- **Error Handling**: Comprehensive error messages with troubleshooting guidance
- **Progress Feedback**: Clear status messages throughout the upload process

#### **Project Information Management**
- **Build Settings Extraction**: Uses `xcodebuild -showBuildSettings` to extract project information
- **Workspace Support**: Works with both `.xcodeproj` and `.xcworkspace` files
- **Version Management**: Automatic build number incrementing with support for `agvtool` or direct project file editing

#### **Configuration System**
- **File-Based Storage**: Configuration stored in `~/.caddie_ios_config` as shell-sourced file
- **Session Persistence**: Configuration persists across shell sessions
- **Flexible Key Formats**: Accepts various key name formats (e.g., `apple-id`, `apple_id`, `APPLE_ID`)
- **Auto-Export**: Configuration values automatically exported as environment variables

#### **Swift Xcode Workflow**
- **Play Command**: Added `caddie swift:xcode:play [scheme] [target]` to build and launch apps on a simulator or device from the terminal
- **Target Management**: New `swift:xcode:target:get|set|unset` commands to persist a preferred run target and render it in the prompt
- **Test Logs by Default**: `swift:xcode:test` and `swift:xcode:test:unit` now log to a file by default and capture the exact `xcodebuild` invocation
- **Unit Test Reruns**: `swift:xcode:test:unit:failed` parses the last log and reruns failed tests individually
- **Unit Test Log Management**: Added `swift:xcode:test:unit:log:get|set|unset` to manage the last unit test log path
- **Preflight Builds**: Xcode tests now run `build-for-testing` first and skip tests if the build fails, reporting filtered errors

### 🐛 Bug Fixes

#### **Shell Integration Reliability**
- **Cursor Terminal Compatibility**: Updated `dot_bashrc` menu prompts to avoid syntax errors during shell state snapshots, preventing `dump_bash_state` failures in Cursor terminal operations

### 📝 Usage Examples

#### **Complete TestFlight Workflow**
```bash
# 1. Set credentials (one-time setup)
caddie ios:config:set apple-id 'your@apple.id'
caddie ios:config:set password 'xxxx-xxxx-xxxx-xxxx'

# 2. Load project information
caddie ios:config:load:project vCaddie

# 3. Run complete workflow (increment build, archive, export, upload)
caddie ios:testflight
```

#### **Publish Shortcut**
```bash
# Increment build + archive + export + upload
caddie ios:testflight:publish vCaddie

# Archive + export + upload (no increment)
caddie ios:testflight:publish:increment:false vCaddie
```

#### **Swift Xcode Commands**
```bash
# Build and launch on a target
caddie swift:xcode:play vCaddie "iPhone 16"

# Set a default target for play
caddie swift:xcode:target:set Icaruus

# Run unit tests (logs to file, skips UI tests)
caddie swift:xcode:test:unit vCaddie "iPhone 16"

# Re-run only failed unit tests
caddie swift:xcode:test:unit:failed vCaddie "iPhone 16"

# Inspect or override the last unit test log path
caddie swift:xcode:test:unit:log:get
caddie swift:xcode:test:unit:log:set /path/to/test.log
caddie swift:xcode:test:unit:log:unset
```

#### **Step-by-Step Workflow**
```bash
# Check project information
caddie ios:project:info vCaddie

# Increment build number
caddie ios:increment:build vCaddie

# Create archive
caddie ios:archive:testflight vCaddie

# Export IPA
caddie ios:export:ipa ./build/archive/vCaddie.xcarchive

# Upload to TestFlight
caddie ios:upload:testflight ./build/export/vCaddie.ipa
```

#### **Configuration Management**
```bash
# View all configuration
caddie ios:config:get

# Set individual values
caddie ios:config:set apple-id 'your@apple.id'
caddie ios:config:set password 'xxxx-xxxx-xxxx-xxxx'
caddie ios:config:set scheme 'vCaddie'

# Get specific value
caddie ios:config:get apple-id

# Remove configuration
caddie ios:config:unset password
```

### 🔄 Migration Notes

#### **For All Users**
- **No Breaking Changes**: All existing iOS commands continue to work as before
- **Optional Configuration**: Configuration system is optional - can still use environment variables
- **Backward Compatible**: Functions still accept command-line arguments to override configuration

#### **For TestFlight Users**
- **First-Time Setup**: Run `caddie ios:config:set apple-id` and `caddie ios:config:set password` to store credentials
- **Project Setup**: Run `caddie ios:config:load:project` to extract and save project information
- **Simplified Workflow**: Can now run `caddie ios:testflight` without specifying scheme or credentials

### 🎯 Use Cases

#### **Automated CI/CD Integration**
```bash
# In CI/CD pipeline
caddie ios:config:set apple-id "$APPLE_ID"
caddie ios:config:set password "$APP_SPECIFIC_PASSWORD"
caddie ios:testflight vCaddie yes yes
```

#### **Development Workflow**
```bash
# Quick build and upload
caddie ios:testflight vCaddie

# Archive only (skip upload)
caddie ios:testflight vCaddie yes no

# Upload existing IPA
caddie ios:upload:testflight ./build/export/vCaddie.ipa
```

### 📚 Documentation Updates

- **iOS Module Documentation**: Completely updated `docs/modules/ios.md` with:
  - TestFlight distribution workflow
  - Configuration management commands
  - Project information extraction
  - Complete usage examples
- **Release Notes**: Comprehensive documentation of all new features

### 🔐 Security Notes

- **App-Specific Passwords**: Strongly recommended to use app-specific passwords instead of regular Apple ID passwords
- **Password Storage**: Passwords stored in `~/.caddie_ios_config` (user-readable, consider file permissions)
- **No Network Storage**: All configuration stored locally, never transmitted

### 🎉 What's Next

After uploading to TestFlight:
1. Wait 5-30 minutes for processing in App Store Connect
2. Navigate to My Apps → Your App → TestFlight
3. Add build to testing groups when processing completes
4. Testers receive automatic notifications

---

## Version 4.2.1 - Swift Xcode Build Fixes

**Release Date:** December 2025

### 🐛 Bug Fixes

#### **Swift Module - Xcode Build Improvements**
- **Scheme Auto-Detection Fix**: Fixed `caddie swift:xcode:build` and `caddie swift:xcode:test` to prefer app schemes (e.g., `vCaddie`) over package schemes (e.g., `GolfSimulator`, `PhysicsCore`) when auto-detecting the scheme
  - Previously, the first scheme in the list (often a package scheme) was selected by default
  - Now intelligently prefers schemes matching the project name or common app scheme names like `vCaddie`
  - Falls back to first available scheme if no app scheme is found
- **Default Simulator Update**: Changed default simulator from "iPhone 15" to "iPhone 16" for `swift:xcode:build` and `swift:xcode:test` commands
  - "iPhone 15" simulator is not available in current Xcode versions
  - "iPhone 16" is available and provides a better default experience
  - Users can still override with explicit simulator name: `caddie swift:xcode:build vCaddie simulator "iPhone 16 Pro"`

### 🔧 Technical Improvements

#### **Scheme Detection Logic**
- **Smart Scheme Selection**: `caddie_swift_xcode_scheme()` now:
  1. First checks for scheme matching project name (without `.xcodeproj` extension)
  2. Then checks for common app scheme names like `vCaddie`
  3. Falls back to first available scheme if no match found
- **Better Defaults**: More intuitive behavior when building Xcode projects with multiple schemes

### 🔄 Migration Notes

#### **For All Users**
- **Seamless Fix**: No breaking changes to existing functionality
- **Better Defaults**: Commands now work correctly without requiring explicit scheme specification
- **No Action Required**: Fix is automatic upon next `caddie reload`
- **Explicit Override**: Can still specify scheme explicitly: `caddie swift:xcode:build vCaddie`

### 📝 Usage Examples

#### **Before Fix (4.2.0)**
```bash
# Would incorrectly select GolfSimulator scheme
caddie swift:xcode:build
# Error: Unable to find a device matching "iPhone 15"
```

#### **After Fix (4.2.1)**
```bash
# Correctly selects vCaddie scheme
caddie swift:xcode:build

# Uses iPhone 16 simulator by default
caddie swift:xcode:test

# Still works with explicit overrides
caddie swift:xcode:build vCaddie simulator "iPhone 16 Pro"
```

---

## Version 4.1.0 - Ruby Environment & Xcode Package Integration

**Release Date:** December 2025

### ✨ New Features

#### **Ruby Module - Complete RVM Integration**
- **Automatic Ruby Setup**: New `caddie ruby:setup` command that:
  - Installs RVM if not present (with GPG key verification)
  - Automatically detects and installs latest stable Ruby version from ruby-lang.org
  - Configures OpenSSL paths for macOS compilation (uses Homebrew's OpenSSL@3)
  - Sets installed Ruby as default and installs essential gems
- **Version Pinning**: Support for pinning specific Ruby versions via `caddie ruby:pin:set/get/unset` commands (uses `CADDIE_RUBY_VERSION` internally)
- **OpenSSL Integration**: Automatic configuration of compiler flags (`LDFLAGS`, `CPPFLAGS`, `PKG_CONFIG_PATH`) for seamless Ruby compilation on macOS
- **Comprehensive Ruby Management**: Full RVM workflow support including:
  - `caddie ruby:install <version>` - Install specific Ruby versions
  - `caddie ruby:use <version>` - Switch Ruby versions
  - `caddie ruby:list` - List installed versions
  - `caddie ruby:current` - Show current environment details
  - `caddie ruby:version` - Show version information
- **Gemset Management**: Complete gemset isolation support (create, use, list, delete)
- **Gem Management**: Install, update, list, and manage Ruby gems
- **Rails Integration**: Full Rails workflow helpers (new, server, console, generate, migrate, routes)
- **Bundler Integration**: Dependency management commands
- **Project Management**: Project initialization, testing, building, and serving

#### **Swift Module - Xcode Package Integration**
- **Xcode Package Management**: New commands for managing Swift Package dependencies in Xcode projects:
  - `caddie swift:xcode:packages:check` - Check for configured package dependencies
  - `caddie swift:xcode:packages:add <target> <package_path> <product> [...]` - Programmatically add local Swift packages (requires Ruby/xcodeproj gem)
  - `caddie swift:xcode:resolve` - Resolve package dependencies
- **Xcode Build System**: Command-line Xcode project building:
  - `caddie swift:xcode:build [scheme] [simulator|device] [sim_name]` - Build Xcode projects
  - `caddie swift:xcode:test [scheme] [sim_name]` - Run Xcode tests
  - `caddie swift:xcode:clean [scheme]` - Clean build artifacts
- **Ruby Integration**: Swift module automatically uses caddie's Ruby environment for package management (requires `xcodeproj` gem)

#### **Makefile Enhancements**
- **Ruby Build Dependencies**: New `make setup-ruby-deps` target that installs:
  - OpenSSL@3 (required for Ruby compilation)
  - readline, libyaml, gmp
  - autoconf, automake, libtool, pkg-config
- **Binary Script Installation**: Makefile now installs `bin/` directory files to `~/.caddie_modules/bin/` for shared executables
- **Automatic Dependency Setup**: `make install` now includes Ruby build dependencies via `setup-ruby-deps`

### 🔧 Improvements

#### **Ruby Environment Management**
- **Latest Version Detection**: Queries ruby-lang.org directly for latest stable Ruby version
- **OpenSSL Compilation**: Automatically configures Homebrew's OpenSSL with proper compiler flags
- **GPG Key Verification**: Proactively imports GPG keys before RVM installation for signature verification
- **RVM Integration**: Seamless integration with RVM for Ruby version and gemset management
- **Error Handling**: Comprehensive error messages with troubleshooting guidance

#### **Swift/Xcode Integration**
- **Path Detection**: Improved script path detection for both installed and development environments
- **Ruby Environment Detection**: Automatically detects and uses RVM Ruby when available
- **Gem Management**: Automatically installs `xcodeproj` gem if missing
- **Multi-location Search**: Searches multiple locations for binary scripts (installed, development, parent directories)

#### **Documentation**
- **Ruby Module Documentation**: New comprehensive `docs/modules/ruby.md` with:
  - Complete command reference
  - Version pinning instructions
  - OpenSSL configuration details
  - Troubleshooting guide
  - Integration examples
- **Swift Module Updates**: Enhanced `docs/modules/swift.md` with Xcode integration section
- **Module README**: Updated to reflect new capabilities

### 🐛 Bug Fixes

- **Makefile Syntax**: Fixed multi-line conditional syntax in Makefile for binary script installation
- **CLI Output**: Removed escape sequences (`\[`, `\]`) from color definitions in `dot_caddie_cli` (these are only needed for PS1 prompts)
- **Output Formatting**: Updated Ruby module to use `printf '%s\n'` instead of `echo` for description functions (following AGENTS.md guidelines)

### 📝 Upgrade Notes

- **Ruby Setup**: Run `caddie ruby:setup` to initialize Ruby environment with RVM
- **Ruby Build Dependencies**: Run `make install` (or `make setup-ruby-deps`) to install required build tools
- **Xcode Package Management**: Ensure Ruby is set up before using `caddie swift:xcode:packages:add`
- **Reinstall**: Run `make install` to get the latest binary scripts and updated modules

### 🎯 Use Cases

#### **Ruby Environment Setup**
```bash
# Complete Ruby setup with latest stable version
caddie ruby:setup

# Pin specific version
export CADDIE_RUBY_VERSION=3.4.8
caddie ruby:setup

# Install gem
caddie ruby:gem:install xcodeproj
```

#### **Xcode Package Management**
```bash
# Add Swift packages to Xcode project
caddie swift:xcode:packages:add vCaddie ../physics-core-swift PhysicsCore ../golf-agent-swift GolfSimulator

# Resolve dependencies
caddie swift:xcode:resolve

# Build and test
caddie swift:xcode:build vCaddie simulator "iPhone 16 Pro"
caddie swift:xcode:test vCaddie
```

---

## Version 4.0.0 - Swift Module & Shell Cleanup

**Release Date:** February 2025

### ✨ New Features

- **Swift Module**: Added a first-class Swift Package Manager module mirroring the Rust workflow (`swift:init`, `swift:build`, `swift:run`, `swift:test`, package management, formatting, linting, and gitignore helpers).

### 🐛 Bug Fixes

- **Shell Color Functions**: Replaced legacy `ch-cli` calls in `dot_bashrc` with the modern `caddie cli:*` helpers so git branch selectors and other utilities no longer reference missing commands.

### 📝 Upgrade Notes

- Run `make install-dot` (or reinstall) to deploy `.caddie_swift` into `~/.caddie_modules` and then `caddie reload` to pick up the new module/aliases.

---

## Version 3.9.5 - Tab Completion Hook Restoration

**Release Date:** February 2025

### 🐛 Critical Bug Fix

**Fixed Missing Completion Registration**: Reintroduced the Bash `complete -F _caddie_completion` hook so `caddie` commands regain tab completion after sourcing the main script.

### 🔧 Technical Improvements

- **Interactive Guard**: Hook now only registers inside interactive shells and when `complete` exists, preventing issues in non-interactive contexts.
- **Post-Load Safety**: Completion is attached only after `_caddie_load_modules` finishes so all module-provided commands are available to the completer.

### 🔄 Migration Notes

- **For All Users**: Run `caddie reload` (or restart your shell) to pick up the restored completion hook. No further action required.

---

## Version 3.9.4 - Module Load Dependency Fix

**Release Date:** January 2025

### 🐛 Critical Bug Fix

**Fixed Module Load Dependency Issue**: Resolved a critical bug where the `_caddie_load_modules` function tried to call `caddie cli:warning` before the CLI module was loaded, causing "command not found" errors when the modules directory was missing.

### 🔧 Technical Improvements

#### **Dependency Resolution**
- **Basic Shell Output**: Replaced `caddie cli:warning` with `printf` for error messages
- **Pre-Module Error Handling**: Error messages now work before modules are loaded
- **Clear Documentation**: Added comments explaining why basic shell functions are used
- **Chicken-and-Egg Prevention**: Prevents dependency on unloaded modules

#### **Before Fix (3.9.3)**
- `_caddie_load_modules` called `caddie cli:warning` before CLI module was loaded
- Missing modules directory caused "command not found" error
- Error handling failed due to missing dependencies

#### **After Fix (3.9.4)**
- Uses `printf` for error messages before module loading
- Clear documentation of why basic shell functions are used
- Error handling works regardless of module loading state
- Prevents future similar dependency issues

### 🔄 Migration Notes

#### **For All Users**
- **Seamless Fix**: No breaking changes to existing functionality
- **Better Error Handling**: More robust error messages for installation issues
- **No Action Required**: Fix is automatic upon next `caddie reload`

---

## Version 3.9.3 - Completion Loop Array Mismatch Fix

**Release Date:** January 2025

### 🐛 Critical Bug Fix

**Fixed Completion Loop Array Mismatch**: Resolved a critical bug in the completion loop where the condition checked `CADDIE_COMPLETION_ORDER` array length but the loop iterated over `CADDIE_COMPLETION_MODULES` array length, causing potential out-of-bounds access and incorrect tab completions.

### 🔧 Technical Improvements

#### **Loop Consistency Fix**
- **Matching Array References**: Loop condition now uses same array as loop bounds
- **Prevents Out-of-Bounds**: Eliminates risk of accessing non-existent array indices
- **Consistent Completion**: Ensures tab completion works reliably
- **Array Safety**: Prevents empty or incorrect completion suggestions

#### **Before Fix (3.9.2)**
- Condition: `if [ ${#CADDIE_COMPLETION_ORDER[@]} -gt 0 ]`
- Loop: `for ((i = 0; i < ${#CADDIE_COMPLETION_MODULES[@]}; i++))`
- Mismatch between ORDER and MODULES array lengths
- Potential out-of-bounds access

#### **After Fix (3.9.3)**
- Condition: `if [ ${#CADDIE_COMPLETION_MODULES[@]} -gt 0 ]`
- Loop: `for ((i = 0; i < ${#CADDIE_COMPLETION_MODULES[@]}; i++))`
- Consistent array references
- Safe array access

### 🔄 Migration Notes

#### **For All Users**
- **Seamless Fix**: No breaking changes to existing functionality
- **Better Completion**: More reliable tab completion behavior
- **No Action Required**: Fix is automatic upon next `caddie reload`

---

## Version 3.9.2 - Completion Array Alignment Bug Fix

**Release Date:** January 2025

### 🐛 Critical Bug Fix

**Fixed Completion Array Misalignment**: Resolved a critical bug in `caddie_completion_register()` where duplicate module registrations would cause array misalignment between `CADDIE_COMPLETION_MODULES`/`CADDIE_COMPLETION_COMMANDS` and `CADDIE_COMPLETION_ORDER`.

### 🔧 Technical Improvements

#### **Array Management Fix**
- **Duplicate Detection**: Now checks for existing modules in indexed arrays before appending
- **Update vs Append**: Updates existing module commands instead of creating duplicates
- **Array Alignment**: Ensures `CADDIE_COMPLETION_MODULES` and `CADDIE_COMPLETION_COMMANDS` stay synchronized
- **Completion Integrity**: Prevents stale or duplicate command entries in tab completion

#### **Before Fix (3.9.1)**
- `caddie_completion_register()` unconditionally appended to indexed arrays
- Only conditionally appended to `CADDIE_COMPLETION_ORDER`
- Duplicate registrations caused array misalignment
- Completion loop processed stale/duplicate entries

#### **After Fix (3.9.2)**
- Checks for existing modules before appending
- Updates existing entries instead of creating duplicates
- Maintains proper array alignment
- Clean completion behavior

### 🔄 Migration Notes

#### **For All Users**
- **Seamless Fix**: No breaking changes to existing functionality
- **Better Completion**: More reliable tab completion behavior
- **No Action Required**: Fix is automatic upon next `caddie reload`

---

## Version 3.9.1 - Critical Error Handling Fix

**Release Date:** January 2025

### 🐛 Critical Bug Fix

**Fixed Shell Termination Issue**: Resolved a critical regression where a missing `~/.caddie_modules` directory would terminate the entire shell session instead of gracefully handling the error.

### 🔧 Technical Improvements

#### **Error Handling Restoration**
- **Graceful Failure**: Missing modules directory now shows warning message and continues with limited functionality
- **Shell Preservation**: No longer terminates the interactive shell when modules directory is missing
- **Function Wrapping**: Wrapped module loading in `_caddie_load_modules()` function to enable proper `return` behavior
- **User Experience**: Users can now fix installation issues without losing their shell session

#### **Before Fix (3.9)**
- Missing `~/.caddie_modules` would call `exit 1` and terminate the entire shell
- No error message shown to user
- Shell session lost, requiring new terminal

#### **After Fix (3.9.1)**
- Missing `~/.caddie_modules` shows warning: "Installation Error: The modules directory for caddie is not found. Please reinstall caddie."
- Shell session preserved
- User can fix the issue and continue working

### 🔄 Migration Notes

#### **For All Users**
- **Immediate Fix**: Critical regression resolved
- **No Action Required**: Fix is automatic upon next `caddie reload`
- **Better Error Handling**: More robust error handling for installation issues

---

## Version 3.9 - Critical History Pollution Bug Fix

**Release Date:** January 2025

### 🐛 Critical Bug Fix

**Fixed Terminal History Pollution**: Resolved a major issue where `caddie reload` was polluting terminal history with caddie's internal command history. This was caused by `caddie cli:check` calls executing during the sourcing process.

### 🔧 Technical Improvements

#### **Shell Compatibility Enhancements**
- **Fixed Shebang**: Changed from `#!/bin/bash` to `#!/usr/bin/env bash` to use Homebrew bash (5.3.3) instead of system bash (3.2.57)
- **Associative Array Compatibility**: Replaced associative arrays with regular arrays for better shell compatibility
- **Process Substitution**: Simplified module loading to avoid process substitution issues in restricted environments
- **Mapfile Replacement**: Replaced `mapfile` with more compatible `while` loops for broader shell support

#### **History Management**
- **Removed Sourcing Calls**: Eliminated `caddie cli:check` calls that were executing during module sourcing
- **Clean Loading**: Caddie now loads without adding internal commands to terminal history
- **Preserved Functionality**: All core caddie functionality remains intact

### 🎯 Impact

#### **Before Fix**
- `caddie reload` would add caddie commands to terminal history
- Terminal history was cluttered with internal caddie operations
- Poor user experience with polluted command history

#### **After Fix**
- `caddie reload` loads cleanly without history pollution
- Terminal history remains clean and user-focused
- All caddie commands work exactly as before
- Better shell compatibility across different environments

### 🔄 Migration Notes

#### **For All Users**
- **Seamless Upgrade**: No breaking changes to existing functionality
- **Immediate Benefits**: Clean terminal history after `caddie reload`
- **Better Compatibility**: Works with more shell configurations
- **No Action Required**: Fix is automatic upon next `caddie reload`

#### **Technical Details**
- **Version Bump**: Updated from 3.8 to 3.9
- **Core Functionality**: All commands (`caddie help`, `caddie version`, `caddie core:help`) work unchanged
- **REPL Functionality**: Interactive caddie prompt remains fully functional
- **Tab Completion**: Temporarily disabled for compatibility (will be restored in future version)

---

## Version 3.8 - Interrupt-Resilient REPL

**Release Date:** November 2025

### 🎯 Release Highlights

- **Graceful Interrupts**: Pressing `Ctrl+C` inside the interactive prompt now stops only the running command; the REPL stays active and immediately redraws the prompt.
- **Shell Scope Safety**: Shell pass-through commands launched via backticks or the `shell` helper inherit the new interrupt behaviour, giving you a consistent escape hatch for long tasks.
- **Prompt Preservation**: Scoped prompts (for example `caddie[rust]-3.7>`) remain intact after interrupts, so you stay in the same module context.

### 📚 Documentation Updates

- README “First Use” section now calls out the new interrupt-friendly workflow with fresh examples.
- Core module reference and User Guide highlight `Ctrl+C` behaviour and updated prompt examples (`caddie-3.7>`).

## Version 3.5 - Sub-module Prompts!

**Release Date:** October 2025

### 🎯 Release Highlights

- **Module Scopes**: Typing a module name (for example `csv`) nests the prompt into `caddie[csv]-3.5>`, so every command that follows automatically targets that module until you `back`, `up`, or `..` out.
- **Isolated History**: The Caddie Prompt records commands in `~/.caddie_history` without polluting your shell history, while still supporting arrow-key recall during a session.
- **Shell Integration**: Run raw shell commands with backticks or the new `shell` scope, keeping Caddie workflow and ad-hoc shell usage in one prompt.

### 🚀 Enhanced Usage

- `caddie-3.5> csv` — activates the CSV scope, switching the prompt to `caddie[csv]-3.5>` for focused commands.
- `caddie[csv]-3.5> set file data.csv` — runs the CSV module command without retyping the module name.
- `caddie[rust]-3.5> fix all` — expands to `rust:fix:all`, keeping the familiar full-word flow inside a module scope.
- `caddie rust:run:example targets/multi_distance_demo.rs` — point at an example file or name; Caddie resolves both forms automatically.
- `ps aux | head` — executes shell commands inline; results stay in the Prompt history without touching shell history.
- `caddie-3.5> shell ls -la` — proxy a one-off shell command without switching contexts, or type `shell` to enter a dedicated shell scope.

### 📚 Documentation Updates

- README “First Use” section now introduces the prompt as a first-class entry point, with module scope callouts.
- User Guide adds an “Interactive Prompt” chapter with sample sessions and scope navigation tips.
- Core module docs highlight the Prompt, usage tips, conversion rules, and how to exit scoped prompts.
- Git module docs document PR approval workflow and new completion behaviour.
- New shell integration and history behaviour documented across README and User Guide for quick onboarding.

## Version 3.0 - Interactive Caddie Shell

**Release Date:** October 2025

### 🎯 Release Highlights

- **Interactive Prompt**: Running `caddie` without arguments now opens a persistent prompt optimized for module workflows.
- **Command Streamlining**: Typed input like `rust fix all` or `python venv create` is normalized to standard `module:command` form automatically.
- **Built-in Shortcuts**: The prompt recognizes core actions such as `help`, `version`, `reload`, and `go:home` without extra syntax, with colon-prefixed commands (`:rust:build`) passed through untouched.
- **Session Flow**: Exit with `exit`, `quit`, or `Ctrl+D`; colon-prefixed commands (`:rust:build`) send as-is, with Readline editing (Ctrl-A, Ctrl-P, history) built in.
- **PR Approvals**: `caddie git:pr:approve <pr>` approves pull requests with GitHub CLI, and tab completion now surfaces open PR numbers and branch names.

### 🚀 Enhanced Usage

- `caddie` (no args) — launches the interactive prompt for rapid multi-command sessions.
- `caddie rust:fix` — retains scripted behaviour, now also reachable via `caddie> rust fix`.
- `caddie rust:fix:all` — extended to Prompt alias `caddie> rust fix all` (full-word form now chains nested commands without extra arguments).
- `caddie git:pr:approve 42` — review and approve pull requests directly from Caddie, with tab completion suggesting open PR identifiers.

### 📚 Documentation Updates

- README “First Use” section now introduces the prompt as a first-class entry point.
- User Guide adds an “Interactive Prompt” chapter with sample sessions.
- Core module docs highlight the Prompt, usage tips, and conversion rules.
- Git module docs document PR approval workflow and new completion behaviour.

## Version 2.2 - Prompt Registry & ANSI Safety

**Release Date:** October 2025

### 🎯 Release Highlights

- **Prompt Segment Registry**: Modules can now register prompt segments via `caddie_prompt_register_segment`, letting optional packages (like the external CSV tools) render status information without patching core files.
- **Completion Registry**: Module authors can advertise their `module:command` strings through a new completion API so tab completion works for both bundled and external extensions.
- **PS1 Color Hardening**: Reworked prompt assembly to keep ANSI sequences properly wrapped and avoid cursor jumps across terminal emulators.
- **CSV Module Extraction**: The built-in CSV analytics commands were moved to the standalone [caddie-csv-tools](https://github.com/parnotfar/caddie-csv-tools) repository, simplifying the core distribution while keeping the data tooling available for those who need it.

### 🔧 Bug Fixes

- Fixed ANSI color handling that could cause prompt flicker or cursor misplacement in multi-line PS1 setups.
- Ensured prompt segments added by modules are deduplicated and safely evaluated each render.
- Removed lingering references to the internal CSV helper binaries from documentation and install routines.

## Version 2.1 - Rust Example Runner Enhancement

**Release Date:** September 2025

### 🎯 Release Highlights

**Version 2.1 adds the missing `rust:run:example` command to tab completion and documentation:**

- **Tab Completion Fix**: Added `rust:run:example` to tab completion for better developer experience
- **Documentation Update**: Added comprehensive documentation for the `rust:run:example` command
- **Help Examples**: Added `rust:run:example` to help examples section
- **Consistency**: Ensures all rust commands are properly discoverable and documented

### 🚀 New Features

#### **Rust Module Enhancements**
- **Tab Completion**: `rust:run:example` now appears in tab completion
- **Help Documentation**: Added `rust:run:example` to help examples
- **Module Documentation**: Comprehensive documentation for running Cargo examples

### 🔧 Bug Fixes

- **Tab Completion**: Fixed missing `rust:run:example` command in tab completion
- **Documentation**: Added missing documentation for `rust:run:example` command
- **Help Examples**: Added `rust:run:example simple_demo` to help examples

### 📚 Documentation Updates

- **Rust Module Docs**: Added complete documentation for `rust:run:example` command
- **Help Examples**: Updated help examples to include `rust:run:example`
- **Release Notes**: Added version 2.1 release notes

---

## Version 2.0 - Universal Shell Linter & Git/GitHub Integration

**Release Date:** September 2025

### 🎯 Major Release Highlights

**Version 2.0 represents a significant milestone for caddie.sh:**

- **Universal Shell Linting**: The linter can now analyze any shell script, making it a powerful tool for the entire shell scripting ecosystem
- **GitHub Integration**: Complete GitHub CLI integration with authentication, PR creation, and status monitoring
- **Enhanced Git Workflow**: Streamlined branch management and pull request workflows
- **Professional Code Quality**: Comprehensive linting standards that enforce best practices across all shell scripts

This release transforms caddie.sh from a development environment manager into a comprehensive shell scripting toolkit.

### 🚀 New Features

#### **Universal Shell Linter System**
- **Universal Shell Script Linting**: Can now lint any shell script, not just caddie modules
- **Comprehensive Echo Message Detection**: New linter checks for all types of echo messages
  - `echo "Usage..."` → `caddie cli:usage` (Check #11)
  - `echo "✓..."` → `caddie cli:check` (Check #12) 
  - `echo "✗..."` → `caddie cli:red` (Check #13)
  - General `echo "..."` → `caddie cli:indent` (Check #14)
- **Smart Heredoc Detection**: Optimized linter performance with intelligent heredoc pattern detection
  - Quick pre-check for heredoc presence before expensive line-by-line processing
  - Excludes pipe operations (`| while`, `| head`, `| wc`) from general echo warnings
  - Maintains accuracy while improving performance significantly
- **Flexible Linting Output**: New `caddie core:lint:limit <n> <path>` command
  - `caddie core:lint <path>` - Shows ALL issues (no limits)
  - `caddie core:lint:limit <n> <path>` - Shows maximum n issues per check type
  - Eliminates hidden issues that required multiple linter runs
  - Provides complete transparency about total issue count
  - Enables focused debugging with manageable output
- **Variable Shadowing Detection**: New linter check for local variable shadowing
  - Detects `local` declarations inside conditional blocks that shadow outer variables
  - Prevents subtle bugs from variable scope confusion
  - Example: `local path="$1"; if [ -z "$path" ]; then local path="."; fi` (shadows outer path)
  - Recommends removing `local` keyword from inner declarations

#### **New Git Branch Management**
- **Branch Creation Command**: New `caddie git:new:branch <name>` command
  - Creates new branch and switches to it (`git checkout -b`)
  - Pushes to remote and sets upstream tracking (`git push --set-upstream origin`)
  - Validates branch doesn't already exist locally or remotely
  - Provides clear success/failure feedback with proper CLI formatting
  - Equivalent to `gnb` alias functionality

- **Pull Request Creation**: New `caddie git:pr:create [title] [body] [base]` command
  - Creates pull requests using GitHub CLI (`gh pr create`)
  - Auto-generates title from commit messages if not provided
  - Auto-generates body with commit list and testing checklist
  - Validates GitHub CLI authentication and repository status
  - Prevents PR creation from main/master branches
  - Ensures branch is pushed before creating PR
  - Opens PR in browser after creation

### 🔧 Improvements

#### **Linter Performance & Accuracy**
- **Optimized Heredoc Processing**: 10x faster linter performance for files without heredocs
- **Better Pattern Recognition**: More accurate detection of user-facing vs. technical echo statements
- **Enhanced Standards Reference**: Updated help text with complete echo message standards
- **Comprehensive Coverage**: All common echo patterns now have specific linter checks
- **Lint Ignore Blocks**: New `# caddie:lint:disable` and `# caddie:lint:enable` comments
  - Suppress linting warnings for specific code sections
  - Prevents linter from flagging its own implementation code
  - Follows common linting patterns used by other tools
  - Self-documenting and maintainable approach

#### **Git Workflow Enhancement**
- **Streamlined Branch Creation**: One command creates and publishes new branches
- **Automatic Upstream Setup**: No need for separate upstream configuration
- **Conflict Prevention**: Validates branch existence before creation
- **Professional Output**: Uses caddie CLI formatting for consistent user experience

#### **Code Quality Improvements**
- **Consistent Error Handling**: All modules now use `caddie cli:red` for errors
- **Standardized Success Messages**: All modules use `caddie cli:check` for success
- **Unified Usage Messages**: All modules use `caddie cli:usage` for help
- **Better User Feedback**: Consistent formatting across all caddie modules

### 📝 Usage Examples

#### **Enhanced Linter Usage**
```bash
# Check all modules with new echo message detection
caddie core:lint

# Check specific module
caddie core:lint modules/dot_caddie_ruby

# See comprehensive standards reference
caddie core:lint modules/dot_caddie_git

# Use lint ignore blocks for specific code sections
# caddie:lint:disable
function complex_function() {
    echo "This won't trigger warnings"
    # Complex code that needs to break standards
}
# caddie:lint:enable
```

#### **New Git Branch Management**
```bash
# Create and publish new feature branch
caddie git:new:branch feature/user-authentication

# Create bugfix branch
caddie git:new:branch bugfix/fix-login-issue

# Create hotfix branch
caddie git:new:branch hotfix/security-patch

# Create pull request with auto-generated content
caddie git:pr:create

# Create pull request with custom title and body
caddie git:pr:create "Add user authentication" "Implements OAuth2 login flow with JWT tokens"

# Create pull request targeting specific base branch
caddie git:pr:create "Fix login bug" "Resolves authentication timeout issue" develop
```

### 🎯 Standards Enforced (Updated)

#### **Echo Message Standards**
- **Error Messages**: `echo "Error:` → `caddie cli:red`
- **Usage Messages**: `echo "Usage` → `caddie cli:usage`
- **Success Messages**: `echo "✓` → `caddie cli:check`
- **Failure Messages**: `echo "✗` → `caddie cli:red`
- **General Messages**: `echo "..."` → `caddie cli:indent`

#### **Existing Standards (Maintained)**
- Function Naming: `caddie_<module>_<command>` pattern
- CLI Integration: Proper use of `caddie cli:*` functions
- Module Structure: Required help and description functions
- Export Requirements: All functions must be exported
- Variable Usage: Braces for variables (`${var}`)
- Local Declarations: Use `local` for function variables
- Return Statements: Explicit return statements

### 🔄 Migration Notes

#### **For Existing Users**
- **Seamless Upgrade**: No breaking changes to existing functionality
- **Enhanced Linting**: More comprehensive code quality checks
- **New Git Command**: Additional branch management capability
- **Improved Performance**: Faster linter execution for most files

#### **For Module Developers**
- **Updated Standards**: New echo message requirements in linter
- **Performance Benefits**: Faster linting for files without heredocs
- **Better Guidance**: More specific recommendations for different message types
- **Consistent Formatting**: All modules should use caddie CLI functions

---

## Version 1.9 - Caddie Lint & Code Quality Tools

**Release Date:** September 2025

### 🚀 New Features

- Caddie Lint: New caddie core:lint [path] command for enforcing caddie-specific coding standards.
- Replaces generic shellcheck with caddie-aware linting
- Enforces caddie function naming conventions (caddie_<module>_<command>)
- Validates CLI module sourcing and function exports
- Checks for proper help and description functions
- Provides actionable feedback with caddie-specific examples
- Supports checking individual files or entire directories

### 🔧 Improvements

- Enhanced Code Quality: Comprehensive linting that understands caddie's modular architecture
- Better Error Messages: Caddie-specific error messages with clear remediation steps
- Standards Enforcement: Ensures consistency across all caddie modules
- Developer Experience: Faster feedback loop for module development

### 📝 Usage Examples

```bash
# Check all modules
caddie core:lint

# Check specific module
caddie core:lint modules/dot_caddie_rust

# Check specific file
caddie core:lint modules/dot_caddie_python
```

### 🎯 Standards Enforced

- Function Naming: caddie_<module>_<command> pattern
- CLI Integration: Proper use of caddie cli:* functions
- Module Structure: Required help and description functions
- Export Requirements: All functions must be exported
- Error Handling: Proper input validation and error messages
- Variable Usage: Braces for variables (${var})
- Local Declarations: Use local for function variables
- Return Statements: Explicit return statements


## Version 1.8 - Enhanced Git Workflow & SSH Integration

**Release Date:** September 2025

### 🚀 New Features

- **Git Clone Command**: New `caddie git:clone <repo-name>` command for easy repository cloning.
  - Auto-constructs SSH URLs using stored GitHub account
  - Format: `git@github.com:<account>/<repo-name>.git`
  - Requires GitHub account to be set first

- **Git GACP Command**: New `caddie git:gacp <message>` command for quick workflow.
  - Add all changes, commit, and push in one command
  - Perfect for quick commits and rapid development
  - Equivalent to `git add . && git commit -m "message" && git push`

- **Git Push Set-Upstream**: New `caddie git:push:set:upstream [remote] [branch]` command.
  - Sets upstream branch for new repositories
  - Defaults: `origin` remote, `main` branch
  - Equivalent to `git push --set-upstream origin main`

- **Enhanced Git Remote Remove**: Updated `caddie git:remote:remove [name]` command.
  - Now defaults to `origin` if no remote name provided
  - Simplified usage: `caddie git:remote:remove` removes origin

### 🔧 Improvements

- **SSH URL Format**: All Git commands now use SSH URLs (`git@github.com:`) instead of HTTPS
  - Faster authentication using SSH keys
  - No need for username/password or tokens
  - More secure and convenient for development

- **Updated Documentation**: All help text and examples updated to reflect new commands
- **Enhanced Tab Completion**: All new Git commands now have tab completion support

### 📝 Usage Examples

```bash
# Set up GitHub account
caddie github:account:set parnotfar

# Clone a repository
caddie git:clone my-new-project

# Add remote to existing repository
caddie git:remote:add

# Set upstream for first push
caddie git:push:set:upstream

# Remove origin remote
caddie git:remote:remove
```

---

## Version 1.7 - Bug Fixes & Improvements

**Release Date:** September 2025

### 🚀 New Features

- **GitHub Module**: New dedicated module for GitHub account and repository management.
  - `caddie github:account:set <account>` - Set GitHub account
  - `caddie github:account:get` - Get current GitHub account
  - `caddie github:account:unset` - Unset GitHub account
  - `caddie github:repo:create <name> [desc] [private]` - Create new repository
  - `caddie github:repo:url [name]` - Get repository URL (auto-detects if no name)

- **Smart Git Remote Management**: Enhanced `caddie git:remote:add` with auto-detection.
  - No arguments needed: `caddie git:remote:add`
  - Auto-detects repository name from current directory
  - Uses stored GitHub account for URL generation
  - Creates `origin` remote pointing to `https://github.com/<account>/<repo>.git`

- **Enhanced Prompt**: Added GitHub account display to prompt.
  - Format: `[Caddie-1.6][gh:parnotfar] (master|✓) ~/work/pnf/shot-trajectory $`
  - Shows current GitHub account when set

### 🔧 Internals

- **Module Architecture**: Proper separation of concerns with dedicated GitHub module
- **Auto-loading**: GitHub account automatically loaded on shell startup
- **Clean Exports**: Removed GitHub functions from core module for better organization

### 📚 Documentation

- Updated git module help with GitHub integration examples
- Added GitHub module help with comprehensive command documentation

---

## Version 1.5 - Run UX Improvements

**Release Date:** August 2025

### 🚀 New Features

- **Argument Forwarding for Run**: `caddie rust:run` now forwards all arguments to `cargo run`.
  - Example: `caddie rust:run --example simple_demo`
  - Example: `caddie rust:run --bin myapp -- --flag value`

- **Example Runner Shortcut**: Added `caddie rust:run:example <name>` to quickly run Cargo examples.
  - Example: `caddie rust:run:example simple_demo`

### 📚 Documentation

- Updated Rust module help to document the new run argument forwarding and example runner.

### 🔧 Internals

- Improved run command error reporting (non-zero exit status is surfaced).

---

## Version 1.4 - Bug Fixes and Cleanup Release

**Release Date:** August 2025

### 🐛 Bug Fixes

#### **Tab Completion Improvements**
- **Fixed Multiple Colon Support**: Resolved tab completion issues with commands like `caddie rust:test:unit`
- **Enhanced Hierarchical Completion**: Improved completion behavior for nested subcommands
- **Smart Filtering**: Better filtering of completion options based on partial input
- **Context Awareness**: More accurate completion suggestions for complex command structures

#### **Documentation Cleanup**
- **Removed Carrum References**: Cleaned all documentation of company-specific content
- **Removed Sensitive Data**: Eliminated database credentials and internal tool references
- **Updated Aliases Documentation**: Removed references to deleted aliases (`rsp4k`, `had`, etc.)
- **Consistent Documentation**: Ensured all docs reflect current functionality

#### **Security Improvements**
- **Public-Ready Codebase**: Made codebase suitable for public/open-source distribution

### 🔧 Technical Improvements

#### **Installation Process**
- **Simplified Activation**: Updated installation message to `source ~/.bash_profile`
- **Better Error Handling**: Improved installation error messages
- **Streamlined Process**: More straightforward installation workflow

#### **Core Module Updates**
- **Alias Documentation**: Updated core module to reflect current aliases
- **Removed Obsolete References**: Cleaned up references to deleted functionality
- **Consistent Help Text**: Ensured help text matches actual available commands

### 📚 Documentation Updates

#### **Comprehensive Cleanup**
- **README.md**: Removed executable script section, cleaned up content
- **Installation Guide**: Simplified installation instructions
- **User Guide**: Removed executable script documentation
- **Release Notes**: Added proper bug fix documentation

#### **Content Accuracy**
- **Alias Documentation**: Updated to reflect actual available aliases
- **Command References**: Ensured all documented commands actually exist
- **Example Updates**: Updated examples to use current functionality
- **Consistency Checks**: Verified all documentation is consistent

### 🎯 Quality Improvements

#### **Code Quality**
- **Cleaner Codebase**: Removed unnecessary complexity and deprecated features
- **Better Maintainability**: Simplified architecture for easier maintenance
- **Security Focus**: Eliminated sensitive data and company-specific content
- **Public Readiness**: Made codebase suitable for open-source distribution

#### **User Experience**
- **Clearer Instructions**: Simplified installation and usage instructions
- **Better Tab Completion**: Fixed completion issues for better user experience
- **Consistent Behavior**: More predictable command behavior
- **Reduced Confusion**: Eliminated conflicting documentation

### 🔄 Migration Notes

#### **For Existing Users**
- **Seamless Upgrade**: No breaking changes to existing functionality
- **Improved Experience**: Better tab completion and cleaner documentation
- **Security Benefits**: Removal of sensitive data improves security posture
- **Simplified Usage**: Cleaner, more focused toolset

#### **Installation Updates**
- **Simplified Process**: Easier installation without executable script complexity
- **Clearer Instructions**: More straightforward activation steps
- **Better Documentation**: Cleaner, more accurate documentation

---

## Version 1.3 - Rust Git Integration Release

**Release Date:** August 2025

### 🚀 New Features

#### **Executable Script Architecture**
- **Universal Access**: Caddie now installs as an executable script at `~/bin/caddie`
- **PATH Integration**: Automatically adds `~/bin` to your PATH in `~/.bash_profile`
- **External Tool Integration**: Works from Makefiles, CI/CD pipelines, and other scripts
- **Standard Unix Pattern**: Follows conventional CLI tool installation practices
- **Cross-Context Compatibility**: Maintains functionality across different shell contexts

#### **Enhanced Installation Process**
- **Automatic PATH Setup**: Installs executable and updates PATH in one step
- **Duplicate Prevention**: Checks for existing PATH entries to avoid duplicates
- **Permission Management**: Sets proper executable permissions during installation
- **Directory Creation**: Creates `~/bin` directory if it doesn't exist
- **Verification Support**: Provides clear instructions for verifying installation

#### **Improved Tab Completion**
- **Hierarchical Completion**: Enhanced tab completion for subcommands with multiple colons
- **Smart Filtering**: Shows only relevant subcommands when typing `caddie rust:test:`
- **Better UX**: More intuitive completion behavior for complex command structures
- **Context Awareness**: Filters completions based on partial command input

### 🔧 Technical Improvements

#### **Makefile Enhancements**
- **Executable Installation**: Added steps to install and configure the caddie script
- **PATH Management**: Automatic PATH updates with duplicate detection
- **Error Handling**: Improved error messages and installation verification
- **Cross-Platform**: Maintains compatibility with existing installation methods

#### **Script Architecture**
- **Modular Sourcing**: Executable script sources necessary modules dynamically
- **Error Handling**: Graceful error handling for missing modules or configuration
- **Compatibility**: Maintains full compatibility with existing caddie functionality
- **Performance**: Minimal overhead compared to function-based approach

### 📚 Documentation Updates

#### **Comprehensive Documentation**
- **README.md**: Added executable script section with usage examples
- **User Guide**: Detailed explanation of executable script benefits and usage contexts
- **Installation Guide**: Step-by-step PATH setup instructions and verification steps
- **Technical Details**: Clear explanation of how the executable script works

#### **Installation Instructions**
- **Automatic Setup**: Clear explanation of what gets installed and configured
- **Manual Fallback**: Instructions for manual PATH setup if automatic setup fails
- **Verification Steps**: Commands to verify proper installation and functionality
- **Troubleshooting**: Common issues and solutions for PATH and executable problems

### 🎯 Use Cases

#### **Development Workflows**
- **Makefile Integration**: `make install` can now reliably call `caddie reload`
- **CI/CD Pipelines**: Build scripts can use caddie commands for environment setup
- **IDE Integration**: External tools can call caddie commands for project management
- **Script Automation**: Shell scripts can use caddie for consistent environment management

#### **External Tool Integration**
- **Build Systems**: Makefiles and build scripts can call caddie commands
- **Development Tools**: IDEs and editors can integrate with caddie functionality
- **Automation Scripts**: CI/CD and deployment scripts can use caddie commands
- **Cross-Platform**: Maintains functionality across different execution contexts

### 🔄 Migration Notes

#### **Backward Compatibility**
- **Function Preservation**: Existing caddie function remains available for interactive use
- **No Breaking Changes**: All existing commands and functionality remain unchanged
- **Seamless Transition**: Users can continue using caddie exactly as before
- **Enhanced Capabilities**: New executable provides additional integration possibilities

#### **Installation Impact**
- **Automatic Upgrade**: Existing installations will get the executable script on next update
- **PATH Updates**: `~/bin` will be added to PATH automatically
- **No Manual Steps**: No additional configuration required for existing users
- **Immediate Benefits**: Enhanced tab completion and external integration available immediately

### 🐛 Bug Fixes

#### **Tab Completion Improvements**
- **Fixed Subcommand Completion**: Tab completion now properly handles `caddie rust:test:` patterns
- **Better Filtering**: Shows only relevant completions for hierarchical commands
- **Improved UX**: More intuitive completion behavior for complex command structures

#### **Installation Reliability**
- **Makefile Compatibility**: Fixed `make install` command execution in different shell contexts
- **PATH Management**: Improved PATH update logic with duplicate detection
- **Error Handling**: Better error messages and recovery instructions

### 📈 Performance

#### **Execution Performance**
- **Minimal Overhead**: Executable script adds negligible performance impact
- **Efficient Sourcing**: Optimized module loading for faster command execution
- **Memory Usage**: No significant increase in memory usage compared to function approach

### 🔮 Future Enhancements

#### **Planned Features**
- **Plugin System**: Extensible architecture for third-party modules
- **Configuration Management**: Centralized configuration file management
- **Cross-Platform**: Support for Linux and Windows environments
- **Advanced Integration**: Enhanced IDE and tool integration capabilities

## Version 1.3 - Rust Git Integration Release

**Release Date:** August 2025

### 🚀 New Features

#### **Rust Git Integration**
- **Project Initialization**: New `caddie rust:init` command creates projects with comprehensive `.gitignore`
- **Git Status Monitoring**: `caddie rust:git:status` checks for tracked build artifacts and warns about issues
- **Automatic .gitignore**: `caddie rust:gitignore` adds comprehensive `.gitignore` to existing projects
- **Build Artifact Cleanup**: `caddie rust:git:clean` removes tracked build artifacts from git history
- **Prevention-First Approach**: Prevents accidental commit of build artifacts before they happen

#### **System Reload Command**
- **Environment Reload**: New `caddie reload` command refreshes the entire caddie environment
- **Profile Sourcing**: Automatically sources `~/.bash_profile` to reload all configurations
- **Quick Recovery**: Provides instant recovery from configuration changes or module updates
- **Development Workflow**: Essential for developers making changes to caddie modules or configuration
- **Installation Integration**: Updated installation process to use `caddie reload` instead of instructing manual sourcing

#### **Enhanced Rust Project Management**
- **Comprehensive .gitignore**: Covers Rust build artifacts, IDE files, OS files, and temporary files
- **Idempotent Operations**: Safe to run multiple times without side effects
- **Backup Protection**: Existing `.gitignore` files are backed up before modification
- **Clear Guidance**: Provides next steps and recommendations after each operation

#### **Advanced Testing Commands**
- **Granular Test Control**: Separate commands for unit, integration, property, and benchmark tests
- **Test Watching**: `caddie rust:test:watch` for continuous test execution
- **Coverage Analysis**: `caddie rust:test:coverage` with automatic cargo-tarpaulin installation
- **No-Capture Output**: All test commands use `--nocapture` for better debugging

### 🔧 Improvements

#### **Build Artifact Management**
- **Target Directory Detection**: Automatically detects and handles `/target/` directory tracking
- **File Type Recognition**: Identifies `.rlib`, `.rmeta`, `.so`, `.dylib`, `.dll`, `.exe` files
- **Batch Operations**: Efficiently removes multiple build artifacts in single operation
- **Safety Checks**: Validates git repository and Rust project status before operations

#### **Developer Experience**
- **Proactive Prevention**: Catches build artifact issues before they reach git history
- **Clear Feedback**: Professional CLI output with status indicators and file counts
- **Error Recovery**: Provides specific guidance for fixing detected issues
- **Tab Completion**: Full integration with existing caddie completion system

#### **Documentation Updates**
- **Comprehensive Help**: Updated `caddie rust:help` with all new git integration commands
- **User Guide**: Enhanced Rust development section with git integration examples
- **Installation Guide**: Added Rust git integration setup recommendations
- **Release Notes**: Complete documentation of new features and improvements

### 🎯 Use Cases

#### **Installation Workflow**
```bash
# Complete installation
make install

# Reload environment (now recommended)
caddie reload

# Verify installation
caddie --version
```

#### **New Rust Project Setup**
```bash
# Create project with proper .gitignore from start
caddie rust:init myproject

# Verify no build artifacts are tracked
caddie rust:git:status

# Start development with confidence
caddie rust:build
caddie rust:test:unit
```

#### **Existing Project Cleanup**
```bash
# Add comprehensive .gitignore
caddie rust:gitignore

# Check for existing build artifacts
caddie rust:git:status

# Remove tracked build artifacts
caddie rust:git:clean

# Commit the cleanup
git commit -m "Remove build artifacts and add .gitignore"
```

#### **Continuous Development Workflow**
```bash
# Regular development cycle
caddie rust:build
caddie rust:test:unit
caddie rust:test:integration

# Before committing, check for artifacts
caddie rust:git:status

# If clean, proceed with commit
git add .
git commit -m "Add new feature"
```

### 📦 Technical Details

#### **New Commands Added**
- `caddie rust:init <name>` - Create project with .gitignore
- `caddie rust:git:status` - Check git status for build artifacts
- `caddie rust:gitignore` - Add comprehensive .gitignore
- `caddie rust:git:clean` - Remove tracked build artifacts
- `caddie reload` - Reload caddie environment and configuration

#### **Enhanced Test Commands**
- `caddie rust:test:unit` - Unit tests with --nocapture
- `caddie rust:test:integration` - Integration tests with --nocapture
- `caddie rust:test:all` - All tests with --nocapture
- `caddie rust:test:property` - Property-based tests
- `caddie rust:test:bench` - Benchmarks
- `caddie rust:test:watch` - Watch mode with cargo-watch
- `caddie rust:test:coverage` - Coverage with cargo-tarpaulin

#### **Git Integration Features**
- **Comprehensive .gitignore**: 50+ patterns covering Rust, IDE, OS, and temporary files
- **Build Artifact Detection**: Regex patterns for all common Rust build outputs
- **Safe Operations**: Validation of git repository and project structure
- **Backup Protection**: Automatic backup of existing .gitignore files

---

## Version 1.2 - Cross-Platform Rust Integration Release

**Release Date:** August 2025

### 🚀 New Features

#### **Cross-Platform Rust Development**
- **iOS Rust Integration**: New `caddie ios:rust:setup` command for iOS development with Rust
- **Automatic Target Management**: Automatically adds iOS-specific Rust targets (aarch64-apple-ios, x86_64-apple-ios)
- **Essential Tool Installation**: Installs cargo-edit, cargo-watch, and cargo-tarpaulin for iOS development
- **Environment Validation**: Comprehensive validation of Xcode, Swift, and Rust environments
- **Idempotent Operations**: Safe to run multiple times without errors

#### **Enhanced iOS Module**
- **Rust Integration**: Seamless Rust setup for iOS development workflows
- **Swift-Rust Bridge**: Streamlined setup for Swift applications consuming Rust libraries
- **Framework Support**: Preparation for iOS framework integration with Rust static libraries
- **Next Steps Guidance**: Clear instructions for building and integrating Rust libraries

#### **Comprehensive Documentation**
- **New iOS Module Documentation**: Complete `docs/modules/ios.md` with all iOS commands
- **Rust Module Updates**: Enhanced `docs/modules/rust.md` with iOS integration section
- **User Guide Integration**: Updated workflow examples for iOS-Rust development
- **Installation Guide Updates**: Cross-platform setup instructions

### 🔧 Improvements

#### **Command Structure**
- **Platform-Specific Commands**: `caddie ios:rust:setup` pattern for platform-specific Rust setup
- **Extensible Design**: Foundation for future `caddie watchos:rust:setup` and `caddie android:rust:setup`
- **Consistent CLI**: Maintains existing caddie command patterns and help system

#### **Developer Experience**
- **One-Command Setup**: Complete iOS Rust environment setup with single command
- **Clear Feedback**: Professional CLI output with status indicators and next steps
- **Error Handling**: Graceful handling of missing dependencies and validation failures
- **Tab Completion**: Full integration with existing caddie completion system

#### **Documentation Quality**
- **Static Documentation**: Comprehensive markdown documentation for all new features
- **Help Integration**: Complete help system integration with examples
- **Cross-Reference**: Proper linking between iOS and Rust module documentation

### 🎯 Use Cases

#### **iOS Development with Rust**
```bash
# Setup complete iOS Rust environment
caddie ios:rust:setup

# Build Rust library for iOS
cargo build --target aarch64-apple-ios --release --lib

# Create iOS framework structure
# ... integrate with iOS project ...

# Build iOS project with Rust library
caddie ios:build
```

#### **Cross-Platform Development Workflow**
- **Swift Applications**: Consume Rust libraries for performance-critical components
- **Framework Development**: Create iOS frameworks with Rust backend
- **Performance Optimization**: Leverage Rust's performance for iOS applications
- **Code Sharing**: Share business logic between iOS and other platforms

### 📦 Technical Details

#### **Rust Targets Added**
- `aarch64-apple-ios` - ARM64 for iOS devices
- `x86_64-apple-ios` - x86_64 for iOS Simulator

#### **Cargo Tools Installed**
- `cargo-edit` - Dependency management
- `cargo-watch` - Development workflow
- `cargo-tarpaulin` - Code coverage

#### **Environment Validation**
- Xcode installation and version
- Swift availability and version
- Rust installation and toolchain
- iOS SDK accessibility

---

## Version 1.1 - CLI Enhancement Release

**Release Date:** September 3, 2025

### 🎨 New Features

#### **CLI Formatting System**
- **New CLI Module**: Introduced `modules/dot_caddie_cli` with comprehensive formatting utilities
- **Color Support**: Full ANSI color support with `tput` for reliable terminal output
- **UTF-8 Icons**: Rich set of semantic icons (✓, ✗, →, 📁, 🍺, 🐍, 🦀, 🗑️, 🔄, 📊, 🔍, 💾, ⚠, 🐛, 🔧, 🐳, 📦, 🌐, 🚀, 💡)
- **Consistent Formatting**: Standardized output across all modules with `caddie cli:` commands

#### **Enhanced Module Output**
- **iOS Module**: Refactored to use CLI commands for all output
- **JavaScript Module**: Complete CLI integration with NVM and framework support
- **Python Module**: Virtual environment management with CLI formatting
- **Ruby Module**: RVM integration with consistent CLI output
- **Rust Module**: Cargo toolchain management with CLI formatting
- **Cross Module**: Development tools with CLI integration
- **Cursor Module**: IDE integration with CLI formatting
- **Debug Module**: Debug utilities with CLI output

#### **New CLI Commands**
- `caddie cli:title` - Section headers with green formatting
- `caddie cli:check` - Success messages with green checkmark
- `caddie cli:x` - Error messages with red X
- `caddie cli:warning` - Warning messages with yellow warning icon
- `caddie cli:indent` - Consistent 2-space indentation
- `caddie cli:usage` - Usage instructions in blue
- `caddie cli:thought` - Helpful tips and notes
- `caddie cli:blank` - Empty line spacing
- And many more utility functions for rich CLI output

### 🔧 Improvements

#### **Module Organization**
- Moved `dot_caddie_core` to `modules/` directory
- Standardized module structure across all language modules
- Improved module sourcing and dependency management

#### **Documentation**
- Updated all help functions to use new CLI formatting
- Enhanced README with CLI examples and usage
- Improved user guide with CLI command references
- Added comprehensive module documentation

#### **Developer Experience**
- Consistent error handling across all modules
- Professional-looking output with colors and icons
- Better user feedback for all operations
- Improved tab completion with new CLI commands

### 🐛 Bug Fixes
- Fixed circular dependency issues in debug module
- Resolved terminal prompt colorization and line wrapping
- Fixed module sourcing conflicts
- Corrected tab completion for new CLI commands

---

## Version 1.0 - Initial Release

**Release Date:** August 2025

### 🚀 Core Features

#### **Modular Architecture**
- **Core Module**: Home directory management, debug control, alias management
- **Language Modules**: iOS, JavaScript, Python, Ruby, Rust development tools
- **Development Tools**: Cross-platform development, Cursor IDE integration
- **Git Integration**: Enhanced prompt with git status and branch information

#### **Productivity Features**
- **Alias Management**: Comprehensive alias system with categorization
- **Quick Navigation**: `caddie go:home` for rapid directory access
- **Search Capabilities**: `ag` alias and `caddie core:alias:grep` for finding aliases
- **Category-based Aliases**: Git, Docker, package management, navigation aliases

#### **Development Environment**
- **iOS Development**: Xcode integration, simulator management, CocoaPods
- **JavaScript/Node.js**: NVM support, framework creation, package management
- **Python**: Virtual environment management, pip integration, project structure
- **Ruby**: RVM support, Rails integration, gem management
- **Rust**: Cargo toolchain, dependency management, component installation

#### **CLI Design**
- **Consistent Interface**: `caddie <module>:<command>` pattern
- **Tab Completion**: Intelligent command completion with bash integration
- **Help System**: Comprehensive help for all modules and commands
- **Version Management**: Built-in version tracking and display

### 📦 Installation
- **Makefile-based**: Simple `make install` and `make uninstall`
- **Bash Integration**: Automatic sourcing in `.bashrc` and `.bash_profile`
- **Cross-platform**: macOS and Linux support
- **Homebrew Compatible**: Works with Homebrew-installed bash

### 🎯 Use Cases
- **Development Workflow**: Streamlined multi-language development
- **Environment Management**: Consistent toolchain setup across languages
- **Productivity Enhancement**: Quick access to common development tasks
- **Team Collaboration**: Standardized development environment setup

---

## Version History

| Version | Date | Description |
|---------|------|-------------|
| 1.2 | Dec 2025 | Cross-Platform Rust Integration Release - iOS Rust setup, comprehensive documentation |
| 1.1 | Dec 2025 | CLI Enhancement Release - Rich formatting, UTF-8 icons, consistent output |
| 1.0 | Nov 2025 | Initial Release - Core functionality, language modules, productivity features |

---

## Upcoming Features

### Planned for Version 1.3
- **WatchOS Rust Integration**: `caddie watchos:rust:setup` for WatchOS development
- **Android Rust Integration**: `caddie android:rust:setup` for Android development
- **Plugin System**: Third-party module support
- **Configuration Management**: User-configurable settings

### Future Roadmap
- **GUI Interface**: Optional graphical interface
- **Mobile Support**: iOS/Android companion apps
- **API Integration**: REST API for external tool integration
- **Advanced Analytics**: Usage statistics and optimization suggestions
