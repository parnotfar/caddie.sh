# Rust Module

The Rust module provides comprehensive Rust development tools and project management capabilities, making Rust development effortless and consistent.

## Overview

The Rust module is designed to streamline Rust development workflows by providing:

- **Project Management**: Create, build, and manage Rust projects
- **Dependency Management**: Add, remove, and update Cargo dependencies
- **Toolchain Management**: Switch between Rust toolchains and targets
- **Development Tools**: Testing, checking, and code quality tools

## Commands

### Project Management

#### `caddie rust:new <name>`

Create a new Rust project.

**Arguments:**
- `name`: Name of the new Rust project

**Examples:**
```bash
# Create a new project
caddie rust:new myapp

# Create with descriptive name
caddie rust:new web-api-backend
```

**What it does:**
- Creates a new Rust project using `cargo new`
- Sets up standard project structure
- Provides navigation and build instructions

**Output:**
```
Creating new Rust project 'myapp'...
✓ Rust project 'myapp' created successfully
  Location: /Users/username/projects/myapp
  Enter directory: cd myapp
  Build project: caddie rust:build
```

**Requirements:**
- Rust toolchain installed (`rustup`)
- Cargo available in PATH
- Write permissions in current directory

#### `caddie rust:build`

Build the current Rust project.

**Examples:**
```bash
# Build in current directory
caddie rust:build

# Build specific project
cd myapp
caddie rust:build
```

**What it does:**
- Runs `cargo build` in the current directory
- Compiles the project and dependencies
- Shows build output and results

**Output:**
```
Building Rust project...
   Compiling myapp v0.1.0 (/Users/username/projects/myapp)
    Finished dev [unoptimized + debuginfo] target(s) in 2.34s
✓ Rust project built successfully
```

**Requirements:**
- Must be in a Rust project directory (contains `Cargo.toml`)
- Rust toolchain available

#### `caddie rust:run`

Run the current Rust project.

**Examples:**
```bash
# Run in current directory
caddie rust:run

# Run with arguments
caddie rust:run -- --help
```

**What it does:**
- Runs `cargo run` in the current directory
- Compiles and executes the project
- Passes any additional arguments to the program

**Output:**
```
Running Rust project...
    Finished dev [unoptimized + debuginfo] target(s) in 0.02s
     Running `target/debug/myapp`
Hello, World!
✓ Rust project ran successfully
```

**Requirements:**
- Must be in a Rust project directory
- Project must compile successfully

#### `caddie rust:test`

Run tests for the current Rust project.

**Examples:**
```bash
# Run all tests
caddie rust:test

# Run specific test
caddie rust:test test_function_name
```

**What it does:**
- Runs `cargo test` in the current directory
- Executes all test functions
- Shows test results and coverage

**Output:**
```
Running Rust tests...
   Compiling myapp v0.1.0 (/Users/username/projects/myapp)
    Finished test [unoptimized + debuginfo] target(s) in 1.23s
     Running unittests src/lib.rs (target/debug/deps/myapp-1234567890abcdef)

running 2 tests
test tests::it_works ... ok
test tests::another_test ... ok

test result: ok. 2 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out
✓ Rust tests completed successfully
```

**Requirements:**
- Must be in a Rust project directory
- Project must have test functions

#### `caddie rust:check`

Check the current Rust project without building.

**Examples:**
```bash
# Check current project
caddie rust:check

# Check with specific features
caddie rust:check --features "feature1,feature2"
```

**What it does:**
- Runs `cargo check` in the current directory
- Validates code without generating artifacts
- Faster than full build for syntax checking

**Output:**
```
Checking Rust project...
    Finished dev [unoptimized + debuginfo] target(s) in 0.45s
✓ Rust project check passed
```

**Requirements:**
- Must be in a Rust project directory
- Rust toolchain available

#### `caddie rust:clean`

Clean build artifacts for the current Rust project.

