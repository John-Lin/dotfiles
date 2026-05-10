# Default target
all: sync

REPO_ROOT := $(abspath $(CURDIR))

# Auto-detect work environment via OPENCODE_WORK_CONFIG env var (path to external config dir)
OPENCODE_ENV := $(if $(OPENCODE_WORK_CONFIG),work,personal)
OPENCODE_JPATH := $(if $(OPENCODE_WORK_CONFIG),-J $(OPENCODE_WORK_CONFIG) -J $(REPO_ROOT)/jsonnet,)

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

define build_claude_outputs
if [ -f "$(REPO_ROOT)/claude/.claude/CLAUDE.personal.md" ]; then \
	echo "  Merging base + personal → CLAUDE.md"; \
	{ cat "$(REPO_ROOT)/claude/.claude/CLAUDE.base.md"; echo ""; cat "$(REPO_ROOT)/claude/.claude/CLAUDE.personal.md"; } > "$(1)"; \
else \
	echo "  No CLAUDE.personal.md found, using base only"; \
	echo "  💡 Copy CLAUDE.personal.md.example → CLAUDE.personal.md to customize"; \
	cp "$(REPO_ROOT)/claude/.claude/CLAUDE.base.md" "$(1)"; \
fi; \
echo "  Generating settings.json..."; \
if [ -f "$(REPO_ROOT)/claude/claude_settings.personal.json" ]; then \
	echo "  Merging template + personal settings.json"; \
	jq -s '.[0] * .[1]' "$(REPO_ROOT)/claude/claude_settings.json.template" "$(REPO_ROOT)/claude/claude_settings.personal.json" > "$(2)"; \
else \
	cp "$(REPO_ROOT)/claude/claude_settings.json.template" "$(2)"; \
fi
endef

define remove_managed_file
target="$(1)"; expected="$(2)"; \
if [ -L "$$target" ]; then \
	echo "⚠️  Skipping unmanaged symlink $$target"; \
elif [ -e "$$target" ]; then \
	if cmp -s "$$target" "$$expected"; then \
		rm -f "$$target"; \
	else \
		echo "⚠️  Skipping unmanaged file $$target"; \
	fi; \
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
	@echo "  make sync-opencode      - Install OpenCode configuration (agents + opencode.json)"
	@echo "  make sync-pi            - Install pi configuration (AGENTS.md + settings.json)"
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
	$(call build_claude_outputs,$$tmp_claude_md,$$tmp_settings); \
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

# Install OpenCode configuration (agents + opencode.json from jsonnet)
sync-opencode:
	@echo "🤖 Installing OpenCode configuration..."
	@mkdir -p ~/.config/opencode
	@command -v jsonnet >/dev/null 2>&1 || { echo "❌ jsonnet is not installed. Please install it first."; exit 1; }
	@set -e; \
	echo "  Building opencode.json (env=$(OPENCODE_ENV))..."; \
	tmp_opencode="$$(mktemp /tmp/opencode-json.XXXXXX)"; \
	cleanup() { rm -f "$$tmp_opencode"; }; \
	trap cleanup EXIT; \
	jsonnet $(OPENCODE_JPATH) --tla-str env=$(OPENCODE_ENV) "$(REPO_ROOT)/jsonnet/opencode.jsonnet" > "$$tmp_opencode"; \
	if [ -e "$${HOME}/.config/opencode/opencode.json" ] && ! cmp -s "$$tmp_opencode" "$${HOME}/.config/opencode/opencode.json"; then \
		echo "❌ ~/.config/opencode/opencode.json already exists with different contents"; \
		echo "   Move it away manually or run make sync-opencode-force"; \
		exit 1; \
	fi; \
	$(call ensure_safe_symlink,$${HOME}/.config/opencode/agents,$(REPO_ROOT)/opencode/agents,sync-opencode-force); \
	mv "$$tmp_opencode" "$${HOME}/.config/opencode/opencode.json"; \
	ln -snf "$(REPO_ROOT)/opencode/agents" "$${HOME}/.config/opencode/agents"
	@echo "✅ OpenCode configuration installed (env=$(OPENCODE_ENV))"

sync-opencode-force:
	@echo "🤖 Installing OpenCode configuration (force)..."
	@mkdir -p ~/.config/opencode
	@rm -f ~/.config/opencode/opencode.json
	@rm -rf ~/.config/opencode/agents
	@$(MAKE) sync-opencode

