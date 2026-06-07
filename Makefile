# Default target
all: sync

# Recipes use bash-only features (process substitution, [[ ]], read -n).
SHELL := /bin/bash

REPO_ROOT := $(abspath $(CURDIR))

define ensure_safe_symlink
target="$(1)"; source="$(2)"; force_hint="$(3)"; \
if [ -L "$$target" ]; then \
	current="$$(readlink "$$target")"; \
	if [ "$$current" != "$$source" ]; then \
		echo "❌ $$target points to $$current"; \
		echo "   Expected: $$source"; \
		echo "   Remove it manually or run make $$force_hint"; \
		exit 1; \
	fi; \
elif [ -e "$$target" ]; then \
	echo "❌ $$target already exists and is not a symlink managed by this repo"; \
	echo "   Move it away manually or run make $$force_hint"; \
	exit 1; \
fi
endef

define remove_managed_path
target="$(1)"; source="$(2)"; \
if [ -L "$$target" ]; then \
	current="$$(readlink "$$target")"; \
	if [ "$$current" = "$$source" ]; then \
		rm -f "$$target"; \
	else \
		echo "⚠️  Skipping unmanaged symlink $$target -> $$current"; \
	fi; \
elif [ -e "$$target" ]; then \
	echo "⚠️  Skipping unmanaged path $$target"; \
fi
endef

# Shared prerequisite
require-stow:
	@command -v stow >/dev/null 2>&1 || { echo "❌ stow is not installed. Please install it first."; exit 1; }

# Install all dotfiles (removed automatic installation)
sync:
	@echo "⚠️  Please specify which configuration to install:"
	@echo "  make sync-ghostty       - Install Ghostty configuration"
	@echo "  make sync-ghostty-linux - Install Ghostty Linux configuration"
	@echo "  make sync-neovim        - Install Neovim configuration"
	@echo "  make sync-zsh           - Install Zsh configuration"
	@echo "  make sync-tig           - Install Tig configuration"
	@echo "  make sync-aerospace     - Install Aerospace configuration"

# Install Ghostty configuration
sync-ghostty: require-stow
	@echo "🖥️  Installing Ghostty configuration..."
	stow -t ~ ghostty
	@echo "✅ Ghostty configuration installed"

# Install Ghostty configuration (Linux specific)
sync-ghostty-linux: require-stow
	@echo "🐧 Installing Ghostty configuration for Linux..."
	@if [ -f ~/.config/ghostty/config ]; then \
		echo "  ~/.config/ghostty/config already exists, only installing custom.conf..."; \
		mkdir -p ~/.config/ghostty; \
		$(call ensure_safe_symlink,$${HOME}/.config/ghostty/custom.conf,$(REPO_ROOT)/ghostty-linux/.config/ghostty/custom.conf,sync-ghostty-linux-force); \
		ln -snf "$(REPO_ROOT)/ghostty-linux/.config/ghostty/custom.conf" "$${HOME}/.config/ghostty/custom.conf"; \
	else \
		echo "  ~/.config/ghostty/config does not exist, installing full configuration..."; \
		stow -t ~ ghostty-linux; \
	fi
	@echo "✅ Ghostty Linux configuration installed"

sync-ghostty-linux-force: require-stow
	@echo "🐧 Installing Ghostty configuration for Linux (force)..."
	@mkdir -p ~/.config/ghostty
	@rm -rf ~/.config/ghostty/custom.conf
	@$(MAKE) sync-ghostty-linux

# Install Neovim configuration
sync-neovim: require-stow
	@echo "📝 Installing Neovim configuration..."
	stow -t ~ nvim
	@echo "✅ Neovim configuration installed"

# Install Zsh configuration
sync-zsh: require-stow
	@echo "🐚 Installing Zsh configuration..."
	stow -t ~ zsh
	@echo "✅ Zsh configuration installed"

# Install Tig configuration
sync-tig: require-stow
	@echo "🔍 Installing Tig configuration..."
	stow -t ~ tig
	@echo "✅ Tig configuration installed"

# Install Aerospace configuration (includes Borders)
sync-aerospace: require-stow
	@echo "🚀 Installing Aerospace configuration..."
	stow -t ~ aerospace
	@echo "✅ Aerospace configuration installed"
	@echo "🔳 Installing Borders configuration..."
	stow -t ~ borders
	@echo "✅ Borders configuration installed"

# Remove all symlinks and configuration directories (with confirmation)
clean:
	@echo "⚠️  WARNING: This will remove all dotfile configurations!"
	@echo "  - ~/.config/nvim/"
	@echo "  - ~/.config/ghostty/config"
	@echo "  - ~/.config/aerospace/aerospace.toml"
	@echo "  - ~/.config/borders/bordersrc"
	@echo "  - ~/.tigrc"
	@echo "  - ~/.zshrc, ~/.p10k.zsh"
	@echo ""
	@read -p "Are you sure? [y/N] " -n 1 -r; \
	echo ""; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		$(MAKE) clean-force; \
	else \
		echo "❌ Clean cancelled"; \
	fi

