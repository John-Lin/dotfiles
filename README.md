# dotfiles

[![CI](https://github.com/John-Lin/dotfiles/actions/workflows/ci.yml/badge.svg)](https://github.com/John-Lin/dotfiles/actions/workflows/ci.yml)

Modern development environment configuration with Neovim, zsh, and AI-powered development tools.

## ✨ Features

- **🚀 Modern Neovim** - LSP, auto-completion, and AI assistance
- **💻 Enhanced Shell** - zsh with powerlevel10k theme  
- **🌍 Multi-language Support** - Python, Go, Lua, Terraform, YAML/Helm, C/C++, Zig
- **🤖 AI Integration** - Claude Code with custom agents and slash commands
- **🛠️ Developer Tools** - ripgrep, bat, eza, direnv, Kubernetes tooling
- **🪟 Window Management** - Aerospace tiling window manager with Borders integration (macOS)

## 📋 Prerequisites

**GNU Stow is required** for managing symbolic links:

```bash
# macOS
brew install stow

# Ubuntu/Debian
sudo apt install stow

# Arch Linux
sudo pacman -S stow

# CentOS/RHEL/Fedora
sudo dnf install stow
```

## 🚀 Quick Start

```bash
# Clone the repository
git clone https://github.com/John-Lin/dotfiles ~/dotfiles
cd ~/dotfiles

# Install everything
make sync

# Or install specific components
make sync-neovim        # Neovim configuration
make sync-zsh           # Zsh shell configuration  
make sync-tig           # Tig Git interface
make sync-ghostty       # Ghostty terminal (macOS)
make sync-ghostty-linux # Ghostty terminal (Linux)
make sync-claude        # Claude Code AI tools
make sync-aerospace     # Aerospace window manager + Borders (macOS)
```

**Testing**: `make test` (runs syntax checks and linting)

**Uninstall**: `make clean` (removes all symlinks)

## 📁 Structure

**Stow-managed packages** (each directory contains dotfiles in home directory structure):

```
dotfiles/
├── nvim/                      # Neovim configuration
│   └── .config/nvim/          # → ~/.config/nvim/
│       ├── init.lua           # Main configuration
│       ├── lua/               # Plugins and LSP settings
│       └── lazy-lock.json     # Plugin lockfile
├── zsh/                       # Zsh shell configuration  
│   ├── .zshrc                 # → ~/.zshrc
│   └── .p10k.zsh              # → ~/.p10k.zsh (powerlevel10k theme)
├── tig/                       # Tig Git interface
│   └── .tigrc                 # → ~/.tigrc
├── ghostty/                   # Ghostty terminal (macOS)
│   └── .config/ghostty/config # → ~/.config/ghostty/config
├── ghostty-linux/             # Ghostty terminal (Linux)
│   └── .config/ghostty/config # → ~/.config/ghostty/config
├── claude/                    # Claude Code AI tools
│   └── .claude/               # → ~/.claude/
│       ├── CLAUDE.md          # Global instructions
│       ├── agents/            # AI agent prompts
│       └── commands/          # Custom slash commands
├── aerospace/                 # Aerospace window manager (macOS)
│   └── .config/aerospace/     # → ~/.config/aerospace/
│       └── aerospace.toml     # Window management config
└── borders/                    # Window borders decoration (macOS)
    └── .config/borders/        # → ~/.config/borders/
        └── bordersrc           # Borders configuration
```

**Configuration files:**
- `Makefile` - Installation and management commands
- `claude/claude_settings.json.template` - Claude Code settings template

## 🎯 Key Components

### Neovim Plugins
- **lazy.nvim** - Plugin management
- **Telescope** - Fuzzy finder
- **nvim-tree** - File explorer  
- **Mason** - LSP installer
- **nvim-cmp** - Auto-completion
- **claudecode.nvim** - AI assistance

### Language Support

| Language | LSP Server | Tools |
|----------|------------|-------|
| Python | `basedpyright` + `ruff` | Type checking, formatting |
| Go | `gopls` | gofumpt formatting |
| Lua | `lua_ls` | Neodev integration |
| Terraform | `terraformls` | Auto-formatting |
| YAML/Helm | `yamlls` + `helm_ls` | Schema validation |
| C/C++ | `clangd` | clang-format |
| Zig | `zls` | Experimental |

## ⌨️ Key Bindings

### Essential
- `<Space>` - Leader key
- `<Leader>t` - Toggle file tree
- `<Leader>f` - Format code
- `gd` - Go to definition
- `K` - Show hover docs

### Claude AI (`<Leader>a` prefix)
- `ac` - Toggle Claude
- `as` - Send selection
- `aa/ad` - Accept/Deny diff

## 🐚 Shell Aliases

| Alias | Command | Purpose |
|-------|---------|---------|
| `grep` | `rg` | ripgrep (faster search) |
| `cat` | `bat` | syntax highlighting |
| `vim`/`vi` | `nvim` | Neovim |
| `ls`/`ll`/`la` | `eza` | modern ls replacement |
| `python` | `python3` | Python 3 |

## 🤖 AI Integration

### AI Agents (from [wshobson/agents](https://github.com/wshobson/agents))
- `architect-review` - Architecture review
- `code-reviewer` - Code quality review
- `debugger` - Debugging expert
- `golang-pro` - Go specialist
- `python-pro` - Python specialist
- `prompt-engineer` - Prompt optimization

### Slash Commands (`/sc:<command>`)
- `/sc:analyze` - Deep code analysis
- `/sc:document` - Generate docs
- `/sc:explain` - Code explanation
- `/sc:troubleshoot` - Debug issues
- `/sc:index` - Project indexing

## ⚙️ Customization

### Neovim
- Plugins: Edit `lua/plugins/`
- LSP: Modify `lua/lsp_config.lua`
- Auto-open file tree: Set `vim.g.auto_open_nvim_tree = true` in `init.lua`

### Terminal
- Ghostty: Edit `ghostty/.config/ghostty/config` or `ghostty-linux/.config/ghostty/config`
- Theme: Run `p10k configure`

### AI
- Claude settings: Auto-generated from `claude/claude_settings.json.template`
- Add agents: Create in `claude/.claude/agents/`
- Add commands: Create in `claude/.claude/commands/sc/`

### Remote Ghostty Setup
```bash
# Send terminfo to remote server
infocmp -x xterm-ghostty | ssh YOUR-SERVER -- tic -x -
```

## 📋 Requirements

**Essential:**
- macOS or Linux
- Git, Make
- **GNU Stow** (for symlink management)
- Neovim 0.8+
- Node.js (for LSP servers)

**Optional:**
- Python 3, Go (language support)
- ripgrep, bat, eza, zoxide, fzf (enhanced shell tools)

## 📝 License

MIT
