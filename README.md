# dotfiles

[![CI](https://github.com/John-Lin/dotfiles/actions/workflows/ci.yml/badge.svg)](https://github.com/John-Lin/dotfiles/actions/workflows/ci.yml)

Modern development environment configuration with Neovim, zsh, and AI-powered development tools.

## ✨ Features

- **🚀 Modern Neovim** - LSP, auto-completion, and AI assistance
- **💻 Enhanced Shell** - zsh with powerlevel10k theme  
- **🌍 Multi-language Support** - Python, Go, Lua, Terraform, YAML/Helm, C/C++, Zig
- **🤖 AI Integration** - Claude Code with custom agents and slash commands
- **🛠️ Developer Tools** - ripgrep, bat, eza, direnv, Kubernetes tooling
- **🪟 Window Management** - Aerospace tiling window manager (macOS)

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
make sync-ghostty       # Ghostty terminal (macOS)
make sync-ghostty-linux # Ghostty terminal (Linux)
make sync-claude        # Claude Code AI tools
make sync-aerospace     # Aerospace window manager (macOS)
```

**Testing**: `make test` (runs syntax checks and linting)

**Uninstall**: `make clean` (removes all symlinks)

## 📁 Structure

```
dotfiles/
├── init.lua                    # Neovim main configuration
├── lua/                       # Neovim plugins and LSP settings
│   ├── plugins/               # Plugin configurations
│   └── lsp_config.lua         # Language server settings
├── zshrc                      # Zsh shell configuration
├── ghostty.config             # Ghostty terminal settings (macOS)
├── ghostty.config.linux       # Ghostty terminal settings (Linux)
├── aerospace/                # Aerospace window manager config
│   └── aerospace.toml        # Aerospace settings
├── agents/                    # AI agent prompts
├── commands/sc/               # Custom slash commands
└── claude_settings.json.template # Claude Code configuration template
```

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
- Ghostty: Edit `ghostty.config`
- Theme: Run `p10k configure`

### AI
- Claude settings: Auto-generated from `claude_settings.json.template`
- Add agents: Create in `agents/`
- Add commands: Create in `commands/sc/`

### Remote Ghostty Setup
```bash
# Send terminfo to remote server
infocmp -x xterm-ghostty | ssh YOUR-SERVER -- tic -x -
```

## 📋 Requirements

- macOS or Linux
- Git, Make
- Neovim 0.8+
- Node.js (for LSP servers)
- Python 3, Go (optional)

## 📝 License

MIT
