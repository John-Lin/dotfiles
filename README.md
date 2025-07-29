# dotfiles

[![CI](https://github.com/John-Lin/dotfiles/actions/workflows/ci.yml/badge.svg)](https://github.com/John-Lin/dotfiles/actions/workflows/ci.yml)

Modern development environment configuration focused on Neovim, zsh, and productivity tools with AI integration.

## Overview

A comprehensive dotfiles setup that provides a powerful development environment with:
- **Modern Neovim** configuration with LSP, completion, and AI assistance
- **Enhanced shell** experience with zsh and powerlevel10k
- **Multi-language support** for Python, Go, Lua, Terraform, YAML, Helm, and Zig
- **Developer tools** integration including ripgrep, bat, direnv, and Kubernetes tooling

## Quick Start

### Prerequisites
- macOS or Linux
- Git
- Make

### Installation

```bash
# Clone the repository
git clone https://github.com/John-Lin/dotfiles ~/dotfiles
cd ~/dotfiles

# Install all configurations at once
make sync

# Or install specific configurations selectively
make sync-ghostty   # Ghostty terminal configuration
make sync-neovim    # Neovim editor configuration
make sync-zsh       # Zsh shell configuration
make sync-claude    # Claude Code AI assistant configuration
```

### Testing
```bash
# Run syntax checks and linting
make test

# Run individual checks
make check-syntax
make lint
```

### Removal
```bash
# Remove all symlinks and configurations
make clean
```

## Configuration Files

| Component | Files | Description |
|-----------|-------|-------------|
| **Neovim** | `init.lua`, `lua/` | Lua-based configuration with lazy.nvim plugin manager |
| **Shell** | `zshrc`, `p10k.zsh` | zsh with powerlevel10k theme and development aliases |
| **Terminal** | `ghostty.config` | Ghostty terminal emulator settings |
| **Git** | `tigrc` | Enhanced git interface configuration |
| **Vim** | `vimrc` | Fallback vim configuration |

## Key Features

### Plugin Management
- **lazy.nvim** - Fast and flexible plugin manager
- **Mason** - Automatic LSP server and tool installation
- **nvim-cmp** - Intelligent completion engine

### Navigation & Search
- **Telescope** - Fuzzy finder for files, buffers, and more
- **nvim-tree** - Modern file explorer with configurable auto-open and lazy loading
- **ripgrep** - Ultra-fast text search

### Development Experience
- **LSP Integration** - Native language server protocol support
- **Git Integration** - fugitive and gitsigns for version control
- **AI Assistant** - Claude Code integration with dedicated keybindings

## Language Support

| Language | LSP Server | Features |
|----------|------------|----------|
| **Lua** | `lua_ls` | Neodev integration, completion, diagnostics |
| **Python** | `basedpyright` + `ruff` | Type checking, linting, formatting |
| **Go** | `gopls` | Formatting, analysis, debugging |
| **Terraform** | `terraformls` | Auto-formatting, validation |
| **YAML** | `yamlls` | Schema validation, Kubernetes support |
| **Helm** | `helm_ls` | Chart development and validation |
| **C/C++** | `clangd` | Code completion, formatting with clang-format |
| **Zig** | `zls` | Experimental support |

*All LSP servers are automatically installed and configured via Mason.*

## Keybindings

| Category | Binding | Action |
|----------|---------|--------|
| **Global** | `<Space>` | Leader key |
| | `<Leader>v` | Vertical split |
| | `<Leader>s` | Horizontal split |
| | `Ctrl+h/j/k/l` | Navigate between splits |
| **LSP** | `gd` | Go to definition |
| | `K` | Show hover information |
| | `<Leader>ca` | Code actions |
| | `<Leader>rn` | Rename symbol |
| | `<Leader>f` | Format document |
| **File Explorer** | `<Leader>t` | Toggle nvim-tree |
| | `<Leader>l` | Find current file in tree |
| **Claude AI** | `<Leader>ac` | Toggle Claude |
| | `<Leader>af` | Focus Claude |
| | `<Leader>as` | Send selection to Claude |
| | `<Leader>aa` | Accept AI diff |
| | `<Leader>ad` | Deny AI diff |

## Shell Configuration

### Aliases
| Alias | Command | Purpose |
|-------|---------|---------|
| `grep` | `rg` | Faster searching with ripgrep |
| `cat` | `bat` | Syntax highlighted file viewing |
| `vim`, `vi` | `nvim` | Use Neovim as default editor |
| `python` | `python3` | Python 3 by default |

### Tools Integration
- **direnv** - Automatic environment loading per project
- **powerlevel10k** - Fast and customizable zsh theme
- **Kubernetes** - kubectl, helm, and related tooling

## Advanced Configuration

### Ghostty Terminal Setup

The configuration includes terminfo setup for Ghostty terminal. To use Ghostty features on remote servers:

**Direct method:**
```bash
infocmp -x xterm-ghostty | ssh YOUR-SERVER -- tic -x -
```

**Manual method:**
```bash
infocmp -x xterm-ghostty > xterm-ghostty.terminfo
scp xterm-ghostty.terminfo YOUR-SERVER:~/
tic -x xterm-ghostty.terminfo
```

### Customization

- **Neovim plugins**: Edit `lua/plugins/` files
- **LSP settings**: Modify `lua/lsp_config.lua`
- **Shell aliases**: Update `zshrc`
- **Theme**: Configure powerlevel10k via `p10k configure`

#### nvim-tree Configuration

Control nvim-tree behavior by setting in `init.lua`:

```lua
-- Enable auto-open (disables lazy loading for faster startup)
vim.g.auto_open_nvim_tree = true

-- Disable auto-open (enables lazy loading for faster startup)
vim.g.auto_open_nvim_tree = false  -- Default
```

## Dependencies

The setup automatically installs most dependencies, but you may need:
- **Neovim** (0.8+)
- **Node.js** (for some LSP servers)
- **Python 3** (for Python LSP)
- **Go** (for Go development)

## License

MIT License - feel free to use and modify as needed.
