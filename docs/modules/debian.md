# Debian Module

The Debian module provides package management helpers for Debian-based systems.

## Overview

Use this module to:
- Update and upgrade packages with apt
- Install or remove packages
- Clean and autoremove unused packages
- Search the package index

## Commands

### Package Management

- `caddie debian:pkg:update` - Update apt package lists
- `caddie debian:pkg:upgrade` - Upgrade installed packages
- `caddie debian:pkg:install <pkg> [pkg...]` - Install packages
- `caddie debian:pkg:remove <pkg> [pkg...]` - Remove packages
- `caddie debian:pkg:autoremove` - Remove unused packages
- `caddie debian:pkg:clean` - Clean apt cache
- `caddie debian:pkg:search <query>` - Search the package index

## Notes

- Most commands require `sudo` access for package changes.
- This module expects `apt-get` and `apt-cache` to be available.

## Examples

```bash
caddie debian:pkg:update
caddie debian:pkg:upgrade
caddie debian:pkg:install curl git
caddie debian:pkg:search nginx
```
