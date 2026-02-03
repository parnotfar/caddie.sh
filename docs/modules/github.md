# GitHub Module

The GitHub module provides GitHub account and repository management functionality for seamless integration with Git workflows.

## Overview

The GitHub module (`caddie github:<command>`) manages your GitHub account information and provides repository management capabilities. It integrates with the Git module to enable automatic URL generation and streamlined workflows.

## Commands

### Account Management

#### `caddie github:info`
Show GitHub account status and auth summary.

```bash
caddie github:info
```

#### `caddie github:account:set <account>`
Set your GitHub account username for use with other commands.

```bash
caddie github:account:set parnotfar
caddie github:account:set myusername
```

#### `caddie github:account:get`
Get the currently set GitHub account.

```bash
caddie github:account:get
# Output: parnotfar
```

#### `caddie github:account:unset`
Unset the current GitHub account.

```bash
caddie github:account:unset
```

### Repository Management

#### `caddie github:repo:create <name> [description] [private]`
Create a new GitHub repository.

```bash
# Create public repository
caddie github:repo:create my-new-project

# Create public repository with description
caddie github:repo:create my-new-project "A cool new project"

# Create private repository
caddie github:repo:create my-private-project "Private project" true
```

#### `caddie github:repo:url [name]`
Get the repository URL. Auto-detects repository name from current directory if no name provided.

```bash
# Get URL for current directory repository
caddie github:repo:url

# Get URL for specific repository
caddie github:repo:url my-project
```

## Integration with Git Module

The GitHub module works seamlessly with the Git module to provide enhanced workflows:

### Complete Setup Workflow

```bash
# 1. Set GitHub account
caddie github:account:set parnotfar

# 2. Create new repository on GitHub
caddie github:repo:create my-awesome-project "My awesome project"

# 3. Clone the repository
caddie git:clone my-awesome-project

# 4. Add files and commit
cd my-awesome-project
echo "# My Awesome Project" > README.md
caddie git:commit "Initial commit"

# 5. Set upstream and push
caddie git:push:set:upstream
```

### Auto-Detection Features

When GitHub account is set, several commands can auto-detect information:

```bash
# Auto-detect repository name and GitHub account
caddie git:remote:add

# Auto-detect repository name for URL
caddie github:repo:url
```

## Account Persistence

GitHub account information is stored as a session variable and persists for the duration of your terminal session. To make it permanent across sessions, you can add it to your shell profile:

```bash
# Add to ~/.bash_profile or ~/.bashrc
echo 'caddie github:account:set parnotfar' >> ~/.bash_profile
```

## Error Handling

The module provides clear error messages for common issues:

```bash
# No account set
caddie git:clone my-project
# Error: No GitHub account set. Use 'caddie github:account:set <account>' first

# Invalid account name
caddie github:account:set ""
# Error: Account name cannot be empty
```

## Security Considerations

- Account information is stored in memory only (session variable)
- No passwords or tokens are stored
- Uses SSH keys for authentication (configured separately)
- Account name is visible in terminal prompt when set

## Tips and Best Practices

1. **Set Account Early**: Set your GitHub account as soon as you start using Caddie.sh for the best experience.

2. **Use Auto-Detection**: Take advantage of auto-detection features to reduce typing and errors.

3. **SSH Key Setup**: Ensure your SSH keys are properly configured with GitHub for seamless operation.

4. **Repository Naming**: Use consistent naming conventions for your repositories.

5. **Private Repositories**: Remember to specify `true` for private repositories when creating them.

## Troubleshooting

### Common Issues

**Account Not Persisting:**
- Account is stored as session variable
- Add to shell profile for persistence across sessions

**Repository Creation Fails:**
- Ensure GitHub CLI (`gh`) is installed and authenticated
- Check repository name doesn't already exist
- Verify GitHub account permissions

**Auto-Detection Not Working:**
- Ensure GitHub account is set: `caddie github:account:get`
- Check you're in a git repository directory
- Verify repository name matches GitHub repository name

### Getting Help

```bash
# Show all GitHub commands
caddie github:help

# Show general caddie help
caddie help

# Show git module help
caddie git:help
```

## Dependencies

The GitHub module requires:
- GitHub CLI (`gh`) for repository creation
- SSH keys configured with GitHub
- Git module for integration features
