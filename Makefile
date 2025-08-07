
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
	@echo "  make sync-claude        - Install Claude Code configuration"

# Install Ghostty configuration
sync-ghostty:
	@echo "🖥️  Installing Ghostty configuration..."
	mkdir -p ~/.config/ghostty
	[ -f ~/.config/ghostty/config ] || ln -s $(PWD)/ghostty.config ~/.config/ghostty/config
	@echo "✅ Ghostty configuration installed"

# Install Ghostty configuration (Linux specific)
sync-ghostty-linux:
	@echo "🐧 Installing Ghostty configuration for Linux..."
	mkdir -p ~/.config/ghostty
	[ -f ~/.config/ghostty/config ] || ln -s $(PWD)/ghostty.config.linux ~/.config/ghostty/config
	@echo "✅ Ghostty Linux configuration installed"

# Install Neovim configuration
sync-neovim:
	@echo "📝 Installing Neovim configuration..."
	mkdir -p ~/.config/nvim
	[ -f ~/.config/nvim/init.lua ] || ln -s $(PWD)/init.lua ~/.config/nvim/init.lua
	[ -f ~/.config/nvim/lazy-lock.json ] || ln -s $(PWD)/lazy-lock.json ~/.config/nvim/lazy-lock.json
	[ -d ~/.config/nvim/lua ] || ln -s $(PWD)/lua ~/.config/nvim/lua
	@echo "✅ Neovim configuration installed"

# Install Zsh configuration
sync-zsh:
	@echo "🐚 Installing Zsh configuration..."
	[ -f ~/.tigrc ] || ln -s $(PWD)/tigrc ~/.tigrc
	[ -f ~/.zshrc ] || ln -s $(PWD)/zshrc ~/.zshrc
	[ -f ~/.p10k.zsh ] || ln -s $(PWD)/p10k.zsh ~/.p10k.zsh
	@echo "✅ Zsh configuration installed"

# Install Claude Code configuration
sync-claude:
	@echo "🤖 Installing Claude Code configuration..."
	mkdir -p ~/.claude
	@echo "  Generating claude_settings.json for $(UNAME_S)..."
	@sed 's|__SOUND_COMMAND__|$(SOUND_COMMAND)|g' claude_settings.json.template > claude_settings.json
	[ -f ~/.claude/settings.json ] || ln -s $(PWD)/claude_settings.json ~/.claude/settings.json
	[ -f ~/.claude/CLAUDE.md ] || ln -s $(PWD)/claude_md ~/.claude/CLAUDE.md
	[ -d ~/.claude/commands ] || ln -s $(PWD)/commands ~/.claude/commands
	[ -d ~/.claude/agents ] || ln -s $(PWD)/agents ~/.claude/agents
	@echo "✅ Claude Code configuration installed"

# Remove all symlinks and configuration directories (with confirmation)
clean:
	@echo "⚠️  WARNING: This will remove all dotfile configurations!"
	@echo "  - ~/.config/nvim/"
	@echo "  - ~/.config/ghostty/config"
	@echo "  - ~/.tigrc, ~/.zshrc, ~/.p10k.zsh"
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
	rm -rf ~/.config/nvim/
	rm -f ~/.tigrc
	rm -f ~/.zshrc
	rm -f ~/.p10k.zsh
	rm -f ~/.config/ghostty/config
	rm -f ~/.claude/settings.json
	rm -f ~/.claude/CLAUDE.md
	rm -rf ~/.claude/commands
	rm -rf ~/.claude/agents
	@echo "✅ All configurations removed"

# Individual clean targets
clean-ghostty:
	@echo "🧹 Removing Ghostty configuration..."
	rm -f ~/.config/ghostty/config
	@echo "✅ Ghostty configuration removed"

clean-neovim:
	@echo "🧹 Removing Neovim configuration..."
	rm -rf ~/.config/nvim/
	@echo "✅ Neovim configuration removed"

clean-zsh:
	@echo "🧹 Removing Zsh configuration..."
	rm -f ~/.tigrc ~/.zshrc ~/.p10k.zsh
	@echo "✅ Zsh configuration removed"

clean-claude:
	@echo "🧹 Removing Claude Code configuration..."
	rm -f ~/.claude/settings.json ~/.claude/CLAUDE.md
	rm -rf ~/.claude/commands ~/.claude/agents
	@echo "✅ Claude Code configuration removed"

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
	@for file in lazy-lock.json claude_settings.json; do \
		if [ -f "$$file" ]; then \
			echo "  Checking $$file"; \
			python3 -m json.tool "$$file" >/dev/null || { echo "❌ Invalid JSON in $$file"; exit 1; }; \
		fi; \
	done
	@echo "✅ Syntax check passed"

# Lint configuration files
lint:
	@echo "🔍 Running linter..."
	@command -v luacheck >/dev/null 2>&1 && luacheck lua/ init.lua || echo "⚠️  luacheck not found, skipping Lua linting"
	@echo "✅ Linting completed"

.PHONY: all clean clean-force clean-ghostty clean-neovim clean-zsh clean-claude sync sync-ghostty sync-ghostty-linux sync-neovim sync-zsh sync-claude test check-syntax lint
