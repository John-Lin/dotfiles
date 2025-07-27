
# Default target
all: sync

# Create symlinks for dotfiles configuration
sync:
	# Create necessary directories
	mkdir -p ~/.config/nvim
	mkdir -p ~/.config/ghostty
	mkdir -p ~/.claude

	# Link Neovim configuration files
	[ -f ~/.config/nvim/init.lua ] || ln -s $(PWD)/init.lua ~/.config/nvim/init.lua
	[ -f ~/.config/nvim/lazy-lock.json ] || ln -s $(PWD)/lazy-lock.json ~/.config/nvim/lazy-lock.json

	# Link Neovim lua directory
	[ -d ~/.config/nvim/lua ] || ln -s $(PWD)/lua ~/.config/nvim/lua

	# Link shell and terminal configuration files
	[ -f ~/.tigrc ] || ln -s $(PWD)/tigrc ~/.tigrc
	[ -f ~/.zshrc ] || ln -s $(PWD)/zshrc ~/.zshrc
	[ -f ~/.p10k.zsh ] || ln -s $(PWD)/p10k.zsh ~/.p10k.zsh
	[ -f ~/.config/ghostty/config ] || ln -s $(PWD)/ghostty.config ~/.config/ghostty/config

	# Link Claude configuration file
	[ -f ~/.claude/settings.json ] || ln -s $(PWD)/claude_settings.json ~/.claude/settings.json
	# Link Claude global memory file
	[ -f ~/.claude/CLAUDE.md ] || ln -s $(PWD)/claude_md ~/.claude/CLAUDE.md
	# Link Claude commands directory
	[ -d ~/.claude/commands ] || ln -s $(PWD)/commands ~/.claude/commands
	# Link Claude sub agents directory
	[ -d ~/.claude/agents ] || ln -s $(PWD)/agents ~/.claude/agents

# Remove all symlinks and configuration directories
clean:
	rm -rf ~/.config/nvim/
	rm -f ~/.tigrc
	rm -f ~/.zshrc
	rm -f ~/.p10k.zsh
	rm -f ~/.config/ghostty/config
	rm -f ~/.claude/settings.json
	rm -f ~/.claude/CLAUDE.md
	rm -rf ~/.claude/commands
	rm -rf ~/.claude/agents

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

.PHONY: all clean sync test check-syntax lint