# Install pi configuration (AGENTS.md symlinks to ~/.claude/CLAUDE.md; packages injected into settings.json)
sync-pi:
	@echo "🤖 Installing pi configuration..."
	@mkdir -p ~/.pi/agent
	@command -v jq >/dev/null 2>&1 || { echo "❌ jq is not installed. Please install it first."; exit 1; }
	@ln -snf ~/.claude/CLAUDE.md ~/.pi/agent/AGENTS.md
	@if [ -f ~/.pi/agent/settings.json ]; then \
		echo "  Injecting packages into ~/.pi/agent/settings.json..."; \
		jq '.packages = $$pkgs[0]' --slurpfile pkgs "$(REPO_ROOT)/pi/packages.json" ~/.pi/agent/settings.json > ~/.pi/agent/settings.json.tmp && \
		mv ~/.pi/agent/settings.json.tmp ~/.pi/agent/settings.json; \
	else \
		echo "  Creating ~/.pi/agent/settings.json with packages..."; \
		jq -n '{packages: $$pkgs[0]}' --slurpfile pkgs "$(REPO_ROOT)/pi/packages.json" > ~/.pi/agent/settings.json; \
	fi
	@echo "✅ pi configuration installed"
	@echo "  ~/.pi/agent/AGENTS.md -> ~/.claude/CLAUDE.md"
	@echo "  ~/.pi/agent/settings.json (packages injected)"

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
	@echo "  - ~/.pi/agent/AGENTS.md"
	@echo "  - ~/.config/opencode/opencode.json"
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
	@$(MAKE) clean-neovim
	@$(MAKE) clean-tig
	@$(MAKE) clean-zsh
	@$(MAKE) clean-claude
	@$(MAKE) clean-opencode
	@$(MAKE) clean-pi
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

clean-claude:
	@echo "🧹 Removing Claude Code configuration..."
	@set -e; \
	mkdir -p ~/.claude; \
	command -v jq >/dev/null 2>&1 || { echo "❌ jq is not installed. Please install it first."; exit 1; }; \
	tmp_claude_md="$$(mktemp /tmp/claude-md.XXXXXX)"; \
	tmp_settings="$$(mktemp /tmp/claude-settings.XXXXXX)"; \
	cleanup() { rm -f "$$tmp_claude_md" "$$tmp_settings"; }; \
	trap cleanup EXIT; \
	$(call build_claude_outputs,$$tmp_claude_md,$$tmp_settings); \
	$(call remove_managed_file,$${HOME}/.claude/CLAUDE.md,$$tmp_claude_md); \
	$(call remove_managed_file,$${HOME}/.claude/settings.json,$$tmp_settings)
	@$(call remove_managed_path,$${HOME}/.claude/agents,$(REPO_ROOT)/claude/.claude/agents)
	@$(call remove_managed_path,$${HOME}/.claude/commands,$(REPO_ROOT)/claude/.claude/commands)
	@$(call remove_managed_path,$${HOME}/.claude/skills,$(REPO_ROOT)/claude/.claude/skills)
	@echo "✅ Claude Code configuration removed"

clean-opencode:
	@echo "🧹 Removing OpenCode configuration..."
	@set -e; \
	if command -v jsonnet >/dev/null 2>&1; then \
		tmp_opencode="$$(mktemp /tmp/opencode-json.XXXXXX)"; \
		cleanup() { rm -f "$$tmp_opencode"; }; \
		trap cleanup EXIT; \
		jsonnet $(OPENCODE_JPATH) --tla-str env=$(OPENCODE_ENV) "$(REPO_ROOT)/jsonnet/opencode.jsonnet" > "$$tmp_opencode"; \
		$(call remove_managed_file,$${HOME}/.config/opencode/opencode.json,$$tmp_opencode); \
	else \
		echo "  ⚠️  jsonnet not found, skipping opencode.json cleanup"; \
	fi
	@$(call remove_managed_path,$${HOME}/.config/opencode/agents,$(REPO_ROOT)/opencode/agents)
	@echo "✅ OpenCode configuration removed"

clean-pi:
	@echo "🧹 Removing pi configuration..."
	@rm -f ~/.pi/agent/AGENTS.md
	@echo "  (settings.json left untouched — it is your personal file)"
	@echo "✅ pi configuration removed"

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
	@echo "Checking Jsonnet files..."
	@if command -v jsonnet >/dev/null 2>&1; then \
		for file in $$(find ./jsonnet -name "*.jsonnet" -o -name "*.libsonnet" 2>/dev/null | grep -v '_work'); do \
			echo "  Checking $$file"; \
			jsonnet --tla-str env=personal "$$file" >/dev/null 2>&1 || jsonnet "$$file" >/dev/null 2>&1 || { echo "❌ Syntax error in $$file"; exit 1; }; \
		done; \
	else \
		echo "  ⚠️  jsonnet not found, skipping Jsonnet checks"; \
	fi
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

.PHONY: all require-stow clean clean-force clean-ghostty clean-neovim clean-zsh clean-tig clean-claude clean-opencode clean-pi clean-aerospace sync sync-ghostty sync-ghostty-linux sync-ghostty-linux-force sync-neovim sync-zsh sync-tig sync-claude sync-claude-force sync-ccstatusline sync-opencode sync-opencode-force sync-pi sync-aerospace test test-safety test-sync-smoke check-syntax lint
