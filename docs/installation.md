# Installation Guide

This guide covers installation on macOS and Debian-based Linux.

## Prerequisites

### System Requirements

- **Operating System**: macOS 10.15 (Catalina) or later recommended; Debian-based Linux supported via OS-aware installer
- **Architecture**: Intel (x86_64) or Apple Silicon (ARM64)
- **Shell**: Bash 4.0 or later (latest version recommended)
- **Package Manager**: Homebrew on macOS (installed automatically if missing), apt on Debian

### Pre-Installation Checklist

- [ ] Ensure you have administrator privileges
- [ ] Check that you're using Bash (not Zsh as default)
- [ ] Verify you have at least 100MB of free disk space
- [ ] Ensure you have a stable internet connection

### macOS Terminal Configuration

**Important**: If you're using the macOS Terminal app and want Homebrew Bash, configure it after Homebrew is installed. You can verify it is available by running `bash --version` and checking for version 4+.

1. **Open Terminal Preferences**: Press `Cmd + ,` or go to Terminal → Preferences
2. **Select the Profiles Tab**: Click on the "Profiles" tab
3. **Choose Your Profile**: Select your active profile (e.g., "IR_Black")
4. **Go to Shell Tab**: Click on the "Shell" sub-tab
5. **Configure Startup Command**: 
   - Check "Run command:"
   - Enter: `/opt/homebrew/bin/bash --login`
   - **Do NOT check "Run inside shell"**

![Terminal Profile Configuration](terminal-profile-config.png)

This ensures you're using the latest Bash version with full `mapfile` support, which is required for Caddie.sh's tab completion functionality.

## Installation Methods

### Method 1: Quick Install (Recommended)

The fastest way to get started with Caddie.sh:

```bash
# Clone the repository
git clone https://github.com/parnotfar/caddie.sh.git
cd caddie.sh

# Run the full installer
make install
```

This will:
- Install all required dependencies (Homebrew, Python, Rust, Ruby build dependencies)
- Set up your shell environment
- Install all Caddie.sh modules
- Configure your system for development
- Install Ruby build dependencies (OpenSSL, readline, libyaml, etc.) for compiling Ruby
- Enable cross-platform Rust development for iOS, WatchOS, and Android

### Debian Install (Explicit)

If you want to run the Debian flow explicitly:

```bash
git clone https://github.com/parnotfar/caddie.sh.git
cd caddie.sh
make install-debian
```

The Debian install:
- Detects Debian-based systems
- Installs Debian-appropriate modules
- Uses `apt-get` to install baseline dependencies
 - Uses `modules/manifests/debian.txt` to determine which modules are installed

### Method 2: Minimal Install

If you only want the core Caddie.sh functionality without development tools:

```bash
# Clone and install dot files only
git clone https://github.com/parnotfar/caddie.sh.git
cd caddie.sh
make install-dot
```

For Debian-only minimal install:

```bash
make install-dot-debian
```

### Method 3: Development Tools Only

If you already have Caddie.sh installed but want to add development tools:

```bash
cd caddie.sh
make setup-dev
```

For Debian explicitly:

```bash
make setup-dev-debian
```

## Installation Process

### Step 1: Clone the Repository

```bash
git clone https://github.com/parnotfar/caddie.sh.git
cd caddie.sh
```

**Repository Structure**: The project is organized with core system files in the root directory and all module files (including core functions) in the `modules/` subdirectory for better maintainability.

### Step 2: Run the Installer

```bash
make install
```

The installer will:

1. **Check Prerequisites**: Verify your system meets requirements
2. **Backup Existing Files**: Create backups of your current shell configuration
3. **Install Dependencies**: Set up Homebrew, Python, and Rust
4. **Install Caddie.sh**: Copy all necessary files to your home directory
5. **Configure Shell**: Update your bash profile and bashrc
6. **Verify Installation**: Test that everything is working correctly
7. **Setup Cross-Platform Development**: Configure Rust for iOS, WatchOS, and Android

### Step 3: Activate the Environment

After installation, you need to activate the new environment:

```bash
# Option 1: Use caddie reload command (recommended)
caddie reload
```

### Step 4: Verify Installation

```bash
# Check Caddie.sh version
caddie --version

# Get help
caddie help

# Test a module
caddie python:create test-env
```

## Post-Installation Setup

### First-Time Configuration

1. **Set Project Home Directory** (Optional):
   ```bash
   caddie core:set:home ~/projects
   caddie go:home
   ```

2. **Enable Debug Mode** (Optional):
   ```bash
   caddie core:debug on
   ```

3. **Customize Shell Prompt** (Optional):
   ```bash
   # Edit the prompt file
   nano ~/.caddie_prompt.sh
   ```