# Force clean without confirmation (used by clean target)
clean-force:
	@echo "🧹 Removing all configurations..."
	@$(MAKE) clean-neovim
	@$(MAKE) clean-tig
	@$(MAKE) clean-zsh
	@$(MAKE) clean-ghostty
	@$(MAKE) clean-aerospace
	@echo "✅ All configurations removed"

# Individual clean targets
clean-ghostty:
	@echo "🧹 Removing Ghostty configuration..."
	@command -v stow >/dev/null 2>&1 && { stow -D -t ~ ghostty 2>/dev/null || stow -D -t ~ ghostty-linux 2>/dev/null; } || { $(call remove_managed_path,$${HOME}/.config/ghostty/config,$(REPO_ROOT)/ghostty/.config/ghostty/config); $(call remove_managed_path,$${HOME}/.config/ghostty/config,$(REPO_ROOT)/ghostty-linux/.config/ghostty/config); }
	@$(call remove_managed_path,$${HOME}/.config/ghostty/custom.conf,$(REPO_ROOT)/ghostty-linux/.config/ghostty/custom.conf)
	@echo "✅ Ghostty configuration removed"

clean-tig:
	@echo "🧹 Removing Tig configuration..."
	@command -v stow >/dev/null 2>&1 && stow -D -t ~ tig || { $(call remove_managed_path,$${HOME}/.tigrc,$(REPO_ROOT)/tig/.tigrc); }
	@echo "✅ Tig configuration removed"

clean-neovim:
	@echo "🧹 Removing Neovim configuration..."
	@command -v stow >/dev/null 2>&1 && stow -D -t ~ nvim || { $(call remove_managed_path,$${HOME}/.config/nvim,$(REPO_ROOT)/nvim/.config/nvim); }
	@echo "✅ Neovim configuration removed"

clean-zsh:
	@echo "🧹 Removing Zsh configuration..."
	@command -v stow >/dev/null 2>&1 && stow -D -t ~ zsh || { $(call remove_managed_path,$${HOME}/.zshrc,$(REPO_ROOT)/zsh/.zshrc); $(call remove_managed_path,$${HOME}/.p10k.zsh,$(REPO_ROOT)/zsh/.p10k.zsh); }
	@echo "✅ Zsh configuration removed"

clean-aerospace:
	@echo "🧹 Removing Aerospace configuration..."
	@command -v stow >/dev/null 2>&1 && { stow -D -t ~ aerospace; stow -D -t ~ borders; } || { $(call remove_managed_path,$${HOME}/.config/aerospace/aerospace.toml,$(REPO_ROOT)/aerospace/.config/aerospace/aerospace.toml); $(call remove_managed_path,$${HOME}/.config/borders/bordersrc,$(REPO_ROOT)/borders/.config/borders/bordersrc); }
	@echo "✅ Aerospace configuration removed"
	@echo "✅ Borders configuration removed"

# Test commands
test: check-syntax lint test-safety test-sync-smoke
	@echo "✅ All checks passed!"

test-safety:
	@bash "./test_makefile_safety.sh"

test-sync-smoke:
	@bash "./test_sync_smoke.sh"

# Check syntax of configuration files
check-syntax:
	@echo "🔍 Checking syntax..."
	@echo "Checking Lua files..."
	@for file in $$(find . -name "*.lua" -type f -not -path "./.git/*"); do \
		echo "  Checking $$file"; \
		luac -p "$$file" || { echo "❌ Syntax error in $$file"; exit 1; }; \
	done
	@echo "Checking JSON files..."
	@for file in nvim/.config/nvim/lazy-lock.json; do \
		if [ -f "$$file" ]; then \
			echo "  Checking $$file"; \
			python3 -m json.tool "$$file" >/dev/null || { echo "❌ Invalid JSON in $$file"; exit 1; }; \
		fi; \
	done
	@echo "✅ Syntax check passed"

# Lint configuration files
lint:
	@echo "🔍 Running linter..."
	@command -v luacheck >/dev/null 2>&1 && luacheck nvim/.config/nvim/lua/ nvim/.config/nvim/init.lua || echo "⚠️  luacheck not found, skipping Lua linting"
	@echo "✅ Linting completed"

.PHONY: all require-stow clean clean-force clean-ghostty clean-neovim clean-zsh clean-tig clean-aerospace sync sync-ghostty sync-ghostty-linux sync-ghostty-linux-force sync-neovim sync-zsh sync-tig sync-aerospace test test-safety test-sync-smoke check-syntax lint
