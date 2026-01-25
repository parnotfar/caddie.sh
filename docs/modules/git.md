# Git Module

The Git module provides enhanced git workflows and shortcuts for efficient repository management.

## Overview

The Git module (`caddie git:<command>`) offers streamlined git operations with smart defaults and GitHub integration. It automatically uses SSH URLs for better security and convenience.

## Commands

### Basic Git Operations

#### `caddie git:status`
Show git status with enhanced formatting.

```bash
caddie git:status
```

#### `caddie git:branch`
Show current branch and all available branches.

```bash
caddie git:branch
```

#### `caddie git:commit <message>`
Add all changes and commit with the specified message.

```bash
caddie git:commit "Add new feature"
caddie git:commit "Fix bug in user authentication"
```

#### `caddie git:gacp <message>`
Add all changes, commit, and push in one command. This is a wrapper for the common workflow of adding, committing, and pushing changes.

```bash
caddie git:gacp "Quick commit and push"
caddie git:gacp "Update documentation"
```

#### `caddie git:push`
Push changes to the remote repository.

```bash
caddie git:push
```

#### `caddie git:pull`
Pull changes from the remote repository.

```bash
caddie git:pull
```

#### `caddie git:merge:main [remote]`
Merge the mainline branch from the remote into the current branch without checking it out (worktree-friendly).

```bash
caddie git:merge:main
caddie git:merge:main upstream
```

Tip: If you previously used the `gmm` alias, use `caddie git:merge:main` instead.

### Advanced Git Operations

#### `caddie git:push:set:upstream [<remote>] [<branch>]`
Set upstream branch for new repositories. Defaults to `origin` remote and `main` branch.

```bash
# Set upstream to origin/main (default)
caddie git:push:set:upstream

# Set upstream to origin/master
caddie git:push:set:upstream origin master

# Set upstream to upstream/develop
caddie git:push:set:upstream upstream develop
```

#### `caddie git:clone <repo-name>`
Clone a repository using the stored GitHub account. Constructs SSH URL automatically.

```bash
# Clone a repository (requires GitHub account to be set)
caddie git:clone my-awesome-project
```

#### `caddie git:pr:create [title] [body] [base]`
Create a pull request using GitHub CLI. Auto-generates content if not provided.

```bash
# Create PR with auto-generated title and body
caddie git:pr:create

# Create PR with custom title and body
caddie git:pr:create "Add new feature" "Implements user authentication with OAuth2"

# Create PR targeting specific base branch
caddie git:pr:create "Fix bug" "Resolves login timeout issue" develop
```

**Prerequisites:**
- GitHub account must be set: `caddie github:account:set <account>`

### Worktrees (Multi-Agent Workflow)

Use git worktrees to isolate parallel work across agents or branches.

#### `caddie git:worktree:list`
List all worktrees.

```bash
caddie git:worktree:list
```

#### `caddie git:worktree:add <path> <branch> [--new]`
Add a worktree at the given path for an existing branch. Use `--new` to create a new branch.

```bash
caddie git:worktree:add ../vcaddie-swift-analytics feature/analytics
caddie git:worktree:add ../vcaddie-swift-analytics feature/analytics --new
```

#### `caddie git:worktree:remove <path>`
Remove a worktree by path. When no path is provided, caddie lists removable worktrees.

```bash
caddie git:worktree:remove ../vcaddie-swift-analytics
```

#### `caddie git:worktree:lock <path>` / `caddie git:worktree:unlock <path>`
Lock or unlock a worktree to prevent accidental removal.

```bash
caddie git:worktree:lock ../vcaddie-swift-analytics
caddie git:worktree:unlock ../vcaddie-swift-analytics
```

#### `caddie git:worktree:cd <path>`
Change directory into a worktree path (works because `caddie` runs in the current shell).

```bash
caddie git:worktree:cd ../vcaddie-swift-analytics
```

#### `caddie git:worktree:prune`
Remove stale worktree metadata.

```bash
caddie git:worktree:prune
```

**Tab completion:** Worktree commands support tab completion for paths. For example, `git:worktree:remove`, `git:worktree:lock`, `git:worktree:unlock`, and `git:worktree:cd` will suggest valid worktree paths.

### Remote Management

#### `caddie git:remote:add [<name> <url>]`
Add a remote repository. Auto-detects repository name and uses stored GitHub account if no arguments provided.

```bash
# Auto-detect repository and GitHub account
caddie git:remote:add

# Manually specify remote name and URL
caddie git:remote:add upstream https://github.com/other/repo.git
```

#### `caddie git:remote:set-url <name> <url>`
Set the URL for an existing remote.

```bash
caddie git:remote:set-url origin git@github.com:newaccount/repo.git
```

#### `caddie git:remote:list`
List all configured remotes with their URLs.

```bash
caddie git:remote:list
```

#### `caddie git:remote:remove [<name>]`
Remove a remote repository. Defaults to `origin` if no name provided.

```bash
# Remove origin remote (default)
caddie git:remote:remove

# Remove specific remote
caddie git:remote:remove upstream
```

## GitHub Integration

The Git module integrates seamlessly with the GitHub module for streamlined workflows.

### Setup GitHub Account

```bash
# Set your GitHub account
caddie github:account:set parnotfar

# Verify account is set
caddie github:account:get
```

### Complete Workflow Example

```bash
# 1. Set up GitHub account
caddie github:account:set parnotfar

# 2. Clone a new repository
caddie git:clone my-new-project
cd my-new-project

# 3. Make changes and commit
echo "# My New Project" > README.md
caddie git:gacp "Initial commit"

# 4. Future changes are simple
caddie git:gacp "Add new feature"

# 5. Create pull requests
caddie git:pr:create "Add new feature" "Description of changes"
```

## SSH vs HTTPS

The Git module uses SSH URLs (`git@github.com:`) by default for:

- **Security**: Uses SSH keys instead of passwords/tokens
- **Convenience**: No need to enter credentials repeatedly
- **Speed**: Faster authentication
- **Best Practice**: Standard for development workflows

## Error Handling

The module provides helpful error messages for common issues:

```bash
# Missing GitHub account
caddie git:clone my-project
# Error: No GitHub account set. Use 'caddie github:account:set <account>' first

# Missing repository name
caddie git:clone
# Error: Please provide repository name
# Usage: caddie git:clone <repo-name>
```

## Tips and Best Practices

1. **Set GitHub Account Early**: Run `caddie github:account:set <account>` once to enable auto-detection features.

2. **Use Auto-Detection**: `caddie git:remote:add` with no arguments automatically detects repository name and GitHub account.

3. **SSH Key Setup**: Ensure your SSH keys are configured with GitHub for seamless operation.

4. **Branch Naming**: The module defaults to `main` branch for new repositories, following modern Git conventions.

5. **Workflow Integration**: Combine with other modules for complete project setup:
   ```bash
   caddie rust:init my-project
   caddie git:remote:add
   caddie git:commit "Initial Rust project"
   caddie git:push:set:upstream
   ```

## Troubleshooting

### Common Issues

**SSH Authentication Errors:**
- Ensure SSH keys are added to GitHub
- Test with: `ssh -T git@github.com`

**Repository Not Found:**
- Verify GitHub account is set correctly
- Check repository name spelling
- Ensure repository exists on GitHub

**Permission Denied:**
- Verify SSH key permissions
- Check repository access permissions

### Getting Help

```bash
# Show all git commands
caddie git:help

# Show general caddie help
caddie help

# Show GitHub module help
caddie github:help
```