4. **Setup iOS Distribution Config** (Optional):
   ```bash
   # Store App Store Connect credentials
   caddie ios:config:set apple-id 'your@apple.id'
   caddie ios:config:set password 'xxxx-xxxx-xxxx-xxxx'
   ```

5. **Setup Rust Git Integration** (Recommended):
   ```bash
   # Create new Rust project with proper .gitignore
   caddie rust:init myproject
   
   # Or add .gitignore to existing project
   caddie rust:gitignore
   
   # Check for build artifacts in git
   caddie rust:git:status
   ```

### Environment Variables

The installer sets up these environment variables:

- `CADDIE_HOME`: Your project directory (if set)
- `CADDIE_DEBUG`: Debug mode flag (0 or 1)
- `CADDIE_MODULES_DIR`: Modules directory location

## Troubleshooting

### Common Issues

#### Issue: "Command not found: caddie"

**Solution**: The shell profile hasn't been sourced. Run:
```bash
source ~/.bash_profile
```

**Alternative**: Use the reload command:
```bash
caddie reload
```

#### Issue: "Permission denied" during installation

**Solution**: Ensure you have write permissions to your home directory:
```bash
ls -la ~/
```

#### Issue: Homebrew installation fails

**Solution**: Install Homebrew manually first:
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

#### Issue: Python/Rust installation fails

**Solution**: Check your internet connection and try again:
```bash
make setup-dev
```

### Debug Mode

If you're experiencing issues, enable debug mode:

```bash
caddie core:debug on
# Then run the failing command to see detailed output
```

### Logs and Diagnostics

Check these files for troubleshooting information:

- `~/.caddie_debug`: Debug configuration
- `~/.bash_profile.caddie-backup`: Your original bash profile
- `~/.bashrc.caddie-backup`: Your original bashrc

## Uninstallation

### Complete Removal

To completely remove Caddie.sh:

```bash
cd caddie.sh
make uninstall
```

This will:
- Remove all Caddie.sh files
- Restore your original shell configuration
- Keep your development tools (Homebrew, Python, Rust)

### Partial Removal

To remove specific components:

```bash
# Remove only Caddie.sh (keep dev tools)
make install-dot
# Then manually remove ~/.caddie* files

# Remove only development tools
# Manually uninstall Homebrew, Python, Rust
```

## Updating

### Update Caddie.sh

```bash
cd caddie.sh
git pull origin main
make install-dot
```

### Update Development Tools

```bash
cd caddie.sh
make setup-dev
```

## Advanced Configuration

### Custom Installation Directory

To install Caddie.sh to a custom location:

```bash
# Set custom home directory
export HOME_DIR=/custom/path
make install
```

### Module Selection

To install only specific modules:

```bash
# Install core and Python only
make install-dot
# Then manually copy desired module files
```

### Network Configuration

If you're behind a corporate firewall:

```bash
# Set proxy for Homebrew
export http_proxy=http://proxy.company.com:8080
export https_proxy=http://proxy.company.com:8080
make install
```

## Troubleshooting

### Common Issues

#### Tab Completion Not Working

If tab completion shows a bell sound or doesn't work:

1. **Verify Bash Version**: Run `bash --version` - you should see version 5.0 or later
2. **Check Terminal Configuration**: Ensure your Terminal app is configured to use `/opt/homebrew/bin/bash --login`
3. **Verify PATH**: Run `which bash` - should show `/opt/homebrew/bin/bash`
4. **Restart Terminal**: After configuration changes, restart your terminal completely

#### "mapfile: command not found" Error

This indicates you're using an older version of Bash:

```bash
# Check current bash version
bash --version

# If it shows version 3.x or 4.x, you need to configure Terminal
# Follow the macOS Terminal Configuration steps above
```

#### Module Commands Not Found

If `caddie python:help` returns "Unknown command":

1. **Check Installation**: Verify `~/.caddie_modules/` directory exists
2. **Verify Sourcing**: Check that `~/.bash_profile` sources `~/.caddie.sh`
3. **Reload Environment**: Run `source ~/.bash_profile`
4. **Use Reload Command**: Try `caddie reload` for quick environment refresh

## Support

If you encounter issues not covered in this guide:

1. **Check the [Troubleshooting Guide](troubleshooting.md)**
2. **Search [GitHub Issues](https://github.com/parnotfar/caddie.sh/issues)**
3. **Create a new issue** with detailed information
4. **Join our [Discussions](https://github.com/parnotfar/caddie.sh/discussions)**

## Next Steps

After successful installation:

1. **Read the [User Guide](user-guide.md)** to learn how to use Caddie.sh
2. **Explore [Module Documentation](modules/)** for detailed feature information
3. **Check [Configuration](configuration.md)** for customization options
4. **Join the community** and share your experience!

---

*Happy coding with Caddie.sh! 🏌️‍♂️*
