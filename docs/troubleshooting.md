# Troubleshooting Guide

This guide helps you resolve common issues with Caddie.sh. If you encounter a problem not covered here, please check the [GitHub Issues](https://github.com/parnotfar/caddie.sh/issues) or create a new one.

## Quick Diagnosis

### Enable Debug Mode

First, enable debug mode to see what's happening:

```bash
caddie core:debug on
# Navigate to caddie home if needed
caddie go:home
# Run the failing command
caddie help
# Check debug output
caddie core:debug off
```

### Check Installation Status

Verify your installation:

```bash
# Check if Caddie.sh is available
which caddie

# Check version
caddie --version

# Check help
caddie help

# Check debug status
caddie core:debug status
```

## Common Issues

### Command Not Found

#### Issue: `caddie: command not found`

**Symptoms:**
- Terminal shows "command not found" when running `caddie`
- `which caddie` returns nothing

**Causes:**
1. Caddie.sh not installed
2. Shell profile not sourced
3. PATH not updated
4. Installation failed

**Solutions:**

1. **Check if Caddie.sh is installed:**
   ```bash
   ls -la ~/.caddie.sh
   ls -la ~/.caddie_modules/
   ```

2. **Source your shell profile:**
   ```bash
   source ~/.bash_profile
   # or
   source ~/.bashrc
   ```

3. **Reinstall if missing:**
   ```bash
   cd /path/to/caddie.sh
   make install-dot
   source ~/.bash_profile
   ```

4. **Check PATH:**
   ```bash
   echo $PATH
   # Should include ~/.caddie_modules
   ```

#### Issue: `caddie_debug: command not found`

**Symptoms:**
- Debug functions not available
- Error when trying to use debug commands

**Solutions:**

1. **Check debug file:**
   ```bash
   ls -la ~/.caddie_debug
   cat ~/.caddie_debug
   ```

2. **Source debug file directly:**
   ```bash
   source ~/.caddie_debug
   caddie_debug "test"
   ```

3. **Reinstall debug system:**
   ```bash
   cd /path/to/caddie.sh
   make install-dot
   source ~/.bash_profile
   ```

### Installation Issues

#### Issue: Makefile installation fails

**Symptoms:**
- `make install` fails with errors
- Files not copied to home directory
- Permission denied errors

**Solutions:**

1. **Check permissions:**
   ```bash
   ls -la ~/
   chmod 755 ~/
   ```

2. **Check disk space:**
   ```bash
   df -h ~/
   ```

3. **Check internet connection:**
   ```bash
   ping -c 3 google.com
   ```

4. **Install step by step:**
   ```bash
   make check-prerequisites
   make backup-existing
   make install-dot
   make setup-dev
   ```

#### Issue: Homebrew installation fails

**Symptoms:**
- Homebrew installation hangs or fails
- Network timeout errors
- Permission issues

**Solutions:**

1. **Check system requirements:**
   ```bash
   uname -s
   sw_vers -productVersion
   ```

2. **Install Homebrew manually:**
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

3. **Check network configuration:**
   ```bash
   # If behind corporate firewall
   export http_proxy=http://proxy.company.com:8080
   export https_proxy=http://proxy.company.com:8080
   ```

4. **Use alternative installation:**
   ```bash
   # Download and install manually
   curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C /usr/local
   ```

### Module Loading Issues

#### Issue: Modules not loading

**Symptoms:**
- `caddie help` shows no modules
- Module commands not available
- Empty module list

**Solutions:**

1. **Check modules directory:**
   ```bash
   ls -la ~/.caddie_modules/
   echo $CADDIE_MODULES_DIR
   ```

2. **Check module files:**
   ```bash
   find ~/.caddie_modules -name ".caddie_*" -type f
   ```

3. **Check file permissions:**
   ```bash
   find ~/.caddie_modules -name ".caddie_*" -exec ls -la {} \;
   ```

4. **Reinstall modules:**
   ```bash
   cd /path/to/caddie.sh
   make install-dot
   source ~/.bash_profile
   ```

#### Issue: Specific module not working

**Symptoms:**
- One module works, others don't
- Module-specific errors
- Function not found errors

**Solutions:**

1. **Check module file:**
   ```bash
   cat ~/.caddie_modules/.caddie_python
   # Look for syntax errors
   ```

2. **Test module directly:**
   ```bash
   source ~/.caddie_modules/.caddie_python
   caddie_python_help
   ```

3. **Check dependencies:**
   ```bash
   # For Python module
   python3 --version
   pip3 --version
   
   # For Rust module
   rustc --version
   cargo --version
   ```

4. **Reinstall specific module:**
   ```bash
   cp dot_caddie_python ~/.caddie_modules/.caddie_python
   source ~/.bash_profile
   ```

### Environment Issues

#### Issue: Virtual environments not working

**Symptoms:**
- Python virtual environment creation fails
- Environment activation doesn't work
- PATH not updated correctly

**Solutions:**

1. **Check Python installation:**
   ```bash
   python3 --version
   which python3
   ```

2. **Check venv module:**
   ```bash
   python3 -m venv --help
   ```

3. **Check permissions:**
   ```bash
   ls -la ~/.virtualenvs/
   mkdir -p ~/.virtualenvs
   chmod 755 ~/.virtualenvs
   ```

4. **Create environment manually:**
   ```bash
   python3 -m venv ~/.virtualenvs/test
   source ~/.virtualenvs/test/bin/activate
   ```

#### Issue: Environment variables not set

**Symptoms:**
- `$CADDIE_HOME` not set
- `$CADDIE_DEBUG` not working
- Custom variables not persisting

**Solutions:**

1. **Check shell profile:**
   ```bash
   cat ~/.bash_profile
   cat ~/.bashrc
   ```

2. **Set variables manually:**
   ```bash
   export CADDIE_DEBUG=1
   export CADDIE_HOME="$HOME/projects"
   ```

3. **Add to profile:**
   ```bash
   echo 'export CADDIE_DEBUG=1' >> ~/.bash_profile
   echo 'export CADDIE_HOME="$HOME/projects"' >> ~/.bash_profile
   source ~/.bash_profile
   ```

4. **Check shell type:**
   ```bash
   echo $SHELL
   echo $0
   # Should show bash, not zsh
   ```

### Shell Integration Issues

#### Issue: Prompt not updating

**Symptoms:**
- Shell prompt unchanged after installation
- Custom prompt not loading
- Prompt configuration ignored

**Solutions:**

1. **Check prompt file:**
   ```bash
   ls -la ~/.caddie_prompt.sh
   cat ~/.caddie_prompt.sh
   ```

2. **Source prompt manually:**
   ```bash
   source ~/.caddie_prompt.sh
   ```

3. **Check for syntax errors:**
   ```bash
   bash -n ~/.caddie_prompt.sh
   ```

4. **Restart terminal:**
   ```bash
   # Close and reopen terminal
   # Or source profile
   source ~/.bash_profile
   ```

#### Issue: Bash profile not loading

**Symptoms:**
- Environment not set up on login
- Variables not persisting
- Functions not available

**Solutions:**

1. **Check profile file:**
   ```bash
   ls -la ~/.bash_profile
   cat ~/.bash_profile
   ```

2. **Check shell type:**
   ```bash
   echo $SHELL
   # Should be /bin/bash or /opt/homebrew/bin/bash
   ```

3. **Set default shell:**
   ```bash
   chsh -s /bin/bash
   # or
   chsh -s /opt/homebrew/bin/bash
   ```

4. **Check terminal settings:**
   - Ensure terminal is set to use bash
   - Check if using zsh instead of bash

### Performance Issues

#### Issue: Slow startup

**Symptoms:**
- Terminal takes long time to load
- Commands slow to respond
- High CPU usage during startup

**Solutions:**

1. **Check profile loading time:**
   ```bash
   time source ~/.bash_profile
   ```

2. **Profile startup:**
   ```bash
   bash -x ~/.bash_profile
   ```

3. **Check for slow operations:**
   ```bash
   # Look for network calls, file operations
   grep -r "curl\|wget\|find" ~/.caddie*
   ```

4. **Optimize profile:**
   ```bash
   # Move heavy operations to background
   # Use lazy loading for modules
   ```

#### Issue: High memory usage

**Symptoms:**
- High memory consumption
- Slow performance
- System becomes unresponsive

**Solutions:**

1. **Check memory usage:**
   ```bash
   ps aux | grep bash
   top
   ```

2. **Check for memory leaks:**
   ```bash
   # Look for large arrays or variables
   # Check for recursive functions
   ```

3. **Optimize data structures:**
   ```bash
   # Use more efficient data structures
   # Limit array sizes
   ```

### Network and Proxy Issues

#### Issue: Homebrew network errors

**Symptoms:**
- Homebrew update fails
- Package installation hangs
- Network timeout errors

**Solutions:**

1. **Check network connectivity:**
   ```bash
   ping -c 3 8.8.8.8
   nslookup brew.sh
   ```

2. **Set proxy if needed:**
   ```bash
   export http_proxy=http://proxy.company.com:8080
   export https_proxy=http://proxy.company.com:8080
   export all_proxy=socks5://proxy.company.com:1080
   ```

3. **Use alternative mirrors:**
   ```bash
   # Set Homebrew mirror
   git -C "$(brew --repo)" remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git
   ```

4. **Check firewall settings:**
   ```bash
   # Ensure ports 80, 443, 9418 are open
   # Check corporate firewall rules
   ```

#### Issue: Git network problems

**Symptoms:**
- Git clone fails
- Repository access denied
- SSL certificate errors

**Solutions:**

1. **Check git configuration:**
   ```bash
   git config --global --list
   git config --global http.sslVerify false  # Only if needed
   ```

2. **Set git proxy:**
   ```bash
   git config --global http.proxy http://proxy.company.com:8080
   git config --global https.proxy http://proxy.company.com:8080
   ```

3. **Use SSH instead of HTTPS:**
   ```bash
   git remote set-url origin git@github.com:username/repo.git
   ```

4. **Check SSH keys:**
   ```bash
   ls -la ~/.ssh/
   ssh-add ~/.ssh/id_rsa
   ```

## Advanced Troubleshooting

### Debug Mode Analysis

Enable debug mode and analyze output:

```bash
# Enable debug
caddie core:debug on

# Run problematic command
caddie help

# Analyze debug output
# Look for:
# - Missing files
# - Permission errors
# - Function not found errors
# - Module loading issues

# Disable debug
caddie core:debug off
```

### File System Analysis

Check file system integrity:

```bash
# Check file permissions
find ~/.caddie* -type f -exec ls -la {} \;

# Check file contents
head -20 ~/.caddie.sh
head -20 ~/.bash_profile

# Check for corruption
file ~/.caddie.sh
file ~/.bash_profile

# Check file sizes
ls -lh ~/.caddie*
ls -lh ~/.bash*
```

### Shell Environment Analysis

Analyze shell environment:

```bash
# Check environment variables
env | grep CADDIE
env | grep PATH

# Check function definitions
declare -f | grep caddie
type caddie
type caddie_debug

# Check aliases
alias | grep caddie

# Check shell options
set -o
```

### Performance Profiling

Profile startup performance:

```bash
# Time profile loading
time bash -c 'source ~/.bash_profile'

# Profile with strace (if available)
strace -o profile.log bash -c 'source ~/.bash_profile'

# Check for bottlenecks
grep -E "(open|stat|access)" profile.log | head -20
```

## Recovery Procedures

### Complete Reset

If all else fails, perform a complete reset:

```bash
# Backup current configuration
cp ~/.bash_profile ~/.bash_profile.backup
cp ~/.bashrc ~/.bashrc.backup

# Remove Caddie.sh files
rm -rf ~/.caddie*
rm -rf ~/.caddie_data
rm -rf ~/.caddie_modules

# Restore original configuration
cp ~/.bash_profile.caddie-backup ~/.bash_profile
cp ~/.bashrc.caddie-backup ~/.bashrc

# Restart terminal or source profile
source ~/.bash_profile
```

### Partial Reset

Reset specific components:

```bash
# Reset modules only
rm -rf ~/.caddie_modules
mkdir ~/.caddie_modules

# Reset configuration only
rm ~/.caddie_home
unset CADDIE_HOME

# Reset debug only
caddie core:debug off
```

### Reinstallation

Perform clean reinstallation:

```bash
# Remove current installation
cd /path/to/caddie.sh
make uninstall

# Clean any remaining files
rm -rf ~/.caddie*

# Reinstall
make install
```

## Getting Help

### Before Asking for Help

1. **Check this guide** for your specific issue
2. **Enable debug mode** and capture output
3. **Check system information**:
   ```bash
   uname -a
   sw_vers -productVersion
   bash --version
   echo $SHELL
   ```

4. **Document the issue**:
   - What you were trying to do
   - Exact error messages
   - Steps to reproduce
   - System information

### Where to Get Help

1. **GitHub Issues**: [Create an issue](https://github.com/parnotfar/caddie.sh/issues)
2. **GitHub Discussions**: [Start a discussion](https://github.com/parnotfar/caddie.sh/discussions)
3. **Documentation**: Check the [docs directory](../)
4. **Community**: Engage with other users

### Issue Template

When creating an issue, include:

```markdown
## Issue Description
Brief description of the problem

## Steps to Reproduce
1. Step 1
2. Step 2
3. Step 3

## Expected Behavior
What should happen

## Actual Behavior
What actually happens

## System Information
- macOS version: [e.g., 13.0]
- Bash version: [e.g., 5.2.15]
- Caddie.sh version: [e.g., 1.0.0]

## Debug Output
```
caddie core:debug on
# Run failing command
caddie core:debug off
```

## Additional Context
Any other relevant information
```

## Prevention

### Best Practices

1. **Regular backups**: Keep backups of your shell configuration
2. **Version control**: Use git for your dotfiles
3. **Testing**: Test changes in new terminal sessions
4. **Documentation**: Document custom configurations

### Maintenance

1. **Regular updates**: Keep Caddie.sh updated
2. **Cleanup**: Remove unused modules and environments
3. **Monitoring**: Watch for performance issues
4. **Validation**: Regularly validate your configuration

---

*Most issues can be resolved by following this guide. If you continue to have problems, the community is here to help!*
