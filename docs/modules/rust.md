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

#### `caddie rust:run:example <name|path>`

Run a specific Cargo example by name or by pointing at the example file.

**Arguments:**
- `name|path`: Either the example's Cargo name (e.g., `multi_distance_demo`) or the path to the `.rs` file (e.g., `targets/multi_distance_demo.rs`)

**Examples:**
```bash
# Run a specific example
caddie rust:run:example simple_demo

# Alternate syntax (alias)
caddie rust:example:run simple_demo

# Run example with arguments
caddie rust:run:example multi_distance_demo -- --help

# Run example by file path (same as above)
caddie rust:run:example targets/multi_distance_demo.rs
```

**What it does:**
- Resolves the provided name or file path to an example name
- Runs `cargo run --example <resolved-name>` in the current directory
- Compiles and executes the specified example
- Passes any additional arguments to the example program

**Output:**
```
Running Cargo example 'simple_demo'...
   Compiling myapp v0.1.0 (/Users/username/projects/myapp)
    Finished dev [unoptimized + debuginfo] target(s) in 0.45s
     Running `target/debug/examples/simple_demo`
Monte Carlo Golf Simulation Engine Demo
=====================================
✓ Cargo example 'simple_demo' ran successfully
```

**Requirements:**
- Must be in a Rust project directory
- Example must exist in `examples/` directory
- Example must compile successfully

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

#### `caddie rust:fix`

Apply compiler-driven fixes to the current Rust project.

**Examples:**
```bash
# Apply fixes for the active project
caddie rust:fix

# Apply fixes after running clippy
cargo clippy
caddie rust:fix
```

**What it does:**
- Runs `cargo fix` in the current directory
- Applies Rust compiler suggestions to your source code
- Surfaces success or failure with caddie CLI messaging

**Output:**
```
Applying Rust fix suggestions...
    Checking myapp v0.1.0 (/Users/username/projects/myapp)
    Fixing src/lib.rs (1 fix)
✓ Rust fixes applied successfully
```

**Requirements:**
- Must be in a Rust project directory
- Rust toolchain available

#### `caddie rust:fix:all`

Apply compiler-driven fixes across all targets in the workspace.

**Examples:**
```bash
# Apply fixes for libraries, binaries, tests, and examples
caddie rust:fix:all

# Combine with targeted checks
caddie rust:check && caddie rust:fix:all
```

**What it does:**
- Runs `cargo fix --all-targets`
- Ensures fixes cover binaries, libraries, tests, and examples
- Provides consistent messaging for success and failure

**Output:**
```
Applying Rust fix suggestions for all targets...
    Checking myapp v0.1.0 (/Users/username/projects/myapp)
    Fixing src/main.rs (2 fixes)
    Fixing tests/integration.rs (1 fix)
✓ Rust fixes for all targets applied successfully
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

### Git Integration

The Rust module includes comprehensive git integration to prevent build artifacts from being accidentally committed to version control.

#### `caddie rust:init <name>`

Create a new Rust project with comprehensive `.gitignore` file.

**Arguments:**
- `name`: Name of the new Rust project

**Examples:**
```bash
# Create project with proper .gitignore
caddie rust:init myapp

# Create with descriptive name
caddie rust:init web-api-backend
```

**What it does:**
- Creates a new Rust project using `cargo new`
- Adds comprehensive `.gitignore` file covering:
  - Rust build artifacts (`/target/`, `*.rlib`, `*.rmeta`)
  - IDE files (`.vscode/`, `.idea/`, `*.swp`)
  - OS files (`.DS_Store`, `Thumbs.db`)
  - Temporary files and logs
- Sets up standard project structure
- Provides navigation and build instructions

**Output:**
```
Creating new Rust project 'myapp' with proper .gitignore...
✓ Rust project 'myapp' created successfully with .gitignore
  Location: /Users/username/projects/myapp
  Enter directory: cd myapp
  Build project: caddie rust:build
  Run tests: caddie rust:test:unit
```

**Requirements:**
- Rust toolchain installed (`rustup`)
- Cargo available in PATH
- Write permissions in current directory

#### `caddie rust:git:status`

Check git status for build artifacts in the current Rust project.

**Examples:**
```bash
# Check current project
caddie rust:git:status

# Check before committing
caddie rust:git:status && git add .
```

**What it does:**
- Checks for tracked build artifacts in git
- Identifies files like `target/`, `*.rlib`, `*.rmeta`, `*.so`, etc.
- Warns about potential issues before they reach git history
- Shows count of problematic files
- Provides guidance for fixing issues

**Output:**
```
Checking git status for build artifacts...
✓ No build artifacts tracked in git
✓ Git status check completed
```

**Or if issues found:**
```
Checking git status for build artifacts...
✗ Warning: Build artifacts are tracked in git!
  Found tracked build files:
    - target/debug/myapp
    - target/debug/deps/myapp-1234567890abcdef
    - target/debug/deps/libserde-abcdef1234567890.rlib
    ... and 15 more files

To fix this:
1. Add proper .gitignore: caddie rust:gitignore
2. Remove tracked files: caddie rust:git:clean
```

**Requirements:**
- Must be in a git repository
- Must be in a Rust project directory

#### `caddie rust:gitignore`

Add comprehensive `.gitignore` to existing Rust project.

**Examples:**
```bash
# Add to current project
caddie rust:gitignore

# Add to specific project
cd myproject
caddie rust:gitignore
```

**What it does:**
- Adds comprehensive `.gitignore` file to current directory
- Backs up existing `.gitignore` if present
- Covers Rust build artifacts, IDE files, OS files, and temporary files
- Provides next steps for cleanup

**Output:**
```
Adding comprehensive .gitignore to Rust project...
✓ Comprehensive .gitignore added successfully
  File: /Users/username/projects/myproject/.gitignore

Next steps:
1. Check git status: caddie rust:git:status
2. Clean tracked artifacts: caddie rust:git:clean
```

**Requirements:**
- Must be in a Rust project directory (contains `Cargo.toml`)

#### `caddie rust:git:clean`

Remove tracked build artifacts from git history.

**Examples:**
```bash
# Clean current project
caddie rust:git:clean

# Clean and commit changes
caddie rust:git:clean && git commit -m "Remove build artifacts"
```

**What it does:**
- Identifies tracked build artifacts in git
- Removes them from git tracking (keeps local files)
- Handles both individual files and entire `target/` directory
- Provides guidance for committing changes

**Output:**
```
Cleaning tracked build artifacts from git...
Found 23 tracked build artifacts
Removing from git tracking...
Removed target/ directory from tracking
✓ Build artifacts removed from git tracking

Next steps:
1. Commit the changes: git commit -m 'Remove build artifacts'
2. Verify cleanup: caddie rust:git:status
```

**Requirements:**
- Must be in a git repository
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
2. **Apply compiler fixes**: Run `caddie rust:fix` (or `rust:fix:all` for workspaces) after addressing warnings
3. **Run tests**: Always test before committing
4. **Use clippy**: Enable clippy for code quality
5. **Format code**: Use rustfmt for consistent style

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

### Cross-Platform Targets

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
