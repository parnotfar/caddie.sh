# Server Module

The Server module provides remote server access and basic service control helpers.

## Overview

Use this module to:
- Store a default server host and user
- Open SSH sessions quickly
- Check or restart services via systemd

## Commands

### Configuration

- `caddie server:host:set <host>` - Set the default server host
- `caddie server:host:get` - Show the default server host
- `caddie server:host:unset` - Unset the default server host
- `caddie server:user:set <user>` - Set the default server user
- `caddie server:user:get` - Show the default server user
- `caddie server:user:unset` - Unset the default server user

### Remote Access

- `caddie server:ssh [host] [user]` - Open an SSH session (uses defaults if omitted)

### Service Management

- `caddie server:service:status <service> [host] [user]` - Check service status via systemd
- `caddie server:service:restart <service> [host] [user]` - Restart a service via systemd

## Examples

```bash
caddie server:host:set prod.example.com
caddie server:user:set deploy
caddie server:ssh
caddie server:service:status nginx
caddie server:service:restart nginx
```
