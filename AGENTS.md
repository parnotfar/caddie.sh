# AGENTS.md

## Project Overview

* **Project Name**: Par Not Far — *caddie*
* **Description**: A modular Bash-based development environment manager for the Par Not Far platform and applications. It provides a common language for tasks, unifies tooling across languages (Rust, Python, JS, iOS, etc.), and is fully extensible with new modules.
* **Design Principles**:
  * **Modular**: Features are organized into modules (e.g., `rust`, `git`, `python`)
  * **Composable**: Common interface for commands across modules
  * **Extensible**: Developers can create new modules or extend existing ones
  * **Portable**: Works across macOS/Linux development environments

---

## Project Structure

* **Root Directory**: Contains main entry point (`dot_caddie`) and core system files
* **`modules/` Directory**: Contains all functional module files (Python, Rust, Ruby, etc.) and core functions
* **`docs/` Directory**: Comprehensive documentation and guides
* **Core System Files**: `dot_caddie_debug`, `dot_caddie_modules`, `dot_caddie_prompt`, `dot_caddie_version`
* **Module Files**: All `dot_caddie_*` files including `dot_caddie_core` are in the `modules/` directory

### Key Files:
* `dot_caddie`: Main entry point that manages global state and module initialization
* `modules/dot_caddie_core`: Core functions and debug system
* `modules/dot_caddie_*`: Language-specific modules (rust, python, ruby, js, ios, etc.)
* `Makefile`: Handles installation, module registration, and development setup

---

## Environment & Tooling

* **Shell**: Bash (>= 4.x preferred)
* **Style**:
  * Use `#!/usr/bin/env bash`
  * Functions and namespaces: `<module>:<command>` convention
  * Source CLI module for formatting: `source "$HOME/.caddie_modules/.caddie_cli"`
* **Testing**: Manual testing with `caddie reload` and command validation

---

## Usage

General pattern:

```sh
caddie <module>:<command> [args]
```

Examples:

```sh
caddie rust:build
caddie git:gacp "Initial commit"
caddie python:test
caddie cursor:help
```

---

## Development Workflow

### Adding a New Module

**CRITICAL**: Follow these exact steps to ensure proper integration:

1. **Create module file**: Create `modules/dot_caddie_<module>` (e.g., `modules/dot_caddie_golang`)

2. **Module structure template**:
```bash
#!/usr/bin/env bash

# Caddie.sh - <Module Name> Environment Management
# This file contains all <module>-related functions

# Source CLI module for formatting
source "$HOME/.caddie_modules/.caddie_cli"

# Function to provide module description
function caddie_<module>_description() {
    printf '%s\n' 'Brief description of the module'
    return 0
}

function caddie_<module>_help() {
    caddie cli:title "<Module Name> Commands"
    caddie cli:usage "caddie <module>:<command>"
    caddie cli:blank
    caddie cli:indent "<module>:command1 - Performs command1 task"
    caddie cli:indent "<module>:command2 - Performs command2 task"
    return 0
}

# Main command functions
function caddie_<module>_command1() {
    local argument="$1"
    
    # Input validation
    if [ -z "$argument" ]; then
        caddie cli:red "Error: Argument required"
        caddie cli:usage "caddie <module>:command1 <argument>"
        return 1
    fi
    
    # Implementation with error handling
    caddie cli:title "Processing: $argument"
    # ... main logic ...
    caddie cli:check "Command completed successfully"
    return 0
}

# Export functions
export -f caddie_<module>_description
export -f caddie_<module>_help
export -f caddie_<module>_command1
```

3. **Update Makefile**: Add module installation to `install-dot` target:
```makefile
cp "$(SRC_MODULES_DIR)/dot_caddie_<module>" "$(DEST_MODULES_DIR)/.caddie_<module>"
echo "$(GREEN)    ✓$(NC) Successfully installed $(DEST_MODULES_DIR)/.caddie_<module>"
```

4. **Expose tab completion**: Implement `caddie_<module>_commands()` to print a space-separated list of `<module>:command` entries (or call `caddie_completion_register "<module>" "<module>:command1 …"` inside the module). Caddie will invoke these during module discovery—no manual edits to `_caddie_completion` are required.