**Examples:**
```bash
# Clean current project
caddie rust:clean

# Clean and rebuild
caddie rust:clean && caddie rust:build
```

**What it does:**
- Runs `cargo clean` in the current directory
- Removes `target/` directory and build artifacts
- Frees up disk space

**Output:**
```
Cleaning Rust build artifacts...
✓ Rust build artifacts cleaned
```

**Requirements:**
- Must be in a Rust project directory

### Dependency Management

#### `caddie rust:add <crate>`

Add a dependency to the current Rust project.

**Arguments:**
- `crate`: Name of the crate to add

**Examples:**
```bash
# Add single dependency
caddie rust:add serde

# Add with specific version
caddie rust:add "serde@1.0"

# Add with features
caddie rust:add "tokio@1.0" --features "full"
```

**What it does:**
- Runs `cargo add <crate>` in the current directory
- Adds dependency to `Cargo.toml`
- Updates `Cargo.lock` if needed

**Output:**
```
Adding dependency 'serde'...
    Updating crates.io index
      Adding serde v1.0.188 to dependencies
✓ Dependency 'serde' added successfully
```

**Requirements:**
- Must be in a Rust project directory
- Internet connection for crate index

#### `caddie rust:remove <crate>`

Remove a dependency from the current Rust project.

**Arguments:**
- `crate`: Name of the crate to remove

**Examples:**
```bash
# Remove dependency
caddie rust:remove serde

# Remove unused dependency
caddie rust:remove old-crate
```

**What it does:**
- Runs `cargo remove <crate>` in the current directory
- Removes dependency from `Cargo.toml`
- Updates `Cargo.lock` if needed

**Output:**
```
Removing dependency 'serde'...
      Removing serde v1.0.188 from dependencies
✓ Dependency 'serde' removed successfully
```

**Requirements:**
- Must be in a Rust project directory
- Crate must be in dependencies

#### `caddie rust:update`

Update dependencies for the current Rust project.

**Examples:**
```bash
# Update all dependencies
caddie rust:update

# Update specific dependency
caddie rust:update serde
```

**What it does:**
- Runs `cargo update` in the current directory
- Updates `Cargo.lock` with latest compatible versions
- Respects version constraints in `Cargo.toml`

**Output:**
```
Updating Rust dependencies...
    Updating crates.io index
    Updating serde v1.0.188 -> v1.0.189
✓ Rust dependencies updated
```

**Requirements:**
- Must be in a Rust project directory
- Internet connection for crate index

#### `caddie rust:search <query>`

Search for crates on crates.io.

**Arguments:**
- `query`: Search query for crates

**Examples:**
```bash
# Search for HTTP client
caddie rust:search http client

# Search for specific functionality
caddie rust:search json parsing
```

**What it does:**
- Runs `cargo search <query>`
- Searches the crates.io registry
- Shows matching crates with descriptions

**Output:**
```
Searching crates.io for 'http client'...
reqwest = "0.11"           # HTTP client library
ureq = "2.8"               # Simple HTTP client
attohttpc = "0.26"         # Minimal HTTP client
```

**Requirements:**
- Internet connection for crates.io access

#### `caddie rust:outdated`

Check for outdated Rust dependencies.

**Examples:**
```bash
# Check for outdated dependencies
caddie rust:outdated

# Check with specific format
caddie rust:outdated --format json
```

**What it does:**
- Installs `cargo-outdated` if not available
- Runs `cargo outdated` to check for updates
- Shows current vs. latest versions

**Output:**
```
Checking for outdated Rust dependencies...
Name         Project  Compat  Latest   Kind    Platform
----         -------  ------  ------   ----    --------
serde        1.0.188  1.0.189 1.0.189  Normal  ---
tokio        1.32.0   1.32.0  1.33.0   Normal  ---
```

**Requirements:**
- Must be in a Rust project directory
- Internet connection for version checking

#### `caddie rust:audit`

Run security audit on the current Rust project.

