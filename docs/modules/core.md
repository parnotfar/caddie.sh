# Core Module

The Core module provides the foundation for Caddie.sh, including basic functions, debug system, and home directory management.

## Overview

The Core module is loaded first and provides essential functionality that other modules depend on. It includes:

- **Home Directory Management**: Set and manage your project home directory
- **Debug System**: Control debug output and logging
- **Basic Functions**: Core utilities and helpers
- **Interactive Prompt**: Shell-like REPL for chaining module commands quickly

## Commands

### Home Directory Management

#### `caddie core:set:home <path>`

Set your Caddie.sh home directory for project management.

**Arguments:**
- `path`: Directory path (supports ~, relative, and absolute paths)

**Examples:**
```bash
# Set home to projects directory
caddie core:set:home ~/projects

# Set home to absolute path
caddie core:set:home /Users/username/Development

# Set home to relative path
caddie core:set:home ./my-projects
```

**What it does:**
- Expands the path (handles ~, relative paths, etc.)
- Verifies the directory exists
- Converts to absolute path
- Saves the path to `~/.caddie_home`
- Exports `CADDIE_HOME` environment variable

**Output:**
```
✓ Caddie home directory set to: /Users/username/projects
```

#### `caddie core:get:home`

Display your current Caddie.sh home directory.

**Examples:**
```bash
caddie core:get:home
```

**Output:**
```
Current caddie home: /Users/username/projects
```

**Or if not set:**
```
No caddie home directory was set
```

#### `caddie core:reset:home`

Reset your Caddie.sh home directory to default (unset).

**Examples:**
```bash
caddie core:reset:home
```

**Output:**
```
✓ Caddie home directory has been reset
```

**What it does:**
- Removes the `~/.caddie_home` file
- Unsets the `CADDIE_HOME` environment variable

### Debug System

The debug system allows you to control debug output throughout Caddie.sh. When enabled, debug messages are prefixed with "DEBUG:" and show detailed information about operations.

#### `caddie core:debug on`

Enable debug output mode.

**Examples:**
```bash
caddie core:debug on
```

**Output:**
```
✓ Debug mode enabled
```

**What it does:**
- Sets `CADDIE_DEBUG=1`
- Exports the variable for all child processes
- Enables debug output for all subsequent commands

#### `caddie core:debug off`

Disable debug output mode.

**Examples:**
```bash
caddie core:debug off
```

**Output:**
```
✓ Debug mode disabled
```

**What it does:**
- Sets `CADDIE_DEBUG=0`
- Exports the variable for all child processes
- Disables debug output for all subsequent commands

#### `caddie core:debug status`

Show current debug mode status.

**Examples:**
```bash
caddie core:debug status
```

**Output:**
```
Debug mode is: on
```

**Or:**
```
Debug mode is: off
```

## Interactive Prompt

Run `caddie` with no arguments to launch the interactive prompt. The prompt keeps you inside a caddie-focused shell where you can lead with a module name, then provide subcommands or flags.

```bash
$ caddie
caddie-3.7> rust fix           # Equivalent to `caddie rust:fix`
caddie-3.7> rust               # Switches scope to the Rust module
caddie[rust]-3.7> fix all      # Equivalent to `caddie rust:fix:all`
caddie[rust]-3.7> back         # Leaves the module scope
caddie-3.7> `git status`       # Run an inline shell command without leaving the REPL
caddie-3.7> shell ls -1        # One-off shell command via the shell bridge
caddie-3.7> rust build         # Start a long-running task
# Press Ctrl+C here to cancel the task while staying in the prompt
caddie-3.7> exit
```

**Features:**
- Converts `module subcommand` into `module:subcommand` automatically (e.g., `rust test unit` → `rust:test:unit`).
- Typing a module name enters a scoped prompt (`caddie[module]-3.7>`), so subsequent commands assume that module until you `back`, `up`, or `..`.
- Run raw shell commands inline with backticks or the `shell` helper, no context switching required.
- REPL history is written to `~/.caddie_history` so shell history stays untouched while arrow keys still recall commands.
- Honors existing `module:command` syntax and arguments (e.g., `rust:run -- --help`).
- Supports built-ins like `help`, `version`, and `reload` directly at the prompt.
- Exit at any time with `exit`, `quit`, or `Ctrl+D`, and use `Ctrl+C` to stop the active command without closing the REPL.
- Full Readline editing and history support (e.g., `Ctrl+A`, `Ctrl+E`, `Ctrl+P` for navigation).

