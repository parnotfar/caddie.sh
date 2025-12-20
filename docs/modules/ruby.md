# Ruby Module

The Ruby module provides comprehensive Ruby environment management using RVM (Ruby Version Manager). It handles Ruby installation, version management, gemset isolation, gem management, and Rails development workflows.

## Overview

- **Environment Management** – Install and manage Ruby versions with RVM
- **Version Detection** – Automatically detects and installs latest stable Ruby version
- **OpenSSL Integration** – Automatically configures Homebrew's OpenSSL for Ruby compilation on macOS
- **Gemset Management** – Create and manage isolated gem environments
- **Gem Management** – Install, update, and manage Ruby gems
- **Rails Support** – Complete Rails workflow helpers
- **Bundler Integration** – Manage project dependencies

## Commands

### Environment Management

#### `caddie ruby:setup`

Sets up the Ruby development environment with RVM. This command:

- Installs RVM if not already present (with GPG key verification)
- Detects and installs the latest stable Ruby version from ruby-lang.org
- Configures OpenSSL paths for macOS compilation (uses Homebrew's OpenSSL@3)
- Sets the installed Ruby as the default
- Installs essential gems (bundler, rails, rake, rspec, pry)

**Version Pinning:**
You can pin a specific Ruby version using the `caddie ruby:pin:set` command:
```bash
caddie ruby:pin:set 3.4.8
caddie ruby:setup
```

To check the currently pinned version:
```bash
caddie ruby:pin:get
```

To unpin and use the latest stable version:
```bash
caddie ruby:pin:unset
```

**Example:**
```bash
caddie ruby:setup
```

#### `caddie ruby:install <version>`

Installs a specific Ruby version using RVM. Automatically configures OpenSSL for macOS.

**Example:**
```bash
caddie ruby:install 3.4.8
caddie ruby:install 3.3.6
```

#### `caddie ruby:use <version>`

Switches to a specific Ruby version for the current shell session.

**Example:**
```bash
caddie ruby:use 3.4.8
```

#### `caddie ruby:list`

Lists all installed Ruby versions and shows the current active version.

#### `caddie ruby:current`

Shows detailed information about the current Ruby environment, including:
- Ruby version
- Gem version
- RVM version
- Current gemset
- Bundler version (if installed)
- Rails version (if installed)

#### `caddie ruby:version`

Shows comprehensive Ruby and RVM version information.

### Gemset Management

Gemsets provide isolated gem environments for different projects.

#### `caddie ruby:gemset:create <name>`

Creates a new gemset for the current Ruby version.

**Example:**
```bash
caddie ruby:gemset:create myproject
```

#### `caddie ruby:gemset:use <name>`

Switches to a specific gemset.

**Example:**
```bash
caddie ruby:gemset:use myproject
```

#### `caddie ruby:gemset:list`

Lists all available gemsets for the current Ruby version.

#### `caddie ruby:gemset:delete <name>`

Deletes a gemset (use with caution).

### Gem Management

#### `caddie ruby:gem:install <gem>`

Installs a Ruby gem using the current Ruby environment's gem command.

**Example:**
```bash
caddie ruby:gem:install xcodeproj
caddie ruby:gem:install rails
```

#### `caddie ruby:gem:uninstall <gem>`

Uninstalls a Ruby gem.

#### `caddie ruby:gem:list`

Lists all installed gems for the current Ruby/gemset.

#### `caddie ruby:gem:update <gem>`

Updates a specific gem to the latest version.

#### `caddie ruby:gem:outdated`

Shows all outdated gems that can be updated.

### Project Management

#### `caddie ruby:project:init`

Initializes a basic Ruby project structure with a `Gemfile` and directory layout.

#### `caddie ruby:project:test`

Runs tests for the current Ruby project (looks for `test/` or `spec/` directories).

#### `caddie ruby:project:build`

Builds the current Ruby project (typically runs `bundle install` if a `Gemfile` exists).

#### `caddie ruby:project:serve`

Starts a development server for the Ruby web application (supports Rack, Sinatra, Rails).

### Bundler Management

Bundler manages Ruby project dependencies defined in `Gemfile`.

#### `caddie ruby:bundler:install`

Installs all dependencies specified in the `Gemfile`.

#### `caddie ruby:bundler:update`

Updates all dependencies in the `Gemfile` to their latest compatible versions.

#### `caddie ruby:bundler:exec <command>`

Executes a command in the context of the Bundler environment.

**Example:**
```bash
caddie ruby:bundler:exec rails server
caddie ruby:bundler:exec rspec
```

### Rails Management

Complete workflow helpers for Rails development.

#### `caddie ruby:rails:new <app_name>`

Creates a new Rails application.

**Example:**
```bash
caddie ruby:rails:new myapp
```

#### `caddie ruby:rails:server`

Starts the Rails development server (typically on port 3000).

#### `caddie ruby:rails:console`

Opens the Rails console (interactive Ruby shell with Rails environment loaded).

#### `caddie ruby:rails:generate <generator> <name>`

Generates Rails components (models, controllers, migrations, etc.).

**Examples:**
```bash
caddie ruby:rails:generate model User
caddie ruby:rails:generate controller Users
caddie ruby:rails:generate scaffold Post
```

#### `caddie ruby:rails:migrate`

Runs pending database migrations.

#### `caddie ruby:rails:routes`

Displays all defined routes in the Rails application.

### `caddie ruby:help`

Prints a comprehensive command reference for all Ruby commands.

## Requirements

- **macOS/Linux** – RVM works on both platforms
- **Homebrew** (macOS) – Required for Ruby compilation dependencies (OpenSSL, readline, libyaml, etc.)
- **Build Tools** – Automatically installed via `make install` or `make setup-ruby-deps`:
  - openssl@3 (or openssl)
  - readline
  - libyaml
  - gmp
  - autoconf, automake, libtool
  - pkg-config

## Configuration

### Version Pinning

To pin a specific Ruby version instead of using the latest stable:

```bash
caddie ruby:pin:set 3.4.8
caddie ruby:setup
```

The pinned version is stored in the `CADDIE_RUBY_VERSION` environment variable and is respected by `caddie ruby:setup`. To check or modify the pinned version, use:
- `caddie ruby:pin:get` - Show currently pinned version
- `caddie ruby:pin:set <version>` - Set pinned version
- `caddie ruby:pin:unset` - Remove pinning (use latest stable)

### RVM Setup

The `caddie ruby:setup` command handles RVM installation automatically:

1. Imports GPG keys for signature verification
2. Installs RVM using the official installer
3. Configures OpenSSL paths for macOS
4. Updates RVM to get latest Ruby version information
5. Installs the latest stable Ruby (or pinned version)
6. Sets the installed Ruby as default
7. Installs essential gems

## Troubleshooting

- **"Ruby compilation failed"** – Ensure Ruby build dependencies are installed:
  ```bash
  make setup-ruby-deps
  # or
  brew install openssl@3 readline libyaml gmp autoconf automake libtool pkg-config
  ```

- **"OpenSSL errors during compilation"** – The setup command automatically configures OpenSSL from Homebrew. If issues persist, ensure `openssl@3` is installed:
  ```bash
  brew install openssl@3
  ```

- **"GPG signature verification failed"** – The setup command attempts to import GPG keys automatically. If this fails, you can manually import:
  ```bash
  gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
  ```

- **"PATH is not properly set up"** – RVM will warn if PATH isn't configured correctly. Run:
  ```bash
  rvm get stable --auto-dotfiles
  ```
  Then restart your terminal.

- **"Gem install permission denied"** – Ensure you're using RVM Ruby, not system Ruby:
  ```bash
  caddie ruby:setup
  ```

## Integration with Other Modules

The Ruby module is used by other caddie modules:

- **Swift Module** – Uses Ruby with the `xcodeproj` gem to programmatically add Swift Package dependencies to Xcode projects:
  ```bash
  caddie ruby:setup
  caddie swift:xcode:packages:add vCaddie ../physics-core-swift PhysicsCore
  ```

The Ruby setup is automatically detected and used when available.