**Examples:**
```bash
# Run security audit
caddie rust:audit

# Audit with specific options
caddie rust:audit --deny warnings
```

**What it does:**
- Installs `cargo-audit` if not available
- Runs security vulnerability scan
- Reports any security issues found

**Output:**
```
Running Rust security audit...
    Fetching advisory database from `https://github.com/rustsec/advisory-db.git`
      Loaded 1234 security advisories (from 567 commits, 890 files)
    Scanning Cargo.lock for vulnerabilities (123 crates, 456 KB)
    No vulnerabilities found
✓ Rust security audit passed
```

**Requirements:**
- Must be in a Rust project directory
- Internet connection for advisory database

### Toolchain Management

#### `caddie rust:toolchain <version>`

Switch to a specific Rust toolchain.

**Arguments:**
- `version`: Toolchain version to switch to

**Examples:**
```bash
# Switch to stable
caddie rust:toolchain stable

# Switch to specific version
caddie rust:toolchain 1.70.0

# Switch to nightly
caddie rust:toolchain nightly

# Switch to beta
caddie rust:toolchain beta
```

**What it does:**
- Runs `rustup default <version>`
- Sets the default Rust toolchain
- Shows the new toolchain version

**Output:**
```
Switching to Rust toolchain 'stable'...
info: using existing install for 'stable-x86_64-apple-darwin'
info: default toolchain set to 'stable-x86_64-apple-darwin'
✓ Switched to Rust toolchain 'stable'
  Current version: rustc 1.70.0 (90c541806 2023-05-31)
```

**Requirements:**
- Rustup installed and configured
- Toolchain version available

#### `caddie rust:target <target>`

Add a compilation target to the current Rust project.

**Arguments:**
- `target`: Target triple to add

**Examples:**
```bash
# Add Linux target
caddie rust:target x86_64-unknown-linux-gnu

# Add Windows target
caddie rust:target x86_64-pc-windows-msvc

# Add ARM target
caddie rust:target aarch64-unknown-linux-gnu
```

**What it does:**
- Runs `rustup target add <target>`
- Downloads and installs target components
- Enables cross-compilation

**Output:**
```
Adding Rust target 'x86_64-unknown-linux-gnu'...
info: downloading component 'rust-std' for 'x86_64-unknown-linux-gnu'
info: installing component 'rust-std' for 'x86_64-unknown-linux-gnu'
✓ Added Rust target 'x86_64-unknown-linux-gnu'
```

**Requirements:**
- Rustup installed and configured
- Internet connection for target download

#### `caddie rust:component <component>`

Install a Rust component.

**Arguments:**
- `component`: Component name to install

**Examples:**
```bash
# Install clippy linter
caddie rust:component clippy

# Install rustfmt formatter
caddie rust:component rustfmt

# Install rust-src for IDE support
caddie rust:component rust-src
```

**What it does:**
- Runs `rustup component add <component>`
- Installs additional Rust tools
- Enables enhanced development features

**Output:**
```
Installing Rust component 'clippy'...
info: downloading component 'clippy' for 'x86_64-apple-darwin'
info: installing component 'clippy' for 'x86_64-apple-darwin'
✓ Installed Rust component 'clippy'
```

**Requirements:**
- Rustup installed and configured
- Internet connection for component download

## Environment Variables

### `CARGO_HOME`

**Purpose**: Custom Cargo home directory
**Default**: `~/.cargo`
**Set by**: Environment configuration

**Usage:**
```bash
export CARGO_HOME="$HOME/.custom_cargo"
export PATH="$CARGO_HOME/bin:$PATH"
```

### `RUSTUP_HOME`

**Purpose**: Custom Rustup home directory
**Default**: `~/.rustup`
**Set by**: Environment configuration

**Usage:**
```bash
export RUSTUP_HOME="$HOME/.custom_rustup"
export PATH="$RUSTUP_HOME/toolchains/stable-x86_64-apple-darwin/bin:$PATH"
```

### `RUSTUP_TOOLCHAIN`

**Purpose**: Default Rust toolchain
**Default**: `stable`
**Set by**: `caddie rust:toolchain <version>`

**Usage:**
```bash
export RUSTUP_TOOLCHAIN="nightly"
rustc --version  # Uses nightly
```

## Configuration Files

### `Cargo.toml`

**Purpose**: Rust project configuration
**Created by**: `cargo new` or `caddie rust:new`
**Format**: TOML configuration

**Example content:**
```toml
[package]
name = "myapp"
version = "0.1.0"
edition = "2021"

