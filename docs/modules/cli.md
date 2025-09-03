# CLI Module

The CLI module provides sophisticated color utilities and formatting functions for building better command-line interfaces throughout the Caddie.sh system.

## Overview

The CLI module offers a comprehensive set of color output functions that make it easy to create visually appealing and informative command-line output. All functions use `tput` for reliable color definitions across different terminal environments.

## Quick Start

```bash
# Get help
caddie cli:help

# Basic color output
caddie cli:red "Error message"
caddie cli:green "Success message"
caddie cli:yellow "Warning message"

# Bold text
caddie cli:red:bold "Critical error"
caddie cli:blue:bold "Important notice"

# Utility functions
caddie cli:title "Section Header"
caddie cli:usage "command [options]"
caddie cli:colorlist
```

## Color Commands

### Basic Colors

All basic color commands follow the pattern `cli:<color> <text>`:

```bash
caddie cli:red "This text is red"
caddie cli:green "This text is green"
caddie cli:yellow "This text is yellow"
caddie cli:blue "This text is blue"
caddie cli:purple "This text is purple"
caddie cli:cyan "This text is cyan"
caddie cli:grey "This text is grey"
caddie cli:orange "This text is orange"
caddie cli:white "This text is white"
```

### Bold Colors

For bold text, use the `:bold` suffix:

```bash
caddie cli:red:bold "Bold red text"
caddie cli:green:bold "Bold green text"
caddie cli:yellow:bold "Bold yellow text"
caddie cli:blue:bold "Bold blue text"
caddie cli:purple:bold "Bold purple text"
caddie cli:cyan:bold "Bold cyan text"
caddie cli:grey:bold "Bold grey text"
caddie cli:orange:bold "Bold orange text"
caddie cli:white:bold "Bold white text"
```

## Utility Functions

### `cli:usage <text>`
Prints usage text in blue with bold formatting.

```bash
caddie cli:usage "caddie <module>:<command> [options]"
# Output: Usage: caddie <module>:<command> [options]
```

### `cli:installed`
Prints "installed" in blue with bold formatting.

```bash
caddie cli:installed
# Output: installed
```

### `cli:complete`
Prints "complete" in blue with bold formatting.

```bash
caddie cli:complete
# Output: complete
```

### `cli:title <text>`
Prints a title with green formatting and bold text.

```bash
caddie cli:title "Installation Complete"
# Output: == Installation Complete ==
```

### `cli:colorlist`
Lists all available colors with their actual color output.

```bash
caddie cli:colorlist
# Output: Shows each color name in its actual color
```

## UTF-8 Character Commands

The CLI module provides semantic UTF-8 character functions for consistent visual output:

### Status Indicators
```bash
caddie cli:check "Success message"           # ✓ with green text
caddie cli:x "Error message"                 # ✗ with red text
caddie cli:arrow "Progress message"          # → with yellow text
caddie cli:warning "Warning message"         # ⚠ with yellow text
```

### Section Headers (all with blue text)
```bash
caddie cli:folder "File operations"           # 📁
caddie cli:beer "Homebrew operations"        # 🍺
caddie cli:snake "Python operations"         # 🐍
caddie cli:crab "Rust operations"            # 🦀
caddie cli:trash "Cleanup/removal"           # 🗑️
caddie cli:rotate "Restore/refresh"          # 🔄
caddie cli:chart "Status/reports"            # 📊
caddie cli:magnify "Search/inspection"       # 🔍
caddie cli:save "Backup/save"                # 💾
caddie cli:wrench "Development tools"        # 🔧
caddie cli:whale "Docker operations"         # 🐳
caddie cli:package "Package management"      # 📦
caddie cli:git "Git operations"              # 🌐
caddie cli:rocket "Rails/launch operations"  # 🚀
caddie cli:thought "Tips/ideas"              # 💡
caddie cli:lightbulb "Tips/ideas"            # 💡
caddie cli:magnifying_glass "Search/utility" # 🔍
```

### Utility Functions
```bash
caddie cli:debug "Debug message"             # 🐛 with cyan text
caddie cli:blank                             # Empty line
```

## Use Cases

### Error Messages
```bash
caddie cli:red "Error: File not found"
caddie cli:red:bold "CRITICAL: Database connection failed"
```

### Success Messages
```bash
caddie cli:green "✓ Installation completed successfully"
caddie cli:green:bold "SUCCESS: All tests passed"
```

### Warnings
```bash
caddie cli:yellow "Warning: Deprecated feature used"
caddie cli:orange "⚠️  Please update your configuration"
```

### Information
```bash
caddie cli:blue "Info: Processing 150 files..."
caddie cli:cyan "Debug: Function called with args: $@"
```