### System Management

#### `caddie reload`

Reload the entire Caddie.sh environment and configuration.

**Examples:**
```bash
# Reload after making changes to caddie modules
caddie reload

# Reload after updating ~/.bash_profile
caddie reload

# Reload after installing new modules
caddie reload
```

**What it does:**
- Sources `~/.bash_profile` to reload all configurations
- Refreshes environment variables and module loading
- Provides instant recovery from configuration changes
- Essential for developers making changes to caddie modules

**Output:**
```
(No output - silently reloads the environment)
```

**Use cases:**
- After modifying caddie module files
- After updating `~/.bash_profile` or `~/.bashrc`
- After installing new development tools
- When environment variables seem stale
- During development and testing of caddie modules

**Requirements:**
- Must be run from a shell that has caddie loaded
- Requires `~/.bash_profile` to be properly configured

## Debug Output Examples

When debug mode is enabled, you'll see detailed information about Caddie.sh operations:

### Module Loading
```
DEBUG: === Starting module loading process ===
DEBUG: CADDIE_MODULES_DIR: /Users/username/.caddie_modules
DEBUG: === Module loading complete ===
DEBUG: Final commands count: 45
DEBUG: Final help count: 9
```

### Command Execution
```
DEBUG: === caddie function called ===
DEBUG: command='python:create'
DEBUG: remaining args='myproject'
DEBUG: Current commands count: 45
DEBUG: Found function 'caddie_python_create', executing with args: myproject
```

### Help System
```
DEBUG: === caddie_help function called ===
DEBUG: Current commands count: 45
DEBUG: Current help count: 9
```

## Environment Variables

### `CADDIE_HOME`

**Purpose**: Your project home directory
**Set by**: `caddie core:set:home <path>`
**Default**: Not set
**File**: `~/.caddie_home`

**Usage in scripts:**
```bash
if [ -n "$CADDIE_HOME" ]; then
    cd "$CADDIE_HOME"
    echo "Working in Caddie home: $CADDIE_HOME"
fi
```

### `CADDIE_DEBUG`

**Purpose**: Control debug output
**Values**: `0` (off) or `1` (on)
**Default**: `0`
**Set by**: `caddie core:debug <command>`

**Usage in scripts:**
```bash
if [ "$CADDIE_DEBUG" -eq 1 ]; then
    echo "DEBUG: This is debug output"
fi
```

### `CADDIE_MODULES_DIR`

**Purpose**: Directory containing Caddie.sh modules
**Default**: `~/.caddie_modules`
**Set by**: Caddie.sh automatically

**Usage in scripts:**
```bash
if [ -d "$CADDIE_MODULES_DIR" ]; then
    echo "Modules directory: $CADDIE_MODULES_DIR"
fi
```

## Internal Functions

### `caddie_debug()`

**Purpose**: Output debug messages (only when debug is enabled)
**Arguments**: `message` - The debug message to output
**Returns**: Nothing

**Usage:**
```bash
caddie_debug "Processing file: $filename"
caddie_debug "User input: $user_input"
```

**Output when debug enabled:**
```
DEBUG: Processing file: example.txt
DEBUG: User input: user@example.com
```

**Output when debug disabled:**
```
(no output)
```

### `caddie_debug_is_enabled()`

**Purpose**: Check if debug mode is enabled
**Arguments**: None
**Returns**: Exit code 0 (enabled) or 1 (disabled)

**Usage:**
```bash
if caddie_debug_is_enabled; then
    echo "Debug mode is on"
else
    echo "Debug mode is off"
fi
```

## Configuration Files

### `~/.caddie_home`

**Purpose**: Stores your Caddie.sh home directory path
**Format**: Single line with absolute path
**Example content:**
```
/Users/username/Development
```

**Permissions**: `644` (readable by user, readable by group/others)

## Error Handling

### Common Errors

#### "Error: Please provide a path for caddie home"
**Cause**: No path argument provided
**Solution**: Provide a path: `caddie core:set:home ~/projects`

