# JavaScript Module

The JavaScript module provides Node.js setup, project management, and package tooling through a consistent caddie interface.

## Overview

Use this module to:
- Install Node.js via NVM and manage versions
- Initialize and manage Node.js projects
- Manage npm packages and scripts
- Scaffold popular framework projects

## Commands

### Setup & Versioning

- `caddie js:setup` - Install Node.js and NVM
- `caddie js:install` - Install Yarn, pnpm, and TypeScript
- `caddie js:use <version>` - Switch Node.js version
- `caddie js:list` - List installed Node.js versions
- `caddie js:version` - Show current Node/npm tooling versions

### Project Management

- `caddie js:project:init [name]` - Initialize a new project
- `caddie js:project:install` - Install project dependencies
- `caddie js:project:update` - Update project dependencies
- `caddie js:project:test` - Run tests
- `caddie js:project:build` - Build project
- `caddie js:project:serve` - Serve project

### Package Management

- `caddie js:package:install <pkg>` - Install a package
- `caddie js:package:uninstall <pkg>` - Uninstall a package
- `caddie js:package:list` - List installed packages
- `caddie js:package:update` - Update packages
- `caddie js:package:outdated` - Show outdated packages
- `caddie js:package:audit` - Run `npm audit`
- `caddie js:package:run <script>` - Run an npm script
- `caddie js:package:publish` - Publish a package

### Framework Scaffolds

- `caddie js:framework:create <type> <name>` - Create a framework app (`react`, `vue`, `angular`, `next`, `nuxt`)
- `caddie js:framework:serve` - Serve framework app
- `caddie js:framework:build` - Build framework app

## Examples

```bash
caddie js:setup
caddie js:use 18.17.0
caddie js:project:init my-app
caddie js:framework:create react my-react-app
```
