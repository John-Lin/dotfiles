# dotfiles

Personal development environment configuration focused on Neovim, zsh, and modern development tools.

## Features

- **Neovim**: Lua-based configuration with LSP support for multiple languages
- **Shell**: zsh with powerlevel10k theme and useful aliases
- **Language Support**: Python, Go, Lua, Terraform, YAML, Helm
- **Tools**: Integrated with ripgrep, bat, direnv, and kubernetes tooling

## Installation

```bash
# Clone the repository
git clone <repo-url> ~/dotfiles
cd ~/dotfiles

# Create symlinks to dotfiles
make sync

# Remove symlinks if needed
make clean
```

## What's Included

- **Neovim config** (`init.lua` + `lua/` directory) - Modern Lua configuration with lazy.nvim
- **Shell config** (`zshrc`, `p10k.zsh`) - zsh with powerlevel10k theme
- **Terminal** (`ghostty.config`) - Ghostty terminal configuration  
- **Git** (`tigrc`) - tig configuration for git
- **Vim fallback** (`vimrc`) - Basic vim configuration

## Language Servers

Automatically configured via Mason:
- lua_ls (Lua)
- basedpyright + ruff (Python)
- gopls (Go) 
- terraformls (Terraform)
- helm_ls (Helm)
- yamlls (YAML)