#### "Error: Directory '/path' does not exist"
**Cause**: The specified directory doesn't exist
**Solution**: Create the directory first or use an existing path

#### "Error: Invalid debug action 'invalid'"
**Cause**: Invalid debug command provided
**Solution**: Use valid actions: `on`, `off`, or `status`

### Error Output Format

All errors follow a consistent format:
```
Error: <description>
Usage: caddie core:<command> <arguments>
```

## Best Practices

### Debug Usage

1. **Development**: Enable debug mode during development and testing
2. **Production**: Disable debug mode in production environments
3. **Troubleshooting**: Enable debug mode when investigating issues
4. **Scripts**: Check debug status before outputting debug information

### Home Directory

1. **Consistent Location**: Use a consistent location across machines
2. **Version Control**: Include your home directory in version control
3. **Team Sharing**: Use the same home directory structure across your team
4. **Backup**: Include home directory in your backup strategy

### Environment Variables

1. **Check Before Use**: Always check if variables are set before using them
2. **Default Values**: Provide sensible defaults when variables aren't set
3. **Documentation**: Document all environment variables in your scripts
4. **Validation**: Validate variable values before using them

## Examples

### Complete Setup Script

```bash
#!/bin/bash
# setup-caddie.sh

# Enable debug mode for setup
caddie core:debug on

# Set project home directory
caddie core:set:home ~/Development

# Verify setup
caddie core:get:home

# Disable debug mode
caddie core:debug off

echo "Caddie.sh setup complete!"
```

### Conditional Debug Output

```bash
#!/bin/bash
# my-script.sh

# Function with debug output
process_file() {
    local filename="$1"
    
    caddie_debug "Starting file processing: $filename"
    
    if [ ! -f "$filename" ]; then
        caddie_debug "File not found: $filename"
        return 1
    fi
    
    caddie_debug "File found, processing..."
    # ... processing logic ...
    
    caddie_debug "File processing complete: $filename"
}

# Use the function
process_file "example.txt"
```

### Environment Check

```bash
#!/bin/bash
# check-environment.sh

echo "Caddie.sh Environment Check"
echo "=========================="

# Check home directory
if [ -n "$CADDIE_HOME" ]; then
    echo "✓ Home directory: $CADDIE_HOME"
else
    echo "✗ Home directory not set"
fi

# Check debug mode
if caddie_debug_is_enabled; then
    echo "✓ Debug mode: enabled"
else
    echo "✓ Debug mode: disabled"
fi

# Check modules directory
if [ -d "$CADDIE_MODULES_DIR" ]; then
    echo "✓ Modules directory: $CADDIE_MODULES_DIR"
    echo "  Modules found: $(ls "$CADDIE_MODULES_DIR" | wc -l)"
else
    echo "✗ Modules directory not found"
fi
```

## Troubleshooting

### Debug Mode Not Working

1. **Check if function exists:**
   ```bash
   type caddie_debug
   ```

2. **Verify debug file is sourced:**
   ```bash
   ls -la ~/.caddie_debug
   ```

3. **Check environment variable:**
   ```bash
   echo "CADDIE_DEBUG: $CADDIE_DEBUG"
   ```

### Home Directory Issues

1. **Check if file exists:**
   ```bash
   cat ~/.caddie_home
   ```

2. **Verify directory exists:**
   ```bash
   ls -la "$(cat ~/.caddie_home)"
   ```

3. **Check permissions:**
   ```bash
   ls -la ~/.caddie_home
   ```

### Module Loading Problems

1. **Enable debug mode:**
   ```bash
   caddie core:debug on
   caddie help
   ```

2. **Check modules directory:**
   ```bash
   ls -la ~/.caddie_modules/
   ```

3. **Verify file permissions:**
   ```bash
   find ~/.caddie_modules -name ".caddie_*" -exec ls -la {} \;
   ```

## Related Documentation

- **[Installation Guide](../installation.md)** - How to install Caddie.sh
- **[User Guide](../user-guide.md)** - General usage instructions
- **[Configuration Guide](../configuration.md)** - Customization options
- **[Troubleshooting Guide](../troubleshooting.md)** - Common issues and solutions

---

*The Core module is the foundation of Caddie.sh. Understanding these functions will help you use the system effectively and troubleshoot any issues.*
