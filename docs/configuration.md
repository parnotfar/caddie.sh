# Configuration Guide

This guide covers all the ways to customize and configure Caddie.sh to match your preferences and workflow.

## Overview

Caddie.sh is designed to be highly configurable while maintaining sensible defaults. You can customize:

- **Environment Variables**: Debug settings, paths, and preferences
- **Module Behavior**: Language-specific configurations
- **Shell Integration**: Bash profile and bashrc customization
- **Shell Prompt**: Basic customization (advanced features planned)

## Shell Prompt (Future Feature)

> **Note**: Advanced prompt customization is planned for future releases. Currently, Caddie.sh provides a basic informative prompt that shows essential development information.

### Current Prompt Features

The current prompt automatically displays:
- Current directory
- Git branch and status (when in a git repository)
- Python virtual environment (when active)
- Basic system information

### Future Customization Options

In upcoming releases, you'll be able to:
- Customize colors and formatting
- Choose which information to display
- Create custom prompt layouts
- Save and share prompt configurations

### Current Customization

For now, you can make basic changes by editing `~/.caddie_prompt.sh`, but this is considered a developer detail and may change in future versions.

## Environment Variables

### Core Variables

#### `CADDIE_DEBUG`
**Purpose**: Control debug output throughout Caddie.sh
**Values**: `0` (off) or `1` (on)
**Default**: `0`

**Set via command:**
```bash
caddie core:debug on
caddie core:debug off
```

**Set manually:**
```bash
export CADDIE_DEBUG=1
```

#### `CADDIE_HOME`
**Purpose**: Your project home directory
**Default**: Not set
**Set via command:**
```bash
caddie core:set:home ~/projects
```

**Set manually:**
```bash
export CADDIE_HOME="$HOME/projects"
```

#### `CADDIE_MODULES_DIR`
**Purpose**: Directory containing Caddie.sh modules
**Default**: `~/.caddie_modules`
**Set manually:**
```bash
export CADDIE_MODULES_DIR="$HOME/.custom_modules"
```

### Custom Variables

You can define custom environment variables for your workflow:

```bash
# Add to ~/.bash_profile or ~/.bashrc
export CADDIE_EDITOR="code"                    # Preferred editor
export CADDIE_BROWSER="open -a 'Google Chrome'" # Preferred browser
export CADDIE_TERMINAL="iTerm2"                # Terminal preference
export CADDIE_THEME="dark"                     # UI theme preference
```

### Variable Persistence

To make environment variables persistent across sessions:

1. **Add to ~/.bash_profile** (recommended for login shells):
   ```bash
   echo 'export CADDIE_DEBUG=1' >> ~/.bash_profile
   echo 'export CADDIE_HOME="$HOME/projects"' >> ~/.bash_profile
   ```

2. **Add to ~/.bashrc** (for interactive non-login shells):
   ```bash
   echo 'export CADDIE_DEBUG=1' >> ~/.bashrc
   ```

3. **Source the file:**
   ```bash
   source ~/.bash_profile
   # or
   source ~/.bashrc
   ```

## Module-Specific Configuration

### Python Configuration

#### Virtual Environment Location
```bash
# Custom virtual environment directory
export WORKON_HOME="$HOME/.venvs"
export VIRTUALENVWRAPPER_HOOK_DIR="$HOME/.virtualenvs"

# Add to your ~/.bash_profile
echo 'export WORKON_HOME="$HOME/.venvs"' >> ~/.bash_profile
```

#### Python Version Management
```bash
# Set default Python version
export PYTHON_VERSION="3.11"

# Set Python path
export PYTHONPATH="${PYTHONPATH}:$HOME/projects"

# Add to your ~/.bash_profile
echo 'export PYTHON_VERSION="3.11"' >> ~/.bash_profile
echo 'export PYTHONPATH="${PYTHONPATH}:$HOME/projects"' >> ~/.bash_profile
```

### Rust Configuration

#### Cargo Configuration
```bash
# Custom cargo home
export CARGO_HOME="$HOME/.cargo"

# Custom target directory
export CARGO_TARGET_DIR="$HOME/.cargo/target"

# Add to your ~/.bash_profile
echo 'export CARGO_HOME="$HOME/.cargo"' >> ~/.bash_profile
echo 'export CARGO_TARGET_DIR="$HOME/.cargo/target"' >> ~/.bash_profile
```