5. **Test installation**:
```sh
make install-dot
caddie reload
caddie <module>:help
caddie <module>:command1 test
```

### Modifying Existing Modules

* Keep consistent naming (always `<module>:<command>`)
* Update `help` output with new commands
* Ensure all affected modules remain functional (`caddie reload`)
* Follow existing error handling patterns with `caddie cli:*` functions

### Testing & Validation

```sh
caddie core:debug on         # enable debug logging
caddie <module>:help         # verify help output
caddie <module>:command      # test functionality
caddie core:lint             # run comprehensive caddie-specific linting (shows ALL issues)
caddie core:lint <path>      # lint specific file or directory (shows ALL issues)
caddie core:lint:limit <n> <path>  # lint with limited output (max n issues per check)
caddie reload                # reload after changes
```

### Pre-PR Quality Check

**MANDATORY**: Before creating any pull request, run the linter to ensure code quality:

```sh
# Lint all modified files (recommended)
caddie core:lint

# Or lint specific files you've changed
caddie core:lint modules/dot_caddie_<module>

# For focused debugging with limited output
caddie core:lint:limit 5 modules/dot_caddie_<module>
```

**PR Approval Requirements:**
- ✅ All linter checks must pass with zero warnings
- ✅ No echo statements (use `caddie cli:*` functions)
- ✅ All functions have explicit return statements
- ✅ No variable shadowing issues
- ✅ Proper local variable declarations

#### **Universal Shell Linter (v2.0)**
The linter is now universal - it can lint any shell script, not just caddie modules. It includes comprehensive echo message detection and flexible output:
- **Usage Messages**: `echo "Usage..."` → `caddie cli:usage`
- **Success Messages**: `echo "✓..."` → `caddie cli:check`
- **Failure Messages**: `echo "✗..."` → `caddie cli:red`
- **General Messages**: `echo "..."` → `caddie cli:indent`
- **Variable Shadowing Detection**: Detects `local` declarations inside conditional blocks that shadow outer variables
- **Flexible Output**: `caddie core:lint` shows ALL issues, `caddie core:lint:limit <n>` shows max n issues per check
- **Smart Heredoc Detection**: Optimized performance with intelligent pattern detection
- **Technical Echo Exclusion**: Excludes pipe operations from general echo warnings
- **Lint Ignore Blocks**: Use `# caddie:lint:disable` and `# caddie:lint:enable` to suppress warnings
  - Prevents linter from flagging its own implementation code
  - Allows exceptions for legacy code, third-party code, or complex edge cases
  - Self-documenting and maintainable approach

---

## Git Workflow

* Quick commit & push:
  ```sh
  caddie git:gacp "Add new <module> module"
  ```
* Create and publish new branch:
  ```sh
  caddie git:new:branch feature/new-feature
  ```
* Check status:
  ```sh
  caddie git:status
  ```
* Clone repository:
  ```sh
  caddie git:clone my-project
  ```
* Create pull request:
  ```sh
  caddie git:pr:create "Add new feature" "Description of changes"
  ```

---

## Installation & Setup

### Development Environment Setup

1. **Fork and clone**:
   ```bash
   git clone https://github.com/parnotfar/caddie.sh.git
   cd caddie.sh
   ```

2. **Install development dependencies**:
   ```bash
   make setup-dev
   ```

3. **Install caddie locally**:
   ```bash
   make install
   source ~/.bash_profile
   ```

4. **Verify installation**:
   ```bash
   caddie --version
   caddie help
   ```

**For subsequent updates** (when caddie is already installed):
```bash
make install-dot
caddie reload
```

### Module Installation Process

The Makefile handles module installation automatically:
- Copies from `modules/dot_caddie_*` to `~/.caddie_modules/.caddie_*`
- Creates necessary directories
- Installs core system files
- Sets up tab completion

---

## Code Standards

### Shell Script Standards

