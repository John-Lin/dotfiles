# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal dotfiles repository focused on Neovim, zsh, and modern development tools. The configuration supports multiple programming languages including Python, Go, Lua, Terraform, YAML, and Helm.

## Commands

### Installation and Setup
```bash
# Install all configurations at once
make sync

# Install specific configurations selectively
make sync-ghostty   # Install Ghostty terminal configuration
make sync-neovim    # Install Neovim configuration
make sync-zsh       # Install Zsh shell configuration
make sync-claude    # Install Claude Code configuration

# Remove all symlinks and config directories
make clean
```

### Testing and Quality Assurance
```bash
# Run all checks (syntax + linting)
make test

# Run syntax check for Lua and JSON files
make check-syntax

# Run linting (luacheck)
make lint
```

### Architecture

**Configuration Structure:**
- `init.lua` - Main Neovim entry point with basic settings, keybindings, and lazy.nvim bootstrap
- `lua/lib.lua` - Utility functions including `safeRequire()` for stable module loading
- `lua/lsp_config.lua` - Language server configurations for all supported languages
- `lua/plugins/` - Modular plugin configurations loaded by lazy.nvim

**Language Support:**
- **Lua**: lua_ls with neodev integration
- **Python**: basedpyright + ruff for type checking and formatting
- **Go**: gopls with gofumpt formatting
- **Terraform**: terraformls with auto-formatting on save
- **YAML/Helm**: yamlls + helm_ls with schema validation
- **C/C++**: clangd with clang-format for code completion and formatting
- **Zig**: zls (experimental)

**Key Dependencies:**
- `lazy.nvim` for plugin management
- `mason.nvim` for automatic LSP server installation
- `cmp_nvim_lsp` for completion capabilities
- All LSP servers auto-installed via Mason

**Shell Configuration:**
- zsh with powerlevel10k theme
- Key aliases: `grep`→`rg`, `cat`→`bat`, `vim`→`nvim`
- Environment setup for Go, Python, Kubernetes tools
- direnv integration for project-specific environments

**Plugin Architecture:**
Each plugin is configured in its own file under `lua/plugins/`. The configuration uses lazy.nvim's declarative syntax with automatic loading based on file types and key mappings.

**Claude Code Integration:**
The configuration includes claudecode.nvim plugin with keybindings under `<leader>a` prefix for AI assistance within Neovim. Currently using the feat/show-terminal-on-at-mention branch for enhanced terminal integration.

**CI/CD Pipeline:**
- GitHub Actions workflow (`.github/workflows/ci.yml`) runs on push/PR
- Automated syntax checking for all Lua and JSON files
- Linting with luacheck
- Build status badge available in README.md

**File Tree Explorer:**
- Uses nvim-tree (modern replacement for NerdTree)
- Configured with Git integration and custom keybindings
- Configurable auto-open behavior with conditional lazy loading
- Toggle with `<leader>t`, find current file with `<leader>l`
- Auto-open controlled by `vim.g.auto_open_nvim_tree` variable in `init.lua`

## Plugin-Specific Configuration

### nvim-tree Configuration
Control nvim-tree auto-open behavior via `vim.g.auto_open_nvim_tree`:
- `true`: Enables auto-open on startup (disables lazy loading for immediate availability)
- `false` or `nil`: Disables auto-open (enables lazy loading for faster startup) - Default
- Configuration logic in `lua/plugins/nvim-tree.lua` uses conditional lazy loading
- Uses `vim.schedule()` for safe VimEnter autocmd execution

### Key Bindings Reference
- `<leader>t`: Toggle nvim-tree
- `<leader>l`: Find current file in nvim-tree
- `<leader>a*`: Claude Code integration commands

# important-instruction-reminders
Do what has been asked; nothing more, nothing less.
NEVER create files unless they're absolutely necessary for achieving your goal.
ALWAYS prefer editing an existing file to creating a new one.
NEVER proactively create documentation files (*.md) or README files. Only create documentation files if explicitly requested by the User.