#### Rustup Configuration
```bash
# Set default toolchain
export RUSTUP_TOOLCHAIN="stable"

# Add to your ~/.bash_profile
echo 'export RUSTUP_TOOLCHAIN="stable"' >> ~/.bash_profile
```

### Ruby Configuration

#### RVM Configuration
```bash
# Custom gems directory
export GEM_HOME="$HOME/.gems"
export GEM_PATH="$HOME/.gems:$GEM_HOME"

# Add to your ~/.bash_profile
echo 'export GEM_HOME="$HOME/.gems"' >> ~/.bash_profile
echo 'export GEM_PATH="$HOME/.gems:$GEM_HOME"' >> ~/.bash_profile
```

#### Ruby Version
```bash
# Pin a specific Ruby version for caddie ruby:setup
export CADDIE_RUBY_VERSION="3.2.2"

# Add to your ~/.bash_profile
echo 'export CADDIE_RUBY_VERSION="3.2.2"' >> ~/.bash_profile
```

**Note**: If `CADDIE_RUBY_VERSION` is not set, `caddie ruby:setup` will automatically detect and install the latest stable Ruby version available via RVM.

### JavaScript/Node.js Configuration

#### NVM Configuration
```bash
# Custom node version
export NVM_DEFAULT_VERSION="18.16.0"

# Custom node path
export NVM_DIR="$HOME/.nvm"

# Add to your ~/.bash_profile
echo 'export NVM_DEFAULT_VERSION="18.16.0"' >> ~/.bash_profile
echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.bash_profile
```

#### npm Configuration
```bash
# Custom npm prefix
export npm_config_prefix="$HOME/.npm-global"

# Add to your ~/.bash_profile
echo 'export npm_config_prefix="$HOME/.npm-global"' >> ~/.bash_profile
```

## Shell Integration

### Bash Profile Customization

The installer creates a `~/.bash_profile` that sources Caddie.sh. You can customize this file:

```bash
# Edit your bash profile
nano ~/.bash_profile
```

#### Adding Custom Aliases
```bash
# Add to ~/.bash_profile
alias ll='ls -la'
alias la='ls -A'
alias l='ls -CF'

# Caddie.sh specific aliases
alias c='caddie'
alias cp='caddie python:create'
alias ca='caddie python:activate'
alias cr='caddie rust:new'
alias cj='caddie js:install'
```

> 💡 **Built-in Aliases**: Caddie.sh comes with 50+ productivity aliases already configured! Use `caddie core:aliases` to see them all, `ag <keyword>` to search them, and `caddie go:home` to navigate to your caddie home directory.

#### Adding Custom Functions
```bash
# Add to ~/.bash_profile
function caddie_quick_setup() {
    local project_name="$1"
    local language="$2"
    
    case "$language" in
        "python")
            caddie python:create "$project_name"
            caddie python:activate "$project_name"
            caddie python:init
            ;;
        "rust")
            caddie rust:new "$project_name"
            ;;
        "js")
            caddie js:new "$project_name"
            ;;
        *)
            echo "Unknown language: $language"
            return 1
            ;;
    esac
}
```

### Bashrc Customization

For interactive shell customizations, edit `~/.bashrc`:

```bash
# Edit your bashrc
nano ~/.bashrc
```

#### Interactive Features
```bash
# Add to ~/.bashrc
# Enable bash completion
if [ -f /usr/local/etc/bash_completion ]; then
    source /usr/local/etc/bash_completion
fi

# Enable git completion
if [ -f /usr/local/etc/bash_completion.d/git-completion.bash ]; then
    source /usr/local/etc/bash_completion.d/git-completion.bash
fi

# Custom prompt for interactive shells
if [ -n "$PS1" ]; then
    PS1='\[\033[1;32m\]\u@\h\[\033[0m\]:\[\033[1;34m\]\w\[\033[0m\]\$ '
fi
```

## Advanced Configuration

### Conditional Configuration

You can make configurations conditional based on your environment:

