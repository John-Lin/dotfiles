# Default target
all: sync

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
	@echo "  make sync-claude        - Install Claude Code configuration"
	@echo "  make sync-ccstatusline  - Install ccstatusline configuration"
	@echo "  make sync-opencode      - Install OpenCode agents configuration"
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
		ln -sf $(PWD)/ghostty-linux/.config/ghostty/custom.conf ~/.config/ghostty/custom.conf; \
	else \
		echo "  ~/.config/ghostty/config does not exist, installing full configuration..."; \
		stow -t ~ ghostty-linux; \
	fi
	@echo "✅ Ghostty Linux configuration installed"

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

# Install Claude Code configuration
sync-claude:
	@echo "🤖 Installing Claude Code configuration..."
	@set -e; \
	mkdir -p ~/.claude; \
	command -v jq >/dev/null 2>&1 || { echo "❌ jq is not installed. Please install it first."; exit 1; }; \
	tmp_claude_md="$$(mktemp /tmp/claude-md.XXXXXX)"; \
	tmp_settings="$$(mktemp /tmp/claude-settings.XXXXXX)"; \
	cleanup() { rm -f "$$tmp_claude_md" "$$tmp_settings"; }; \
	trap cleanup EXIT; \
	if [ -f "$(REPO_ROOT)/claude/.claude/CLAUDE.personal.md" ]; then \
		echo "  Merging base + personal → CLAUDE.md"; \
		{ cat "$(REPO_ROOT)/claude/.claude/CLAUDE.base.md"; echo ""; cat "$(REPO_ROOT)/claude/.claude/CLAUDE.personal.md"; } > "$$tmp_claude_md"; \
	else \
		echo "  No CLAUDE.personal.md found, using base only"; \
		echo "  💡 Copy CLAUDE.personal.md.example → CLAUDE.personal.md to customize"; \
		cp "$(REPO_ROOT)/claude/.claude/CLAUDE.base.md" "$$tmp_claude_md"; \
	fi; \
	echo "  Generating settings.json..."; \
	if [ -f "$(REPO_ROOT)/claude/claude_settings.personal.json" ]; then \
		echo "  Merging template + personal settings.json"; \
		jq -s '.[0] * .[1]' "$(REPO_ROOT)/claude/claude_settings.json.template" "$(REPO_ROOT)/claude/claude_settings.personal.json" > "$$tmp_settings"; \
	else \
		cp "$(REPO_ROOT)/claude/claude_settings.json.template" "$$tmp_settings"; \
	fi; \
	if [ -e "$${HOME}/.claude/CLAUDE.md" ] && ! cmp -s "$$tmp_claude_md" "$${HOME}/.claude/CLAUDE.md"; then \
		echo "❌ $${HOME}/.claude/CLAUDE.md already exists with different contents"; \
		echo "   Move it away manually or run make sync-claude-force"; \
		exit 1; \
	fi; \
	if [ -e "$${HOME}/.claude/settings.json" ] && ! cmp -s "$$tmp_settings" "$${HOME}/.claude/settings.json"; then \
		echo "❌ $${HOME}/.claude/settings.json already exists with different contents"; \
		echo "   Move it away manually or run make sync-claude-force"; \
		exit 1; \
	fi; \
	$(call ensure_safe_symlink,$${HOME}/.claude/agents,$(REPO_ROOT)/claude/.claude/agents,sync-claude-force); \
	$(call ensure_safe_symlink,$${HOME}/.claude/commands,$(REPO_ROOT)/claude/.claude/commands,sync-claude-force); \
	$(call ensure_safe_symlink,$${HOME}/.claude/skills,$(REPO_ROOT)/claude/.claude/skills,sync-claude-force); \
	mv "$$tmp_claude_md" "$${HOME}/.claude/CLAUDE.md"; \
	mv "$$tmp_settings" "$${HOME}/.claude/settings.json"; \
	ln -snf "$(REPO_ROOT)/claude/.claude/agents" "$${HOME}/.claude/agents"; \
	ln -snf "$(REPO_ROOT)/claude/.claude/commands" "$${HOME}/.claude/commands"; \
	ln -snf "$(REPO_ROOT)/claude/.claude/skills" "$${HOME}/.claude/skills"
	@echo "✅ Claude Code configuration installed"

sync-claude-force:
	@echo "🤖 Installing Claude Code configuration (force)..."
	@mkdir -p ~/.claude
	@rm -rf ~/.claude/agents ~/.claude/commands ~/.claude/skills
	@rm -f ~/.claude/CLAUDE.md ~/.claude/settings.json
	@$(MAKE) sync-claude

# Install ccstatusline configuration
sync-ccstatusline: require-stow
	@echo "📊 Installing ccstatusline configuration..."
	@mkdir -p ~/.config/ccstatusline
	@if [ -f ~/.config/ccstatusline/settings.json ] && [ ! -L ~/.config/ccstatusline/settings.json ]; then \
		backup_file="$$HOME/.config/ccstatusline/settings.json.bak.$$(date +%Y%m%d%H%M%S)"; \
		echo "  Backing up existing settings.json → $$backup_file"; \
		mv ~/.config/ccstatusline/settings.json "$$backup_file"; \
	fi
	stow -t ~ ccstatusline
	@echo "✅ ccstatusline configuration installed"

