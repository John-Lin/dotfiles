
# Detect OS
UNAME_S := $(shell uname -s)

ifeq ($(UNAME_S),Darwin)
    SOUND_COMMAND := afplay /System/Library/Sounds/Glass.aiff
else
    SOUND_COMMAND := paplay /usr/share/sounds/freedesktop/stereo/complete.oga
endif

# Default target
all: sync

# Install all dotfiles (removed automatic installation)
sync:
	@echo "⚠️  Please specify which configuration to install:"
	@echo "  make sync-ghostty       - Install Ghostty configuration"
	@echo "  make sync-ghostty-linux - Install Ghostty Linux configuration"
	@echo "  make sync-neovim        - Install Neovim configuration"
	@echo "  make sync-zsh           - Install Zsh configuration"
	@echo "  make sync-tig           - Install Tig configuration"
	@echo "  make sync-claude        - Install Claude Code configuration"
	@echo "  make sync-aerospace     - Install Aerospace configuration"

# Install Ghostty configuration
sync-ghostty:
	@echo "🖥️  Installing Ghostty configuration..."
	@command -v stow >/dev/null 2>&1 || { echo "❌ stow is not installed. Please install it first."; exit 1; }
	stow -t ~ ghostty
	@echo "✅ Ghostty configuration installed"

# Install Ghostty configuration (Linux specific)
sync-ghostty-linux:
	@echo "🐧 Installing Ghostty configuration for Linux..."
	@command -v stow >/dev/null 2>&1 || { echo "❌ stow is not installed. Please install it first."; exit 1; }
	@if [ -f ~/.config/ghostty/config ]; then \
		echo "  ~/.config/ghostty/config already exists, only installing custom.conf..."; \
		mkdir -p ~/.config/ghostty; \
		ln -sf $(PWD)/ghostty-linux/.config/ghostty/custom.conf ~/.config/ghostty/custom.conf; \
	else \
		echo "  ~/.config/ghostty/config does not exist, installing full configuration..."; \
		stow -t ~ ghostty-linux; \
	fi
	@echo "✅ Ghostty Linux configuration installed"

# Install Neovim configuration
sync-neovim:
	@echo "📝 Installing Neovim configuration..."
	@command -v stow >/dev/null 2>&1 || { echo "❌ stow is not installed. Please install it first."; exit 1; }
	stow -t ~ nvim
	@echo "✅ Neovim configuration installed"

# Install Zsh configuration
sync-zsh:
	@echo "🐚 Installing Zsh configuration..."
	@command -v stow >/dev/null 2>&1 || { echo "❌ stow is not installed. Please install it first."; exit 1; }
	stow -t ~ zsh
	@echo "✅ Zsh configuration installed"

# Install Tig configuration
sync-tig:
	@echo "🔍 Installing Tig configuration..."
	@command -v stow >/dev/null 2>&1 || { echo "❌ stow is not installed. Please install it first."; exit 1; }
	stow -t ~ tig
	@echo "✅ Tig configuration installed"

# Install Claude Code configuration
sync-claude:
	@echo "🤖 Installing Claude Code configuration..."
	@mkdir -p ~/.claude
	@ln -sf $(PWD)/claude/.claude/CLAUDE.md ~/.claude/CLAUDE.md
	@ln -sf $(PWD)/claude/.claude/agents ~/.claude/agents
	@ln -sf $(PWD)/claude/.claude/commands ~/.claude/commands
	@ln -sf $(PWD)/claude/.claude/skills ~/.claude/skills
	@echo "  Generating settings.json for $(UNAME_S)..."
	@sed 's|__SOUND_COMMAND__|$(SOUND_COMMAND)|g' claude/claude_settings.json.template > ~/.claude/settings.json
	@echo "✅ Claude Code configuration installed"

