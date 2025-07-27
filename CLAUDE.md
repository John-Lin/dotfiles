# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal dotfiles repository focused on Neovim, zsh, and modern development tools. The configuration supports multiple programming languages including Python, Go, Lua, Terraform, YAML, and Helm.

## Commands

### Installation and Setup
```bash
# Install/sync dotfiles by creating symlinks
make sync

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
The configuration includes claudecode.nvim plugin with keybindings under `<leader>a` prefix for AI assistance within Neovim.

**CI/CD Pipeline:**
- GitHub Actions workflow (`.github/workflows/ci.yml`) runs on push/PR
- Automated syntax checking for all Lua and JSON files
- Linting with luacheck
- Build status badge available in README.md

**File Tree Explorer:**
- Uses nvim-tree (modern replacement for NerdTree)
- Configured with Git integration and custom keybindings