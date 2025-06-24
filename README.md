# dotfiles

Personal development environment configuration focused on Neovim, zsh, and modern development tools with AI integration.

## Features

- **Neovim**: Modern Lua configuration with LSP, completion, and syntax highlighting
- **Shell**: zsh with powerlevel10k theme and productivity aliases  
- **Language Support**: Python, Go, Lua, Terraform, YAML, Helm, Zig
- **Tools**: Integrated with ripgrep, bat, direnv, and Kubernetes tooling
- **AI Integration**: Built-in Claude Code support for AI-assisted development

## Installation

```bash
# Clone the repository
git clone <repo-url> ~/dotfiles
cd ~/dotfiles

# Install dotfiles (creates symlinks)
make sync

# Remove installation (optional)
make clean
```

## What's Included

### Core Configuration
- **Neovim** (`init.lua` + `lua/`) - Lua-based config with lazy.nvim plugin manager
- **Shell** (`zshrc`, `p10k.zsh`) - zsh with powerlevel10k and development aliases
- **Terminal** (`ghostty.config`) - Ghostty terminal emulator settings
- **Git** (`tigrc`) - Enhanced git interface with tig
- **Vim** (`vimrc`) - Fallback vim configuration

### Development Tools
- **Package Management**: lazy.nvim for plugins, Mason for LSP servers
- **Completion**: nvim-cmp with LSP integration
- **File Navigation**: Telescope fuzzy finder, NerdTree file explorer
- **Version Control**: Git integration with fugitive and gitsigns
- **AI Assistant**: Claude Code integration with `<leader>a` keybindings

## Language Support

Auto-configured LSP servers via Mason:
- **Lua** - `lua_ls` with neodev integration
- **Python** - `basedpyright` + `ruff` for type checking and linting
- **Go** - `gopls` with formatting and analysis
- **Terraform** - `terraformls` with auto-formatting
- **YAML/Kubernetes** - `yamlls` with schema validation
- **Helm** - `helm_ls` for chart development
- **Zig** - `zls` (experimental support)

## Key Bindings

### Global
- `<Space>` - Leader key
- `<Leader>v` - Vertical split
- `<Leader>s` - Horizontal split
- `Ctrl+h/j/k/l` - Navigate between splits

### LSP
- `gd` - Go to definition
- `K` - Show hover information
- `<Leader>ca` - Code actions
- `<Leader>rn` - Rename symbol
- `<Leader>f` - Format document

### Claude Code AI
- `<Leader>ac` - Toggle Claude
- `<Leader>af` - Focus Claude
- `<Leader>as` - Send selection to Claude
- `<Leader>aa` - Accept AI diff
- `<Leader>ad` - Deny AI diff

## Shell Aliases

- `grep` → `rg` (ripgrep for faster searching)
- `cat` → `bat` (syntax highlighted file viewing)
- `vim`/`vi` → `nvim` (Neovim as default editor)
- `python` → `python3` (Python 3 by default)