```bash
# Add to ~/.bash_profile
# Development machine configuration
if [ "$(hostname)" = "dev-machine.local" ]; then
    export CADDIE_DEBUG=1
    export CADDIE_HOME="$HOME/development"
    export CADDIE_EDITOR="vim"
fi

# Production machine configuration
if [ "$(hostname)" = "prod-server.local" ]; then
    export CADDIE_DEBUG=0
    export CADDIE_HOME="/opt/projects"
    export CADDIE_EDITOR="nano"
fi

# Personal machine configuration
if [ "$(hostname)" = "personal-mac.local" ]; then
    export CADDIE_DEBUG=0
    export CADDIE_HOME="$HOME/personal-projects"
    export CADDIE_EDITOR="code"
fi
```

### Machine-Specific Configuration

Create machine-specific configuration files:

```bash
# Create machine-specific config
cat > ~/.caddie_machine_config << 'EOF'
# Machine-specific Caddie.sh configuration
export CADDIE_MACHINE_NAME="$(hostname)"
export CADDIE_MACHINE_TYPE="$(uname -s)"

# Load machine-specific settings
case "$CADDIE_MACHINE_NAME" in
    "work-laptop")
        export CADDIE_DEBUG=0
        export CADDIE_HOME="$HOME/work-projects"
        ;;
    "home-desktop")
        export CADDIE_DEBUG=1
        export CADDIE_HOME="$HOME/hobby-projects"
        ;;
    *)
        export CADDIE_DEBUG=0
        export CADDIE_HOME="$HOME/projects"
        ;;
esac
EOF

# Source it in your bash profile
echo 'source ~/.caddie_machine_config' >> ~/.bash_profile
```

### Project-Specific Configuration

Create project-specific configurations:

```bash
# Create project config function
function caddie_project_config() {
    local project_path="$1"
    
    if [ -f "$project_path/.caddie_project" ]; then
        source "$project_path/.caddie_project"
        echo "Loaded project configuration for: $(basename "$project_path")"
    fi
}

# Add to your bash profile
echo 'function caddie_project_config() { ... }' >> ~/.bash_profile

# Use in your prompt or when changing directories
cd() {
    builtin cd "$@"
    caddie_project_config "$(pwd)"
}
```

## Configuration Files

### File Locations

| File | Purpose | Editable |
|------|---------|----------|
| `~/.caddie_prompt.sh` | Shell prompt customization | ✅ Yes |
| `~/.bash_profile` | Login shell configuration | ✅ Yes |
| `~/.bashrc` | Interactive shell configuration | ✅ Yes |
| `~/.caddie_debug` | Debug system configuration | ❌ No (use commands) |
| `~/.caddie_home` | Home directory setting | ❌ No (use commands) |
| `~/.caddie_data/` | Data structure files | ❌ No (managed by Caddie.sh) |

### File Permissions

Ensure proper file permissions:

```bash
# Set correct permissions
chmod 644 ~/.caddie_prompt.sh
chmod 644 ~/.bash_profile
chmod 644 ~/.bashrc
chmod 644 ~/.caddie_home

# Make sure files are readable
ls -la ~/.caddie*
ls -la ~/.bash*
```

## Best Practices

### Configuration Organization

1. **Keep it simple**: Don't over-configure; start with defaults
2. **Document changes**: Comment your customizations
3. **Version control**: Keep configuration in version control
4. **Test changes**: Test configurations in new shell sessions

### Environment Variables

1. **Use descriptive names**: Make variable names clear
2. **Set defaults**: Always provide sensible defaults
3. **Check before use**: Validate variables before using them
4. **Group related variables**: Keep related settings together

### Shell Integration

1. **Profile vs bashrc**: Use profile for login shells, bashrc for interactive
2. **Source order**: Be mindful of sourcing order
3. **Error handling**: Handle missing files gracefully
4. **Performance**: Keep profile loading fast

### Module Configuration

1. **Language-specific**: Configure each language module separately
2. **Tool integration**: Integrate with existing tools
3. **Path management**: Use consistent path structures
4. **Version control**: Version your configurations

## Troubleshooting

### Common Issues