* **Error handling**: Always check for errors and provide meaningful messages
* **Input validation**: Validate all arguments with clear error messages
* **Explicit return statements**: Always include explicit `return 0` or `return 1` statements instead of relying on the exit status of the last command
* **CLI integration**: Use `caddie cli:*` functions for consistent output formatting
* **Output formatting**: **ALWAYS** use `caddie cli:*` functions instead of raw `echo` or `printf`
  * **Error messages**: `caddie cli:red "Error message"` (never `echo "Error..."`)
  * **Success messages**: `caddie cli:check "Success message"` or `caddie cli:green "..."` (never `echo "✓..."`)
  * **Usage messages**: `caddie cli:usage "command [args]"` (never `echo "Usage..."`)
  * **Titles/Headers**: `caddie cli:title "Section Title"` (never `echo "== Title =="`)
  * **Indented text**: `caddie cli:indent "text"` (never `echo "  text"`)
  * **Warnings**: `caddie cli:yellow "warning"` or `caddie cli:thought "tip"`
  * **Raw output for pipes/processing**: Only use `echo`/`printf` when output is being piped to another command or processed programmatically
  * **Function return values**: Use `printf '%s\n'` for description functions that return text (e.g., `caddie_<module>_description`)
* **Version detection**: For tools that support it, automatically detect and use the latest stable version unless explicitly pinned via environment variable (e.g., `CADDIE_<TOOL>_VERSION`)
* **Environment variable access**: **ALWAYS** create get/set/unset commands for environment variables instead of accessing them directly. This provides a consistent API, enables validation, and improves maintainability. See "Environment Variable Management Pattern" below.
* **Function structure**: Follow the established pattern with proper documentation

### Environment Variable Management Pattern

**CRITICAL**: When modules use environment variables for configuration, **ALWAYS** provide getter/setter/unsetter commands instead of documenting direct environment variable access.

**Pattern:**
```bash
# ✅ CORRECT: Provide get/set/unset commands
function caddie_<module>_<config>_set() {
    local value="$1"
    if [ -z "$value" ]; then
        caddie cli:red "Error: Please provide a value"
        caddie cli:usage "caddie <module>:<config>:set <value>"
        return 1
    fi
    export CADDIE_<MODULE>_<CONFIG>="$value"
    caddie cli:check "<Config> set to: $value"
    return 0
}

function caddie_<module>_<config>_get() {
    local value="${CADDIE_<MODULE>_<CONFIG>:-}"
    if [ -n "$value" ]; then
        caddie cli:green "<Config>: $value"
    else
        caddie cli:yellow "No <config> is set"
        caddie cli:thought "Use 'caddie <module>:<config>:set <value>' to set it"
    fi
    return 0
}

function caddie_<module>_<config>_unset() {
    if [ -n "${CADDIE_<MODULE>_<CONFIG>:-}" ]; then
        unset CADDIE_<MODULE>_<CONFIG>
        caddie cli:check "<Config> unset"
    else
        caddie cli:yellow "No <config> was set"
    fi
    return 0
}
```

**Examples:**
- `caddie github:account:set <account>` / `caddie github:account:get` / `caddie github:account:unset`
- `caddie ruby:pin:set <version>` / `caddie ruby:pin:get` / `caddie ruby:pin:unset`
- `caddie core:set:home <path>` / `caddie core:get:home` / `caddie core:reset:home`

**Internal access:** Within module functions, you may still access the environment variable directly (e.g., `local value="${CADDIE_<MODULE>_<CONFIG>:-}"`), but **documentation and help text should only reference the get/set/unset commands**, not direct environment variable access.

**Benefits:**
- Consistent API across all modules
- Built-in validation and error handling
- Better user experience with helpful error messages
- Easier to maintain and extend functionality
- Enables future features (persistence, validation, etc.)

### Module Development Standards

* **Function naming**: `caddie_<module>_<command>` format
* **Export functions**: Always export functions with `export -f`
* **Help integration**: Provide `caddie_<module>_help()` and `caddie_<module>_description()`
* **Error handling**: Use `caddie cli:red`, `caddie cli:usage` for consistent error messages

---

## Agent-Specific Guidance

### Critical Instructions for AI Agents

**ALWAYS REMEMBER THESE RULES:**