[dependencies]
serde = "1.0"
tokio = { version = "1.0", features = ["full"] }

[dev-dependencies]
tokio-test = "0.4"

[profile.release]
opt-level = 3
lto = true
```

### `Cargo.lock`

**Purpose**: Locked dependency versions
**Created by**: Cargo automatically
**Format**: TOML lock file

**Note**: Should be committed to version control for reproducible builds

### `rust-toolchain.toml`

**Purpose**: Project-specific toolchain configuration
**Created by**: Manual creation
**Format**: TOML configuration

**Example content:**
```toml
[toolchain]
channel = "1.70.0"
components = ["rustfmt", "clippy"]
targets = ["x86_64-unknown-linux-gnu"]
```

## Error Handling

### Common Errors

#### "Error: Not in a Rust project directory (Cargo.toml not found)"
**Cause**: Command run outside Rust project
**Solution**: Navigate to project directory or create new project

#### "Error: Rust environment not found at ~/.cargo/env"
**Cause**: Rust not installed or configured
**Solution**: Install Rust using rustup: `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh`

#### "Error: Toolchain 'version' not found"
**Cause**: Toolchain not installed
**Solution**: Install toolchain: `rustup toolchain install version`

#### "Error: Target 'target' not found"
**Cause**: Target not available
**Solution**: Check available targets: `rustup target list`

### Error Output Format

All errors follow a consistent format:
```
Error: <description>
Usage: caddie rust:<command> <arguments>
```

## Best Practices

### Project Structure

1. **Use standard layout**: Follow Cargo conventions
2. **Organize modules**: Group related functionality
3. **Separate concerns**: Keep business logic separate from infrastructure
4. **Documentation**: Include doc comments for public APIs

### Dependency Management

1. **Pin versions**: Use specific versions for production
2. **Minimize dependencies**: Only include necessary crates
3. **Security updates**: Regularly run `caddie rust:audit`
4. **Version compatibility**: Test with multiple Rust versions

### Development Workflow

1. **Check before build**: Use `caddie rust:check` for quick validation
2. **Run tests**: Always test before committing
3. **Use clippy**: Enable clippy for code quality
4. **Format code**: Use rustfmt for consistent style

### Performance

1. **Release builds**: Use `--release` flag for production
2. **Profile builds**: Use cargo-profiler for performance analysis
3. **Optimize dependencies**: Review and optimize dependency tree
4. **Benchmark**: Use criterion for performance testing

## Examples

### Complete Project Setup

```bash
#!/bin/bash
# setup-rust-project.sh

# Create new project
caddie rust:new myapp
cd myapp

# Add dependencies
caddie rust:add serde
caddie rust:add tokio --features "full"
caddie rust:add clap --features "derive"

# Install development tools
caddie rust:component clippy
caddie rust:component rustfmt

# Build and test
caddie rust:build
caddie rust:test

echo "Rust project setup complete!"
```

### Development Workflow

```bash
#!/bin/bash
# rust-dev-workflow.sh

# Check code quality
caddie rust:check

# Run tests
caddie rust:test

# Build project
caddie rust:build

# Run project
caddie rust:run

# Check for outdated dependencies
caddie rust:outdated

# Security audit
caddie rust:audit
```

### CI/CD Integration

```bash
#!/bin/bash
# ci-rust.sh