# Install OpenCode agents configuration
sync-opencode:
	@echo "🤖 Installing OpenCode agents configuration..."
	@mkdir -p ~/.config/opencode
	@$(call ensure_safe_symlink,$${HOME}/.config/opencode/agents,$(REPO_ROOT)/opencode/agents,sync-opencode-force)
	@ln -snf "$(REPO_ROOT)/opencode/agents" "$${HOME}/.config/opencode/agents"
	@echo "✅ OpenCode agents configuration installed"

sync-opencode-force:
	@echo "🤖 Installing OpenCode agents configuration (force)..."
	@mkdir -p ~/.config/opencode
	@rm -rf ~/.config/opencode/agents
	@ln -snf "$(REPO_ROOT)/opencode/agents" "$${HOME}/.config/opencode/agents"
	@echo "✅ OpenCode agents configuration installed"

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
	@echo "  - ~/.claude/"
	@echo "  - ~/.config/opencode/agents"
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
	@command -v stow >/dev/null 2>&1 && stow -D -t ~ nvim || { $(call remove_managed_path,$${HOME}/.config/nvim,$(REPO_ROOT)/nvim/.config/nvim); }
	@command -v stow >/dev/null 2>&1 && stow -D -t ~ tig || { $(call remove_managed_path,$${HOME}/.tigrc,$(REPO_ROOT)/tig/.tigrc); }
	@command -v stow >/dev/null 2>&1 && stow -D -t ~ zsh || { $(call remove_managed_path,$${HOME}/.zshrc,$(REPO_ROOT)/zsh/.zshrc); $(call remove_managed_path,$${HOME}/.p10k.zsh,$(REPO_ROOT)/zsh/.p10k.zsh); }
	@rm -f ~/.claude/CLAUDE.md ~/.claude/settings.json
	@$(call remove_managed_path,$${HOME}/.claude/agents,$(REPO_ROOT)/claude/.claude/agents)
	@$(call remove_managed_path,$${HOME}/.claude/commands,$(REPO_ROOT)/claude/.claude/commands)
	@$(call remove_managed_path,$${HOME}/.claude/skills,$(REPO_ROOT)/claude/.claude/skills)
	@$(call remove_managed_path,$${HOME}/.config/opencode/agents,$(REPO_ROOT)/opencode/agents)
	@command -v stow >/dev/null 2>&1 && { stow -D -t ~ ghostty 2>/dev/null || stow -D -t ~ ghostty-linux 2>/dev/null; } || { $(call remove_managed_path,$${HOME}/.config/ghostty/config,$(REPO_ROOT)/ghostty/.config/ghostty/config); $(call remove_managed_path,$${HOME}/.config/ghostty/config,$(REPO_ROOT)/ghostty-linux/.config/ghostty/config); }
	@$(call remove_managed_path,$${HOME}/.config/ghostty/custom.conf,$(REPO_ROOT)/ghostty-linux/.config/ghostty/custom.conf)
	@command -v stow >/dev/null 2>&1 && { stow -D -t ~ aerospace; stow -D -t ~ borders; } || { $(call remove_managed_path,$${HOME}/.config/aerospace/aerospace.toml,$(REPO_ROOT)/aerospace/.config/aerospace/aerospace.toml); $(call remove_managed_path,$${HOME}/.config/borders/bordersrc,$(REPO_ROOT)/borders/.config/borders/bordersrc); }
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

clean-opencode:
	@echo "🧹 Removing OpenCode agents configuration..."
	@rm -rf ~/.config/opencode/agents
	@echo "✅ OpenCode agents configuration removed"

clean-aerospace:
	@echo "🧹 Removing Aerospace configuration..."
	@command -v stow >/dev/null 2>&1 && { stow -D -t ~ aerospace; stow -D -t ~ borders; } || { rm -f ~/.config/aerospace/aerospace.toml; rm -f ~/.config/borders/bordersrc; }
	@echo "✅ Aerospace configuration removed"
	@echo "✅ Borders configuration removed"

# Test commands
test: check-syntax lint test-safety
	@echo "✅ All checks passed!"

test-safety:
	@bash "./test_makefile_safety.sh"

# Check syntax of configuration files
check-syntax:
	@echo "🔍 Checking syntax..."
	@echo "Checking Lua files..."
	@for file in $$(find . -name "*.lua" -type f -not -path "./.git/*"); do \
		echo "  Checking $$file"; \
		luac -p "$$file" || { echo "❌ Syntax error in $$file"; exit 1; }; \
	done
	@echo "Checking JSON files..."
	@for file in nvim/.config/nvim/lazy-lock.json claude/claude_settings.json.template; do \
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

.PHONY: all require-stow clean clean-force clean-ghostty clean-neovim clean-zsh clean-tig clean-claude clean-opencode clean-aerospace sync sync-ghostty sync-ghostty-linux sync-neovim sync-zsh sync-tig sync-claude sync-claude-force sync-ccstatusline sync-opencode sync-opencode-force sync-aerospace test test-safety check-syntax lint