# Install Aerospace configuration (includes Borders)
sync-aerospace:
	@echo "🚀 Installing Aerospace configuration..."
	@command -v stow >/dev/null 2>&1 || { echo "❌ stow is not installed. Please install it first."; exit 1; }
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
	@echo "  - ~/.claude/"
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
	@command -v stow >/dev/null 2>&1 && stow -D -t ~ nvim || rm -rf ~/.config/nvim/
	@command -v stow >/dev/null 2>&1 && stow -D -t ~ tig || rm -f ~/.tigrc
	@command -v stow >/dev/null 2>&1 && stow -D -t ~ zsh || { rm -f ~/.zshrc ~/.p10k.zsh; }
	@rm -f ~/.claude/CLAUDE.md ~/.claude/settings.json
	@rm -f ~/.claude/agents ~/.claude/commands ~/.claude/skills
	@command -v stow >/dev/null 2>&1 && { stow -D -t ~ ghostty 2>/dev/null || stow -D -t ~ ghostty-linux 2>/dev/null; } || rm -f ~/.config/ghostty/config
	@[ -L ~/.config/ghostty/custom.conf ] && rm -f ~/.config/ghostty/custom.conf || true
	@command -v stow >/dev/null 2>&1 && { stow -D -t ~ aerospace; stow -D -t ~ borders; } || { rm -f ~/.config/aerospace/aerospace.toml; rm -f ~/.config/borders/bordersrc; }
	@echo "✅ All configurations removed"

# Individual clean targets
clean-ghostty:
	@echo "🧹 Removing Ghostty configuration..."
	@command -v stow >/dev/null 2>&1 && { stow -D -t ~ ghostty 2>/dev/null || stow -D -t ~ ghostty-linux 2>/dev/null; } || rm -f ~/.config/ghostty/config
	@if [ -L ~/.config/ghostty/custom.conf ]; then \
		echo "  Removing custom.conf symlink..."; \
		rm -f ~/.config/ghostty/custom.conf; \
	fi
	@echo "✅ Ghostty configuration removed"

clean-tig:
	@echo "🧹 Removing Tig configuration..."
	@command -v stow >/dev/null 2>&1 && stow -D -t ~ tig || rm -f ~/.tigrc
	@echo "✅ Tig configuration removed"

clean-neovim:
	@echo "🧹 Removing Neovim configuration..."
	@command -v stow >/dev/null 2>&1 && stow -D -t ~ nvim || rm -rf ~/.config/nvim/
	@echo "✅ Neovim configuration removed"

clean-zsh:
	@echo "🧹 Removing Zsh configuration..."
	@command -v stow >/dev/null 2>&1 && stow -D -t ~ zsh || { rm -f ~/.zshrc ~/.p10k.zsh; }
	@echo "✅ Zsh configuration removed"

clean-claude:
	@echo "🧹 Removing Claude Code configuration..."
	@rm -f ~/.claude/CLAUDE.md
	@rm -f ~/.claude/agents
	@rm -f ~/.claude/commands
	@rm -f ~/.claude/skills
	@rm -f ~/.claude/settings.json
	@echo "✅ Claude Code configuration removed"

clean-aerospace:
	@echo "🧹 Removing Aerospace configuration..."
	@command -v stow >/dev/null 2>&1 && { stow -D -t ~ aerospace; stow -D -t ~ borders; } || { rm -f ~/.config/aerospace/aerospace.toml; rm -f ~/.config/borders/bordersrc; }
	@echo "✅ Aerospace configuration removed"
	@echo "✅ Borders configuration removed"

# Test commands
test: check-syntax lint
	@echo "✅ All checks passed!"

# Check syntax of configuration files
check-syntax:
	@echo "🔍 Checking syntax..."
	@echo "Checking Lua files..."
	@for file in $$(find . -name "*.lua" -type f -not -path "./.git/*"); do \
		echo "  Checking $$file"; \
		luac -p "$$file" || { echo "❌ Syntax error in $$file"; exit 1; }; \
	done
	@echo "Checking JSON files..."
	@for file in lazy-lock.json claude/claude_settings.json.template; do \
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

.PHONY: all clean clean-force clean-ghostty clean-neovim clean-zsh clean-tig clean-claude clean-aerospace sync sync-ghostty sync-ghostty-linux sync-neovim sync-zsh sync-tig sync-claude sync-aerospace test check-syntax lint