# Install Rust toolchain
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source ~/.cargo/env

# Install components
rustup component add clippy rustfmt

# Check code
cargo check
cargo clippy -- -D warnings
cargo fmt -- --check

# Run tests
cargo test

# Build
cargo build --release

# Security audit
cargo audit --deny warnings
```

### Cross-Platform Development

#### iOS Integration

##### `caddie ios:rust:setup`

Set up Rust development environment specifically for iOS development.

**Examples:**
```bash
# Setup Rust for iOS development
caddie ios:rust:setup
```

**What it does:**
- Installs Rust if not already present
- Adds iOS-specific targets (aarch64-apple-ios, x86_64-apple-ios)
- Installs essential Cargo tools (cargo-edit, cargo-watch, cargo-tarpaulin)
- Validates iOS development environment (Xcode, Swift)
- Provides next steps for iOS-Rust integration

**Output:**
```
Setting up Rust development environment for iOS...
✓ Rust already installed: rustc 1.75.0 (8ea583342 2023-12-18)
Adding iOS Rust targets...
✓ iOS Rust targets added successfully
Installing essential Cargo tools...
✓ Cargo tools installed successfully
Validating iOS development environment...
✓ iOS development environment validated
  Xcode: Xcode 15.2 Build version 15C500b
  Swift: swift-driver version: 1.75.2
  Rust: rustc 1.75.0 (8ea583342 2023-12-18)
✓ Rust development environment for iOS setup complete

Next steps:
1. Build Rust library: cargo build --target aarch64-apple-ios --release --lib
2. Create iOS framework structure for Swift integration
3. Use the generated .a static libraries in your iOS project
```

**Requirements:**
- macOS with Xcode installed
- Xcode command line tools
- Internet connection for Rust installation

**Idempotent:** Yes - can be run multiple times safely

#### Cross-Platform Targets

For general cross-platform development, use the target management commands:

## Troubleshooting

### Common Issues

#### Build Failures

1. **Check Rust version**:
   ```bash
   rustc --version
   cargo --version
   ```

2. **Update toolchain**:
   ```bash
   rustup update
   ```

3. **Clean and rebuild**:
   ```bash
   caddie rust:clean
   caddie rust:build
   ```

#### Dependency Issues

1. **Update Cargo.lock**:
   ```bash
   caddie rust:update
   ```

2. **Check dependency versions**:
   ```bash
   cat Cargo.toml
   ```

3. **Remove and re-add dependency**:
   ```bash
   caddie rust:remove problematic-crate
   caddie rust:add problematic-crate
   ```

#### Toolchain Issues

1. **Check available toolchains**:
   ```bash
   rustup toolchain list
   ```

2. **Install missing toolchain**:
   ```bash
   rustup toolchain install stable
   ```

3. **Set default toolchain**:
   ```bash
   caddie rust:toolchain stable
   ```

### Performance Issues

1. **Use release builds**:
   ```bash
   cargo build --release
   ```

2. **Profile with cargo-profiler**:
   ```bash
   cargo install cargo-profiler
   cargo profiler callgrind
   ```

3. **Check dependency tree**:
   ```bash
   cargo tree
   ```

## Related Documentation

- **[Core Module](core.md)** - Basic Caddie.sh functions
- **[Installation Guide](../installation.md)** - How to install Caddie.sh
- **[User Guide](../user-guide.md)** - General usage instructions
- **[Configuration Guide](../configuration.md)** - Customization options

## External Resources

- **[Rust Book](https://doc.rust-lang.org/book/)** - Official Rust documentation
- **[Cargo Book](https://doc.rust-lang.org/cargo/)** - Cargo package manager guide
- **[Rustup Book](https://rust-lang.github.io/rustup/)** - Rustup toolchain manager
- **[crates.io](https://crates.io/)** - Rust package registry

---

*The Rust module provides everything you need for professional Rust development. From project creation to deployment, it makes Rust development effortless and consistent.*