1. **Module Location**: All modules are in `modules/` directory, NOT root directory
2. **File Naming**: Module files must be named `dot_caddie_<module>` (e.g., `dot_caddie_golang`)
3. **Makefile Integration**: New modules MUST be added to Makefile `install-dot` target
4. **Tab Completion**: Provide completions via `caddie_<module>_commands()` or `caddie_completion_register`—do not edit `_caddie_completion` directly
5. **Module Registration**: Modules are auto-discovered once installed; do not modify `dot_caddie_modules` manually
6. **CLI Integration**: Always source CLI module and use `caddie cli:*` functions
7. **Function Export**: Always export functions with `export -f`
8. **Error Handling**: Follow established patterns with proper validation and error messages
9. **Release Versioning**: Every release requires a version update (bugfix/minor/major) and a matching section in `RELEASE_NOTES.md`. If the release type is unclear when new functionality is requested, ask which release type to use before updating version numbers. Versioning follows `[major].[minor].[bugfix]`.
10. **Human-Readable Commands**: Prefer descriptive subcommands over flags for user-facing behaviors (e.g., `mac:screenshot:archive:dry:run` instead of `--dry-run`) to improve readability and tab completion. If a request suggests flags, propose the equivalent named command.

### Development Commands

* Always prefer `caddie <module>:<command>` instead of raw language-specific commands
* Use `caddie reload` after making changes to reload the environment
* Test with `caddie <module>:help` to verify module integration
* Use `make install-dot` followed by `caddie reload` to reinstall after changes

### When Adding New Modules

1. **Create the module file** in `modules/` directory
2. **Update Makefile** to include module installation
3. **Expose tab completion** by providing `caddie_<module>_commands()` or calling `caddie_completion_register`
4. **Test installation** with `make install-dot`
5. **Verify functionality** with `caddie <module>:help`
6. **Confirm tab completion** after `caddie reload`

### When Modifying Existing Modules

* Keep consistent naming (always `<module>:<command>`)
* Update help output with new commands
* Ensure all affected modules remain functional
* Follow existing error handling patterns
* Test with `caddie reload` after changes

### Documentation Requirements

* Document new modules and commands in `docs/`
* Update README.md for new features
* Provide practical usage examples
* Include error handling documentation

### Testing Requirements

* Run `caddie core:lint` on all modified files (UNIVERSAL in v2.0)
  * Can now lint any shell script, not just caddie modules
  * Comprehensive echo message detection and enforcement
  * Variable shadowing detection for subtle bug prevention
  * Flexible output: `caddie core:lint` (all issues) or `caddie core:lint:limit <n>` (limited)
  * Optimized performance with smart heredoc detection
  * Covers usage, success, failure, and general message patterns
* Test with `caddie <module>:help` and `caddie <module>:command`
* Verify tab completion works
* Test error cases and edge conditions
* Use `caddie reload` to test environment reloading

---

## CI/CD Sequence

1. Run all `caddie *:test` commands for enabled modules
2. Verify `caddie help` and `caddie <module>:help` produce expected output
3. Test tab completion functionality
4. **MANDATORY**: Run `caddie core:lint` on all modified files (UNIVERSAL in v2.0)
   - Must pass with zero warnings before PR approval
   - Ensures code quality and consistency across all shell scripts
5. Verify Makefile installation process

---

## Memory Instructions for AI Agents

**CRITICAL**: These instructions must be remembered between chat sessions:

1. **Project Structure**: caddie.sh is a modular Bash development environment manager
2. **Module Location**: All modules are in `modules/` directory with `dot_caddie_<module>` naming
3. **Installation Process**: Use Makefile for installation, modules go to `~/.caddie_modules/`
4. **Command Pattern**: Always use `caddie <module>:<command>` format
5. **Integration Requirements**: New modules need Makefile, tab completion, and module registration updates
6. **CLI Integration**: Always use `caddie cli:*` functions for consistent output
7. **Error Handling**: Follow established patterns with proper validation
8. **Testing**: Use `caddie reload` and `caddie <module>:help` for validation
9. **Git Workflow**: Use `caddie git:gacp` for commits
10. **Documentation**: Update docs/ directory and README.md for new features

**Remember**: This is a Bash-based modular system where consistency and proper integration are critical for functionality.