#### Configuration Not Loading
```bash
# Check if files are sourced
echo $CADDIE_DEBUG
echo $CADDIE_HOME

# Check file permissions
ls -la ~/.caddie*
ls -la ~/.bash*
```

#### Prompt Not Updating
```bash
# Reload prompt
source ~/.caddie_prompt.sh

# Check for syntax errors
bash -n ~/.caddie_prompt.sh
```

#### Environment Variables Not Set
```bash
# Check if profile is sourced
echo $SHELL
echo $0

# Source manually
source ~/.bash_profile
```

### Debug Configuration

Enable debug mode to troubleshoot configuration issues:

```bash
# Enable debug
caddie core:debug on

# Check what's happening
caddie help

# Disable debug
caddie core:debug off
```

### Configuration Validation

Create a configuration validation script:

```bash
#!/bin/bash
# validate-config.sh

echo "Caddie.sh Configuration Validation"
echo "=================================="

# Check core variables
echo "Core Configuration:"
echo "  CADDIE_DEBUG: ${CADDIE_DEBUG:-not set}"
echo "  CADDIE_HOME: ${CADDIE_HOME:-not set}"
echo "  CADDIE_MODULES_DIR: ${CADDIE_MODULES_DIR:-not set}"

# Check file existence
echo -e "\nConfiguration Files:"
echo "  ~/.caddie_prompt.sh: $([ -f ~/.caddie_prompt.sh ] && echo "✓" || echo "✗")"
echo "  ~/.bash_profile: $([ -f ~/.bash_profile ] && echo "✓" || echo "✗")"
echo "  ~/.bashrc: $([ -f ~/.bashrc ] && echo "✓" || echo "✗")"

# Check function availability
echo -e "\nCore Functions:"
echo "  caddie_debug: $(type caddie_debug >/dev/null 2>&1 && echo "✓" || echo "✗")"
echo "  caddie: $(type caddie >/dev/null 2>&1 && echo "✓" || echo "✗")"

echo -e "\nValidation complete!"
```

## Examples

### Complete Configuration Example

```bash
# ~/.caddie_complete_config
# Complete Caddie.sh configuration example

# Core settings
export CADDIE_DEBUG=0
export CADDIE_HOME="$HOME/Development"
export CADDIE_EDITOR="code"
export CADDIE_BROWSER="open -a 'Google Chrome'"

# Python configuration
export WORKON_HOME="$HOME/.virtualenvs"
export PYTHON_VERSION="3.11"
export PYTHONPATH="${PYTHONPATH}:$HOME/Development"

# Rust configuration
export CARGO_HOME="$HOME/.cargo"
export RUSTUP_TOOLCHAIN="stable"

# Ruby configuration
export GEM_HOME="$HOME/.gems"
export RUBY_VERSION="3.2.0"

# Node.js configuration
export NVM_DEFAULT_VERSION="18.16.0"
export npm_config_prefix="$HOME/.npm-global"

# Custom aliases
alias c='caddie'
alias cp='caddie python:create'
alias ca='caddie python:activate'
alias cr='caddie rust:new'

# Custom functions
function caddie_project_setup() {
    local project_name="$1"
    local language="$2"
    
    case "$language" in
        "python")
            caddie python:create "$project_name"
            caddie python:activate "$project_name"
            caddie python:init
            ;;
        "rust")
            caddie rust:new "$project_name"
            ;;
        *)
            echo "Unknown language: $language"
            return 1
            ;;
    esac
}
```

### Minimal Configuration Example

```bash
# ~/.caddie_minimal_config
# Minimal Caddie.sh configuration

# Only essential settings
export CADDIE_DEBUG=0
export CADDIE_HOME="$HOME/projects"

# Basic aliases
alias c='caddie'
```

## Related Documentation

- **[Installation Guide](installation.md)** - How to install Caddie.sh
- **[User Guide](user-guide.md)** - How to use Caddie.sh
- **[Module Documentation](modules/)** - Detailed module information
- **[Troubleshooting Guide](troubleshooting.md)** - Common issues and solutions

---

*Configuration is the key to making Caddie.sh work exactly the way you want. Start with the defaults and customize gradually to build your perfect development environment.*
