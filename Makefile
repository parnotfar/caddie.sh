# Caddie.sh Installation Makefile
# This Makefile handles the installation of the caddie application
# including dot file setup, Homebrew, Python venv, Rust, and Ruby build dependencies installation

# Colors for output
RED := \033[0;31m
GREEN := \033[0;32m
YELLOW := \033[0;33m
BLUE := \033[0;34m
PURPLE := \033[0;35m
CYAN := \033[0;36m
WHITE := \033[0;37m
NC := \033[0m # No Color

# Default target
.PHONY: all install help pull-if-main
.DEFAULT_GOAL := help
.SILENT:

# Variables
HOME_DIR := $(HOME)
CADDIE_DIR := $(shell pwd)
SRC_MODULES_DIR := $(CADDIE_DIR)/modules
DEST_MODULES_DIR := $(HOME_DIR)/.caddie_modules

help: ## Show this help message
	echo "$(CYAN)Caddie.sh Installation Makefile$(NC)"
	echo "$(YELLOW)================================$(NC)"
	echo ""
	echo "$(GREEN)Available targets:$(NC)"
	awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  $(CYAN)%-20s$(NC) %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	echo ""
	echo "$(YELLOW)Usage:$(NC)"
	echo "  make install        - Full installation (recommended)"
	echo "  make install-dot    - Dot files/modules only (caddie development)"
	echo "  make setup-dev      - Setup development environment (Homebrew, Python, Rust, Ruby deps, GitHub CLI)"
	echo "  make setup-github   - Setup GitHub CLI only"
	echo "  make backup-existing - Backup existing bash files only"
	echo "  make restore-backup - Restore from backup files"
	echo "  make status         - Check installation status"
	echo "  make uninstall      - Remove caddie files (keeps backups)"
	echo ""
	echo "$(CYAN)Safety Features:$(NC)"
	echo "  • Automatically backs up existing .bash_profile and .bashrc"
	echo "  • Backups stored as .caddie-backup files (e.g., .bash_profile.caddie-backup)"
	echo "  • Easy restore with 'make restore-backup'"
	echo ""
	echo "$(CYAN)Directory Structure:$(NC)"
	echo "  • Source modules: $(SRC_MODULES_DIR)"
	echo "  • Destination modules: $(DEST_MODULES_DIR)"

all: install ## Alias for install

pull-if-main: ## Pull origin/main when the current branch is main
	echo "$(BLUE)🔄$(NC) Checking for caddie.sh updates..."
	if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then \
		echo "$(YELLOW)  →$(NC) Not a git repository; skipping git pull"; \
	elif [ "$$(git branch --show-current 2>/dev/null)" != "main" ]; then \
		echo "$(YELLOW)  →$(NC) Not on main (current: $$(git branch --show-current 2>/dev/null || echo unknown)); skipping git pull"; \
	else \
		echo "$(YELLOW)  →$(NC) On main; pulling latest from origin..."; \
		if git pull --ff-only origin main; then \
			echo "$(GREEN)    ✓$(NC) Repository updated"; \
		else \
			echo "$(YELLOW)    →$(NC) git pull skipped (local changes or non-fast-forward); installing from current tree"; \
		fi; \
	fi

install: pull-if-main check-prerequisites install-dot setup-dev ## Complete installation of caddie.sh
	@echo "$(GREEN)✓$(NC) Installation complete! Run 'source ~/.bash_profile' to activate."

check-prerequisites: ## Check system prerequisites
	echo "$(BLUE)🔍$(NC) Checking system prerequisites..."
	if [ "$$(uname -s)" != "Darwin" ]; then \
		echo "$(RED)✗$(NC) This installer is designed for macOS (Darwin)"; \
		exit 1; \
	fi
	echo "$(GREEN)✓$(NC) macOS detected"
	echo "$(GREEN)✓$(NC) Prerequisites check passed"

backup-existing: check-prerequisites ## Backup existing bash configuration files
	echo "$(BLUE)💾$(NC) Backing up existing configuration files..."
	for file in .bash_profile .bashrc; do \
		if [ -f "$(HOME_DIR)/$$file" ]; then \
			backup_file="$(HOME_DIR)/$$file.caddie-backup"; \
			echo "$(YELLOW)  →$(NC) Backing up ~/$$file to ~/$$file.caddie-backup"; \
			cp "$(HOME_DIR)/$$file" "$$backup_file"; \
			echo "$(GREEN)    ✓$(NC) Successfully backed up ~/$$file"; \
		else \
			echo "$(YELLOW)  →$(NC) ~/$$file not found (no backup needed)"; \
		fi; \
	done
	echo "$(GREEN)✓$(NC) Backup completed"

install-dot: backup-existing ## Install dot files to home directory
	echo "$(BLUE)📁$(NC) Installing dot files to home directory..."
	
	echo "$(YELLOW)  →$(NC) Installing dot_bash_profile as ~/.bash_profile"
	cp dot_bash_profile "$(HOME_DIR)/.bash_profile"
	echo "$(GREEN)    ✓$(NC) Successfully installed ~/.bash_profile"
	
	echo "$(YELLOW)  →$(NC) Installing dot_bashrc as ~/.bashrc"
	cp dot_bashrc "$(HOME_DIR)/.bashrc"
	echo "$(GREEN)    ✓$(NC) Successfully installed ~/.bashrc"
	
	echo "$(YELLOW)  →$(NC) Installing dot_caddie_prompt as ~/.caddie_prompt.sh"
	cp dot_caddie_prompt "$(HOME_DIR)/.caddie_prompt.sh"
	echo "$(GREEN)    ✓$(NC) Successfully installed ~/.caddie_prompt.sh"
	
	echo "$(YELLOW)  →$(NC) Installing dot_caddie_cli as ~/.caddie_cli"
	cp "$(SRC_MODULES_DIR)/dot_caddie_cli" "$(HOME_DIR)/.caddie_cli"
	echo "$(GREEN)    ✓$(NC) Successfully installed ~/.caddie_cli"
	
	echo "$(YELLOW)  →$(NC) Installing dot_caddie_version as ~/.caddie_version"
	cp dot_caddie_version "$(HOME_DIR)/.caddie_version"
	echo "$(GREEN)    ✓$(NC) Successfully installed ~/.caddie_version"
	
	echo "$(YELLOW)  →$(NC) Installing caddie data structure files..."
	mkdir -p "$(HOME_DIR)/.caddie_data"
	echo "$(GREEN)    ✓$(NC) ~/.caddie_data directory ready"
	cp dot_caddie_modules "$(HOME_DIR)/.caddie_data/.caddie_modules"
	echo "$(GREEN)    ✓$(NC) Successfully installed ~/.caddie_data/.caddie_modules"
	
	echo "$(YELLOW)  →$(NC) Installing modular caddie files..."
	mkdir -p "$(DEST_MODULES_DIR)"
	echo "$(GREEN)    ✓$(NC) ~/.caddie_modules directory ready"

	cp "$(SRC_MODULES_DIR)/dot_caddie_core" "$(DEST_MODULES_DIR)/.caddie_core"
	echo "$(GREEN)    ✓$(NC) Successfully installed $(DEST_MODULES_DIR)/.caddie_core"
	cp "$(SRC_MODULES_DIR)/dot_caddie_python" "$(DEST_MODULES_DIR)/.caddie_python"
	echo "$(GREEN)    ✓$(NC) Successfully installed $(DEST_MODULES_DIR)/.caddie_python"
	cp "$(SRC_MODULES_DIR)/dot_caddie_rust" "$(DEST_MODULES_DIR)/.caddie_rust"
	echo "$(GREEN)    ✓$(NC) Successfully installed $(DEST_MODULES_DIR)/.caddie_rust"
	cp "$(SRC_MODULES_DIR)/dot_caddie_ios" "$(DEST_MODULES_DIR)/.caddie_ios"
	echo "$(GREEN)    ✓$(NC) Successfully installed $(DEST_MODULES_DIR)/.caddie_ios"
	cp "$(SRC_MODULES_DIR)/dot_caddie_cross" "$(DEST_MODULES_DIR)/.caddie_cross"
	echo "$(GREEN)    ✓$(NC) Successfully installed $(DEST_MODULES_DIR)/.caddie_cross"
	cp "$(SRC_MODULES_DIR)/dot_caddie_mcp" "$(DEST_MODULES_DIR)/.caddie_mcp"
	echo "$(GREEN)    ✓$(NC) Successfully installed $(DEST_MODULES_DIR)/.caddie_mcp"
	cp "$(SRC_MODULES_DIR)/dot_caddie_cursor" "$(DEST_MODULES_DIR)/.caddie_cursor"
	echo "$(GREEN)    ✓$(NC) Successfully installed $(DEST_MODULES_DIR)/.caddie_cursor"
	cp "$(SRC_MODULES_DIR)/dot_caddie_mac" "$(DEST_MODULES_DIR)/.caddie_mac"
	echo "$(GREEN)    ✓$(NC) Successfully installed $(DEST_MODULES_DIR)/.caddie_mac"
	cp "$(SRC_MODULES_DIR)/dot_caddie_system" "$(DEST_MODULES_DIR)/.caddie_system"
	echo "$(GREEN)    ✓$(NC) Successfully installed $(DEST_MODULES_DIR)/.caddie_system"
	cp "$(SRC_MODULES_DIR)/dot_caddie_homebrew" "$(DEST_MODULES_DIR)/.caddie_homebrew"
	echo "$(GREEN)    ✓$(NC) Successfully installed $(DEST_MODULES_DIR)/.caddie_homebrew"
	cp "$(SRC_MODULES_DIR)/dot_caddie_ruby" "$(DEST_MODULES_DIR)/.caddie_ruby"
	echo "$(GREEN)    ✓$(NC) Successfully installed $(DEST_MODULES_DIR)/.caddie_ruby"
	cp "$(SRC_MODULES_DIR)/dot_caddie_js" "$(DEST_MODULES_DIR)/.caddie_js"
	echo "$(GREEN)    ✓$(NC) Successfully installed $(DEST_MODULES_DIR)/.caddie_js"
	echo "$(YELLOW)  →$(NC) Git workflows are now the optional caddie-git-tools plugin"
	echo "$(CYAN)    💡$(NC) Install from that repo with $(YELLOW)make install$(NC), then $(YELLOW)caddie git:prompt:on$(NC) per repository"
	cp "$(SRC_MODULES_DIR)/dot_caddie_github" "$(DEST_MODULES_DIR)/.caddie_github"
	echo "$(GREEN)    ✓$(NC) Successfully installed $(DEST_MODULES_DIR)/.caddie_github"
	cp "$(SRC_MODULES_DIR)/dot_caddie_swift" "$(DEST_MODULES_DIR)/.caddie_swift"
	echo "$(GREEN)    ✓$(NC) Successfully installed $(DEST_MODULES_DIR)/.caddie_swift"
	cp "$(SRC_MODULES_DIR)/dot_caddie_codex" "$(DEST_MODULES_DIR)/.caddie_codex"
	echo "$(GREEN)    ✓$(NC) Successfully installed $(DEST_MODULES_DIR)/.caddie_codex"
	cp "$(SRC_MODULES_DIR)/dot_caddie_claude" "$(DEST_MODULES_DIR)/.caddie_claude"
	echo "$(GREEN)    ✓$(NC) Successfully installed $(DEST_MODULES_DIR)/.caddie_claude"
	cp "$(SRC_MODULES_DIR)/dot_caddie_doc" "$(DEST_MODULES_DIR)/.caddie_doc"
	echo "$(GREEN)    ✓$(NC) Successfully installed $(DEST_MODULES_DIR)/.caddie_doc"
	cp "$(SRC_MODULES_DIR)/dot_caddie_cli" "$(DEST_MODULES_DIR)/.caddie_cli"
	echo "$(GREEN)    ✓$(NC) Successfully installed $(DEST_MODULES_DIR)/.caddie_cli"
	cp "$(SRC_MODULES_DIR)/dot_caddie_debug" "$(DEST_MODULES_DIR)/.caddie_debug"
	echo "$(GREEN)    ✓$(NC) Successfully installed $(DEST_MODULES_DIR)/.caddie_debug"
	cp "$(SRC_MODULES_DIR)/dot_caddie_profile" "$(DEST_MODULES_DIR)/.caddie_profile"
	echo "$(GREEN)    ✓$(NC) Successfully installed $(DEST_MODULES_DIR)/.caddie_profile"
	cp "$(SRC_MODULES_DIR)/dot_caddie_skill" "$(DEST_MODULES_DIR)/.caddie_skill"
	echo "$(GREEN)    ✓$(NC) Successfully installed $(DEST_MODULES_DIR)/.caddie_skill"
	echo "$(YELLOW)  →$(NC) Installing caddie agent skill (canonical)..."
	mkdir -p "$(DEST_MODULES_DIR)/skills"
	rm -rf "$(DEST_MODULES_DIR)/skills/caddie"
	cp -R skills/caddie "$(DEST_MODULES_DIR)/skills/caddie"
	echo "$(GREEN)    ✓$(NC) Successfully installed $(DEST_MODULES_DIR)/skills/caddie"
	echo "$(YELLOW)  →$(NC) Installing caddie binary scripts..."
	mkdir -p "$(DEST_MODULES_DIR)/bin"
	if [ -d "$(CADDIE_DIR)/bin" ]; then \
		cp "$(CADDIE_DIR)/bin"/* "$(DEST_MODULES_DIR)/bin/" 2>/dev/null || true; \
		chmod +x "$(DEST_MODULES_DIR)/bin/"* 2>/dev/null || true; \
		echo "$(GREEN)    ✓$(NC) Successfully installed scripts to $(DEST_MODULES_DIR)/bin"; \
	fi
	mkdir -p "$(HOME_DIR)/bin"
	if [ -f "$(CADDIE_DIR)/bin/caddie" ]; then \
		cp "$(CADDIE_DIR)/bin/caddie" "$(HOME_DIR)/bin/caddie"; \
		chmod +x "$(HOME_DIR)/bin/caddie"; \
		echo "$(GREEN)    ✓$(NC) Successfully installed ~/bin/caddie"; \
	fi
	echo "$(YELLOW)  →$(NC) Installing main caddie entry point as ~/.caddie.sh"
	cp dot_caddie "$(HOME_DIR)/.caddie.sh"
	echo "$(GREEN)    ✓$(NC) Successfully installed ~/.caddie.sh"
	
	echo "$(GREEN)✓$(NC) All dot files installed successfully"

setup-dev: setup-homebrew setup-python setup-rust setup-ruby-deps setup-github ## Setup development environment (Homebrew, Python, Rust, Ruby build deps, GitHub CLI)
	echo "$(GREEN)✓$(NC) Development environment setup completed"

setup-homebrew: ## Install and update Homebrew
	echo "$(BLUE)🍺$(NC) Setting up Homebrew..."
	if ! command -v brew >/dev/null 2>&1; then \
		echo "$(YELLOW)  →$(NC) Homebrew not found, installing..."; \
		/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; \
		echo "$(GREEN)    ✓$(NC) Homebrew installed successfully"; \
	else \
		echo "$(GREEN)  ✓$(NC) Homebrew already installed"; \
	fi
	echo "$(YELLOW)  →$(NC) Updating Homebrew..."
	brew update
	echo "$(GREEN)    ✓$(NC) Homebrew updated successfully"
	echo "$(YELLOW)  →$(NC) Upgrading existing packages..."
	brew upgrade
	echo "$(GREEN)    ✓$(NC) Homebrew packages upgraded"
	echo "$(GREEN)✓$(NC) Homebrew setup completed"

setup-python: setup-homebrew ## Setup Python with virtual environment support
	echo "$(BLUE)🐍$(NC) Setting up Python development environment..."
	if ! command -v python3 >/dev/null 2>&1; then \
		echo "$(YELLOW)  →$(NC) Python3 not found, installing via Homebrew..."; \
		brew install python; \
		echo "$(GREEN)    ✓$(NC) Python3 installed successfully"; \
	else \
		echo "$(GREEN)  ✓$(NC) Python3 already installed"; \
	fi
	echo "$(YELLOW)  →$(NC) Checking Python version..."
	python3 --version
	echo "$(YELLOW)  →$(NC) Checking pip availability..."
	if python3 -m pip --version >/dev/null 2>&1; then \
		echo "$(GREEN)    ✓$(NC) pip is available"; \
	else \
		echo "$(YELLOW)  →$(NC) Installing pip via Homebrew..."; \
		brew install python-pip; \
		echo "$(GREEN)    ✓$(NC) pip installed via Homebrew"; \
	fi
	echo "$(YELLOW)  →$(NC) Installing virtualenv via Homebrew..."
	brew install virtualenv
	echo "$(GREEN)    ✓$(NC) virtualenv installed via Homebrew"
	echo "$(YELLOW)  →$(NC) Creating global virtual environment directory..."
	mkdir -p "$(HOME_DIR)/.virtualenvs"
	echo "$(GREEN)✓$(NC) Python development environment setup completed"
	echo "$(CYAN)  💡$(NC) To create a new virtual environment: $(YELLOW)python3 -m venv ~/.virtualenvs/myproject$(NC)"
	echo "$(CYAN)  💡$(NC) To activate a virtual environment: $(YELLOW)source ~/.virtualenvs/myproject/bin/activate$(NC)"
	echo "$(CYAN)  💡$(NC) For system packages, use: $(YELLOW)brew install python-xyz$(NC)"

setup-rust: setup-homebrew ## Setup Rust development environment
	echo "$(BLUE)🦀$(NC) Setting up Rust development environment..."
	if ! command -v rustc >/dev/null 2>&1; then \
		echo "$(YELLOW)  →$(NC) Rust not found, installing via rustup..."; \
		curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y; \
		echo "$(GREEN)    ✓$(NC) Rust installed successfully"; \
	else \
		echo "$(GREEN)  ✓$(NC) Rust already installed"; \
	fi
	echo "$(YELLOW)  →$(NC) Sourcing Rust environment..."
	if [ -f "$(HOME_DIR)/.cargo/env" ]; then \
		. "$(HOME_DIR)/.cargo/env"; \
		echo "$(GREEN)    ✓$(NC) Rust environment sourced"; \
	else \
		echo "$(YELLOW)    ⚠$(NC) Rust environment file not found, trying to source from PATH"; \
	fi
	echo "$(YELLOW)  →$(NC) Checking Rust version..."
	rustc --version
	echo "$(YELLOW)  →$(NC) Updating Rust toolchain..."
	rustup update
	echo "$(GREEN)✓$(NC) Rust development environment setup completed"
	echo "$(CYAN)  💡$(NC) Rust will be available after restarting your terminal"
	echo "$(CYAN)  💡$(NC) To create a new Rust project: $(YELLOW)cargo new myproject$(NC)"

setup-ruby-deps: setup-homebrew ## Install Ruby build dependencies (OpenSSL, readline, libyaml, etc.)
	echo "$(BLUE)💎$(NC) Installing Ruby build dependencies..."
	echo "$(YELLOW)  →$(NC) Installing OpenSSL (required for Ruby compilation)..."
	brew install openssl@3 || brew install openssl || true
	echo "$(GREEN)    ✓$(NC) OpenSSL installed"
	echo "$(YELLOW)  →$(NC) Installing readline (required for Ruby)..."
	brew install readline || true
	echo "$(GREEN)    ✓$(NC) readline installed"
	echo "$(YELLOW)  →$(NC) Installing libyaml (required for Ruby YAML support)..."
	brew install libyaml || true
	echo "$(GREEN)    ✓$(NC) libyaml installed"
	echo "$(YELLOW)  →$(NC) Installing gmp (required for Ruby)..."
	brew install gmp || true
	echo "$(GREEN)    ✓$(NC) gmp installed"
	echo "$(YELLOW)  →$(NC) Installing autoconf (required for Ruby compilation)..."
	brew install autoconf || true
	echo "$(GREEN)    ✓$(NC) autoconf installed"
	echo "$(YELLOW)  →$(NC) Installing automake (required for Ruby compilation)..."
	brew install automake || true
	echo "$(GREEN)    ✓$(NC) automake installed"
	echo "$(YELLOW)  →$(NC) Installing libtool (required for Ruby compilation)..."
	brew install libtool || true
	echo "$(GREEN)    ✓$(NC) libtool installed"
	echo "$(YELLOW)  →$(NC) Installing pkg-config (required for Ruby compilation)..."
	brew install pkg-config || true
	echo "$(GREEN)    ✓$(NC) pkg-config installed"
	echo "$(GREEN)✓$(NC) Ruby build dependencies installed"
	echo "$(CYAN)  💡$(NC) These packages are required for compiling Ruby from source"
	echo "$(CYAN)  💡$(NC) To setup Ruby: $(YELLOW)caddie ruby:setup$(NC)"

setup-github: setup-homebrew ## Setup GitHub CLI for pull request management
	echo "$(BLUE)🐙$(NC) Setting up GitHub CLI..."
	if ! command -v gh >/dev/null 2>&1; then \
		echo "$(YELLOW)  →$(NC) GitHub CLI not found, installing via Homebrew..."; \
		brew install gh; \
		echo "$(GREEN)    ✓$(NC) GitHub CLI installed successfully"; \
	else \
		echo "$(GREEN)  ✓$(NC) GitHub CLI already installed"; \
	fi
	echo "$(YELLOW)  →$(NC) Checking GitHub CLI version..."
	gh --version
	echo "$(GREEN)✓$(NC) GitHub CLI setup completed"
	echo "$(CYAN)  💡$(NC) To authenticate with GitHub: $(YELLOW)gh auth login$(NC)"
	echo "$(CYAN)  💡$(NC) Git workflows live in caddie-git-tools: $(YELLOW)make install$(NC) there, then $(YELLOW)caddie git:prompt:on$(NC)"

uninstall: ## Remove installed dot files (does not remove Homebrew, Python, or Rust)
	echo "$(BLUE)🗑️$(NC) Uninstalling caddie.sh dot files..."
	
	echo "$(YELLOW)  →$(NC) Removing ~/.bash_profile"
	if [ -f "$(HOME_DIR)/.bash_profile" ]; then \
		rm "$(HOME_DIR)/.bash_profile"; \
		echo "$(GREEN)    ✓$(NC) Successfully removed ~/.bash_profile"; \
	else \
		echo "$(YELLOW)    →$(NC) ~/.bash_profile not found (already removed)"; \
	fi
	
	echo "$(YELLOW)  →$(NC) Removing ~/.bashrc"
	if [ -f "$(HOME_DIR)/.bashrc" ]; then \
		rm "$(HOME_DIR)/.bashrc"; \
		echo "$(GREEN)    ✓$(NC) Successfully removed ~/.bashrc"; \
	else \
		echo "$(YELLOW)    →$(NC) ~/.bashrc not found (already removed)"; \
	fi
	
	echo "$(YELLOW)  →$(NC) Removing ~/.caddie_prompt.sh"
	if [ -f "$(HOME_DIR)/.caddie_prompt.sh" ]; then \
		rm "$(HOME_DIR)/.caddie_prompt.sh"; \
		echo "$(GREEN)    ✓$(NC) Successfully removed ~/.caddie_prompt.sh"; \
	else \
		echo "$(YELLOW)    →$(NC) ~/.caddie_prompt.sh not found (already removed)"; \
	fi
	
	echo "$(YELLOW)  →$(NC) Removing ~/.caddie_cli"
	if [ -f "$(HOME_DIR)/.caddie_cli" ]; then \
		rm "$(HOME_DIR)/.caddie_cli"; \
		echo "$(GREEN)    ✓$(NC) Successfully removed ~/.caddie_cli"; \
	else \
		echo "$(YELLOW)    →$(NC) ~/.caddie_cli not found (already removed)"; \
	fi
	
	echo "$(YELLOW)  →$(NC) Removing ~/.caddie_git"
	if [ -f "$(HOME_DIR)/.caddie_git" ]; then \
		rm "$(HOME_DIR)/.caddie_git"; \
		echo "$(GREEN)    ✓$(NC) Successfully removed ~/.caddie_git"; \
	else \
		echo "$(YELLOW)    →$(NC) ~/.caddie_git not found (already removed)"; \
	fi
	
	echo "$(YELLOW)  →$(NC) Removing caddie data structure files..."
	if [ -d "$(HOME_DIR)/.caddie_data" ]; then \
		rm -rf "$(HOME_DIR)/.caddie_data"; \
		echo "$(GREEN)    ✓$(NC) Successfully removed ~/.caddie_data directory"; \
	else \
		echo "$(YELLOW)    →$(NC) ~/.caddie_data directory not found (already removed)"; \
	fi
	
	echo "$(YELLOW)  →$(NC) Removing ~/.caddie_version"
	if [ -f "$(HOME_DIR)/.caddie_version" ]; then \
		rm "$(HOME_DIR)/.caddie_version"; \
		echo "$(GREEN)    ✓$(NC) Successfully removed ~/.caddie_version"; \
	else \
		echo "$(YELLOW)    →$(NC) ~/.caddie_version not found (already removed)"; \
	fi
	
	echo "$(YELLOW)  →$(NC) Removing modular caddie files..."
	if [ -d "$(DEST_MODULES_DIR)" ]; then \
		rm -rf "$(DEST_MODULES_DIR)"; \
		echo "$(GREEN)    ✓$(NC) Successfully removed ~/.caddie_modules directory"; \
	else \
		echo "$(YELLOW)    →$(NC) ~/.caddie_modules directory not found (already removed)"; \
	fi
	
	echo "$(YELLOW)  →$(NC) Removing ~/.caddie.sh"
	if [ -f "$(HOME_DIR)/.caddie.sh" ]; then \
		rm "$(HOME_DIR)/.caddie.sh"; \
		echo "$(GREEN)    ✓$(NC) Successfully removed ~/.caddie.sh"; \
	else \
		echo "$(YELLOW)    →$(NC) ~/.caddie.sh not found (already removed)"; \
	fi
	
	echo "$(GREEN)✓$(NC) Uninstallation completed"
	echo "$(YELLOW)⚠$(NC) Note: Homebrew, Python, and Rust installations were not removed"
	echo "$(CYAN)💡$(NC) Your original files are still backed up as .caddie-backup files"

restore-backup: ## Restore from backup files
	echo "$(BLUE)🔄$(NC) Restoring from backup files..."
	restored_count=0
	for file in .bash_profile .bashrc; do \
		backup_file="$(HOME_DIR)/$$file.caddie-backup"; \
		if [ -f "$$backup_file" ]; then \
			echo "$(YELLOW)  →$(NC) Restoring ~/$$file from ~/$$file.caddie-backup"; \
			cp "$$backup_file" "$(HOME_DIR)/$$file"; \
			echo "$(GREEN)    ✓$(NC) Successfully restored ~/$$file"; \
			restored_count=$$((restored_count + 1)); \
		else \
			echo "$(YELLOW)  →$(NC) No backup found for ~/$$file"; \
		fi; \
	done
	if [ $$restored_count -eq 0 ]; then \
		echo "$(RED)✗$(NC) No backup files found to restore"; \
		exit 1; \
	fi
	echo "$(GREEN)✓$(NC) Restore completed"

status: ## Check installation status
	echo "$(BLUE)📊$(NC) Checking caddie.sh installation status..."
	echo ""
	echo "$(CYAN)Dot Files:$(NC)"
	if [ -f "$(HOME_DIR)/.bash_profile" ]; then \
		echo "$(GREEN)  ✓$(NC) ~/.bash_profile"; \
	else \
		echo "$(RED)  ✗$(NC) ~/.bash_profile"; \
	fi
	if [ -f "$(HOME_DIR)/.bashrc" ]; then \
		echo "$(GREEN)  ✓$(NC) ~/.bashrc"; \
	else \
		echo "$(RED)  ✗$(NC) ~/.bashrc"; \
	fi
	if [ -f "$(HOME_DIR)/.caddie_prompt.sh" ]; then \
		echo "$(GREEN)  ✓$(NC) ~/.caddie_prompt.sh"; \
	else \
		echo "$(RED)  ✗$(NC) ~/.caddie_prompt.sh"; \
	fi
	if [ -f "$(HOME_DIR)/.caddie_cli" ]; then \
		echo "$(GREEN)  ✓$(NC) ~/.caddie_cli"; \
	else \
		echo "$(RED)  ✗$(NC) ~/.caddie_cli"; \
	fi
	if [ -f "$(HOME_DIR)/.caddie_version" ]; then \
		echo "$(GREEN)  ✓$(NC) ~/.caddie_version"; \
	else \
		echo "$(RED)  ✗$(NC) ~/.caddie_version"; \
	fi
	if [ -f "$(HOME_DIR)/.caddie_git" ]; then \
		echo "$(GREEN)  ✓$(NC) ~/.caddie_git"; \
	else \
		echo "$(RED)  ✗$(NC) ~/.caddie_git"; \
	fi
	echo "$(CYAN)Caddie Data Structures:$(NC)"
	if [ -d "$(HOME_DIR)/.caddie_data" ]; then \
		echo "$(GREEN)  ✓$(NC) ~/.caddie_data directory"; \
		for data_file in modules; do \
			if [ -f "$(HOME_DIR)/.caddie_data/.caddie_$$data_file" ]; then \
				echo "$(GREEN)    ✓$(NC) ~/.caddie_data/.caddie_$$data_file"; \
			else \
				echo "$(RED)    ✗$(NC) ~/.caddie_data/.caddie_$$data_file"; \
			fi; \
		done; \
	else \
		echo "$(RED)  ✗$(NC) ~/.caddie_data directory"; \
	fi
	echo "$(CYAN)Caddie Modules:$(NC)"
	if [ -d "$(DEST_MODULES_DIR)" ]; then \
		echo "$(GREEN)  ✓$(NC) ~/.caddie_modules directory"; \
		for module in core python rust ios cross cursor ruby js git github cli; do \
			if [ -f "$(DEST_MODULES_DIR)/.caddie_$$module" ]; then \
				echo "$(GREEN)    ✓$(NC) ~/.caddie_modules/.caddie_$$module"; \
			else \
				echo "$(RED)    ✗$(NC) ~/.caddie_modules/.caddie_$$module"; \
			fi; \
		done; \
	else \
		echo "$(RED)  ✗$(NC) ~/.caddie_modules directory"; \
	fi
	if [ -f "$(HOME_DIR)/.caddie.sh" ]; then \
		echo "$(GREEN)  ✓$(NC) ~/.caddie.sh"; \
	else \
		echo "$(RED)  ✗$(NC) ~/.caddie.sh"; \
	fi
	echo ""
	echo "$(CYAN)Backups:$(NC)"
	backup_count=0
	for file in .bash_profile .bashrc; do \
		backup_file="$(HOME_DIR)/$$file.caddie-backup"; \
		if [ -f "$$backup_file" ]; then \
			echo "$(GREEN)  ✓$(NC) ~/$$file.caddie-backup"; \
			backup_count=$$((backup_count + 1)); \
		fi; \
	done
	if [ $$backup_count -eq 0 ]; then \
		echo "$(RED)  ✗$(NC) No backup files found"; \
	fi
	echo ""
	echo "$(CYAN)Development Tools:$(NC)"
	if command -v brew >/dev/null 2>&1; then \
		echo "$(GREEN)  ✓$(NC) Homebrew"; \
	else \
		echo "$(RED)  ✗$(NC) Homebrew"; \
	fi
	if command -v python3 >/dev/null 2>&1; then \
		echo "$(GREEN)  ✓$(NC) Python3"; \
	else \
		echo "$(RED)  ✗$(NC) Python3"; \
	fi
	if command -v rustc >/dev/null 2>&1; then \
		echo "$(GREEN)  ✓$(NC) Rust"; \
	else \
		echo "$(RED)  ✗$(NC) Rust"; \
	fi
	if command -v xcodebuild >/dev/null 2>&1; then \
		echo "$(GREEN)  ✓$(NC) Xcode"; \
	else \
		echo "$(RED)  ✗$(NC) Xcode"; \
	fi
	if command -v swift >/dev/null 2>&1; then \
		echo "$(GREEN)  ✓$(NC) Swift"; \
	else \
		echo "$(RED)  ✗$(NC) Swift"; \
	fi
	if command -v pod >/dev/null 2>&1; then \
		echo "$(GREEN)  ✓$(NC) CocoaPods"; \
	else \
		echo "$(RED)  ✗$(NC) CocoaPods"; \
	fi

clean: ## Clean up any temporary files (currently none)
	echo "$(BLUE)🧹$(NC) Cleaning up..."
	echo "$(GREEN)✓$(NC) No temporary files to clean"