### Headers and Titles
```bash
caddie cli:title "Caddie.sh Installation"
caddie cli:purple:bold "MODULE: Python Environment Setup"
```

## Integration Examples

### In Scripts
```bash
#!/bin/bash
source ~/.caddie_cli

# Show progress
caddie cli:blue "Starting installation..."
caddie cli:green "✓ Dependencies installed"
caddie cli:yellow "⚠️  Some optional packages failed"
caddie cli:title "Installation Summary"
```

### In Module Functions
```bash
function caddie_python_install() {
    caddie cli:blue "Installing Python packages..."
    
    if pip install -r requirements.txt; then
        caddie cli:green "✓ Packages installed successfully"
    else
        caddie cli:red "✗ Package installation failed"
        return 1
    fi
}
```

## Color Reference

| Color | Code | Use Case |
|-------|------|----------|
| Red | `cli:red` | Errors, failures, critical issues |
| Green | `cli:green` | Success, completion, positive results |
| Yellow | `cli:yellow` | Warnings, cautions, deprecated features |
| Blue | `cli:blue` | Information, progress, status |
| Purple | `cli:purple` | Headers, module names, special notices |
| Cyan | `cli:cyan` | Debug info, technical details |
| Grey | `cli:grey` | Secondary information, muted text |
| Orange | `cli:orange` | Important warnings, attention needed |
| White | `cli:white` | Default text, normal output |

### UTF-8 Character Functions

| Function | Emoji | Use Case |
|----------|-------|----------|
| `cli:check` | ✓ | Success messages, completed tasks |
| `cli:x` | ✗ | Error messages, failed operations |
| `cli:arrow` | → | Progress indicators, next steps |
| `cli:warning` | ⚠ | Warning messages, cautions |
| `cli:folder` | 📁 | File operations, directory management |
| `cli:beer` | 🍺 | Homebrew operations |
| `cli:snake` | 🐍 | Python operations |
| `cli:crab` | 🦀 | Rust operations |
| `cli:trash` | 🗑️ | Cleanup, removal operations |
| `cli:rotate` | 🔄 | Restore, refresh operations |
| `cli:chart` | 📊 | Status reports, analytics |
| `cli:magnify` | 🔍 | Search, inspection operations |
| `cli:save` | 💾 | Backup, save operations |
| `cli:wrench` | 🔧 | Development tools, utilities |
| `cli:whale` | 🐳 | Docker operations |
| `cli:package` | 📦 | Package management |
| `cli:git` | 🌐 | Git operations |
| `cli:rocket` | 🚀 | Rails, launch operations |
| `cli:thought` | 💡 | Tips, ideas, suggestions |
| `cli:lightbulb` | 💡 | Tips, ideas, suggestions |
| `cli:magnifying_glass` | 🔍 | Search, utility functions |
| `cli:debug` | 🐛 | Debug messages |
| `cli:blank` | - | Empty line output |

## Technical Details

### Color Implementation
- Uses `tput` for reliable color definitions
- Automatically handles color reset after each output
- Compatible with most terminal emulators
- Gracefully degrades on terminals without color support

### Function Naming Convention
All CLI functions follow the `caddie_cli_<command>` naming convention:
- `caddie_cli_red()` → `caddie cli:red`
- `caddie_cli_red_bold()` → `caddie cli:red:bold`
- `caddie_cli_title()` → `caddie cli:title`

### Export and Availability
All functions are exported and available throughout the Caddie.sh system:
```bash
export -f caddie_cli_red caddie_cli_green caddie_cli_yellow # ... etc
```

## Troubleshooting

### Colors Not Displaying
If colors aren't showing:
1. Check if your terminal supports colors: `caddie cli:colorlist`
2. Verify `tput` is available: `which tput`
3. Check terminal color settings

### Function Not Found
If CLI functions aren't available:
```bash
# Check if module is loaded
ls ~/.caddie_modules/.caddie_cli

# Manually source the module
source ~/.caddie_modules/.caddie_cli

# Check function availability
declare -f caddie_cli_red
```

## Best Practices

1. **Consistent Color Usage**: Use the same colors for similar types of messages across your modules
2. **Accessibility**: Don't rely solely on color - include text indicators like ✓, ✗, ⚠️
3. **Readability**: Use bold sparingly for emphasis only
4. **Integration**: Use CLI functions in your module output for consistent styling

## Related Modules

- **[Core Module](core.md)** - Basic caddie functions and debug system
- **[Git Module](git.md)** - Enhanced git workflows (uses CLI for status output)
- **[Python Module](python.md)** - Python environment management (uses CLI for installation feedback)
- **[Rust Module](rust.md)** - Rust development tools (uses CLI for build output)
