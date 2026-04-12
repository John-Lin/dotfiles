# dotfiles

[![CI](https://github.com/John-Lin/dotfiles/actions/workflows/ci.yml/badge.svg)](https://github.com/John-Lin/dotfiles/actions/workflows/ci.yml)

Modern development environment configuration with Neovim, zsh, and AI-powered development tools.

## ✨ Features

- **🚀 Modern Neovim** - LSP, auto-completion, and AI assistance
- **💻 Enhanced Shell** - zsh with powerlevel10k theme
- **🌍 Multi-language Support** - Python, Go, Lua, Terraform, YAML/Helm, C/C++
- **🤖 AI Integration** - Claude Code and OpenCode with custom agents and slash commands
- **🛠️ Developer Tools** - ripgrep, bat, eza, direnv, Kubernetes tooling
- **🖥️ Terminal Options** - Ghostty (macOS/Linux), Alacritty
- **🪟 Window Management** - Aerospace tiling window manager with Borders integration (macOS), Hyprland (Linux)

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

# Install specific components (make sync now shows available options)
make sync

# Install individual components
make sync-neovim        # Neovim configuration
make sync-zsh           # Zsh shell configuration
make sync-tig           # Tig Git interface
make sync-ghostty       # Ghostty terminal (macOS)
make sync-ghostty-linux # Ghostty terminal (Linux)
make sync-claude        # Claude Code AI tools
make sync-ccstatusline  # ccstatusline config
make sync-opencode      # OpenCode subagents
make sync-aerospace     # Aerospace window manager + Borders (macOS)

# Force install when a target already exists with unmanaged contents
make sync-ghostty-linux-force
make sync-claude-force
make sync-opencode-force
```

Most sync targets now fail fast when the destination already contains unmanaged files or symlinks. Use the corresponding `*-force` target only when you want to replace local contents explicitly.

**Testing**: `make test` (runs syntax checks, linting, safety regression tests, and sync smoke tests)

**Uninstall**: `make clean` (removes repo-managed symlinks and generated files while preserving unmanaged local files)

## 📁 Structure

**Repository directories** (most are stow-managed packages; some are manual/utility configs):

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
│   └── .config/ghostty/       # → ~/.config/ghostty/
│       ├── config             # Main Ghostty Linux config
│       └── custom.conf        # Extra local keybindings/options managed separately
├── alacritty/                 # Alacritty terminal (manual setup)
│   └── alacritty.toml         # → ~/alacritty.toml
├── claude/                    # Claude Code AI tools
│   ├── .claude/               # Config files (direct symlinks to ~/.claude/)
│   │   ├── CLAUDE.base.md     # Generic engineering principles (tracked)
│   │   ├── CLAUDE.personal.md.example  # Personal config template (tracked)
│   │   ├── CLAUDE.personal.md # Your personal config (gitignored)
│   │   ├── agents/            # → ~/.claude/agents/ (AI agent prompts)
│   │   ├── commands/          # → ~/.claude/commands/ (custom slash commands)
│   │   └── skills/            # → ~/.claude/skills/ (reusable skills)
│   ├── claude_settings.json.template          # Base settings template (tracked)
│   └── claude_settings.personal.json.example # Personal settings template (tracked)
│   # claude_settings.personal.json           # Your personal overrides (gitignored)
├── ccstatusline/              # ccstatusline configuration
│   └── .config/ccstatusline/  # → ~/.config/ccstatusline/
│       └── settings.json      # ccstatusline widgets/theme settings
├── opencode/                  # OpenCode AI tools
│   └── agents/                # → ~/.config/opencode/agents/ (subagent prompts)
├── aerospace/                 # Aerospace window manager (macOS)
│   └── .config/aerospace/     # → ~/.config/aerospace/
│       └── aerospace.toml     # Window management config
├── borders/                   # Window borders decoration (macOS)
│   └── .config/borders/       # → ~/.config/borders/
│       └── bordersrc          # Borders configuration
└── omarchy/                   # Hyprland desktop environment (manual setup)
    ├── hypr/                  # Hyprland configuration
    ├── fix-brcmfmac/          # WiFi fix for brcmfmac
    └── pre-install.sh         # Setup script
```

**Configuration files:**
- `Makefile` - Installation and management commands
- `claude/claude_settings.json.template` - Claude Code settings template

## 🎯 Key Components

### Neovim Plugins
- **lazy.nvim** - Plugin management
- **lazydev.nvim** - Lua development support for Neovim runtime
- **Telescope** - Fuzzy finder
- **nvim-tree** - File explorer
- **Mason** - LSP installer
- **nvim-cmp** - Auto-completion
- **claudecode.nvim** - Claude AI assistance
- **opencode.nvim** - OpenCode AI assistance
- **copilot.vim** - GitHub Copilot integration
- **nvim-treesitter** - Syntax highlighting and parsing
- **none-ls.nvim** - Null-ls replacement for formatting/linting
- **snacks.nvim** - Collection of QoL plugins
- **Comment.nvim** - Smart commenting
- **vim-fugitive** - Git integration

### Language Support

| Language | LSP Server | Tools |
|----------|------------|-------|
| Python | `basedpyright` + `ruff` + `ty` | Type checking, formatting |
| Go | `gopls` | gofumpt formatting |
| Lua | `lua_ls` | lazydev integration |
| Terraform | `terraformls` | Auto-formatting |
| YAML/Helm | `yamlls` + `helm_ls` | Schema validation |
| C/C++ | `clangd` | clang-format |

## ⌨️ Key Bindings

### Essential
- `<Space>` - Leader key
- `<Leader>t` - Toggle file tree
- `<Leader>f` - Format code
- `gd` - Go to definition
- `K` - Show hover docs

### LSP & Diagnostics
- `[d` / `]d` - Previous/Next diagnostic
- `<Leader>e` - Open diagnostic float
- `<Leader>q` - Open diagnostic location list
- `gD` - Go to declaration
- `gi` - Go to implementation
- `<Leader>k` - Signature help
- `<Leader>rn` - Rename symbol
- `<Leader>ca` - Code action
- `<Leader>gr` - Show references
- `<Leader>D` - Type definition

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
| `vimdiff` | `nvim -d` | Neovim diff mode |
| `ls` | `eza` | modern ls replacement |
| `lsa` | `ls -a` | list all files including hidden |
| `lt` | `eza --tree` | tree view with git info |
| `lta` | `lt -a` | tree view with all files |
| `ff` | `fzf --preview 'bat ...'` | fzf with preview |
| `cd` | `zd` | zoxide smart cd |
| `python` | `python3` | Python 3 |
| `kubectl` | `kubecolor` | colored kubectl output |

## 🤖 AI Integration

### AI Agents (from [wshobson/agents](https://github.com/wshobson/agents))
- `architect-review` - Architecture review
- `code-reviewer` - Code quality review
- `debugger` - Debugging expert
- `golang-pro` - Go specialist
- `python-pro` - Python specialist
- `prompt-engineer` - Prompt optimization
- `terraform-specialist` - Terraform/OpenTofu specialist
- `c-pro` - C/C++ specialist

### OpenCode Subagents
- `make sync-opencode` symlinks `opencode/agents/` to `~/.config/opencode/agents`
- If `~/.config/opencode/agents` already contains unmanaged contents, `make sync-opencode` stops instead of replacing them
- Use `make sync-opencode-force` to replace an existing target explicitly
- Add/edit OpenCode subagents in `opencode/agents/`

### Skills (Reusable capabilities)
- `things-mac` - Integration with Things 3 task manager on macOS
- `uv-package-manager` - UV Python package management operations
- `test-driven-development` - Test-driven development workflow for features and fixes
- `gh-cli` - GitHub CLI workflow and references
- `find-docs` - Context7-powered documentation lookup

### Slash Commands (`/sc:<command>`)
- `/sc:analyze` - Deep code analysis
- `/sc:document` - Generate docs
- `/sc:explain` - Code explanation
- `/sc:troubleshoot` - Debug issues
- `/sc:index` - Project indexing

### Claude Settings

`~/.claude/settings.json` is generated by merging two files:

- `claude_settings.json.template` — shared base settings (tracked in git)
- `claude_settings.personal.json` — your personal overrides (gitignored)

`make sync-claude` uses `jq` to deep-merge them. Personal settings take precedence over the template.
If `~/.claude/CLAUDE.md`, `~/.claude/settings.json`, or the `agents/`, `commands/`, `skills/` links already contain unmanaged contents, `make sync-claude` stops instead of overwriting them. Use `make sync-claude-force` to replace local contents explicitly.

To set up personal settings:

```bash
cp claude/claude_settings.personal.json.example claude/claude_settings.personal.json
# edit as needed, then:
make sync-claude
```

ccstatusline itself is configured separately via `~/.config/ccstatusline/settings.json`.

### MCP Servers (Optional)

Add global MCP servers to Claude for enhanced capabilities:

```bash
# Context7 - Up-to-date library documentation
claude mcp add -s user --transport http context7 https://mcp.context7.com/mcp

# Sequential Thinking - Advanced reasoning
claude mcp add -s user sequential-thinking -- npx -y @modelcontextprotocol/server-sequential-thinking
```

## ⚙️ Customization

### Neovim
- Plugins: Edit `lua/plugins/`
- LSP: Modify `lua/lsp_config.lua`
- Auto-open file tree: Set `vim.g.auto_open_nvim_tree = true` in `init.lua`

### Terminal
- Ghostty: Edit `ghostty/.config/ghostty/config` or `ghostty-linux/.config/ghostty/config`
- Ghostty Linux custom overrides: Edit `ghostty-linux/.config/ghostty/custom.conf`
- Alacritty: Edit `alacritty/alacritty.toml`
- Theme: Run `p10k configure`

### Shell
- Machine-specific secrets and overrides: Put them in `~/.zshrc.local` instead of tracked files
- `zsh/.zshrc` automatically sources `~/.zshrc.local` if it exists

### AI
- Claude settings: `cp claude/claude_settings.personal.json.example claude/claude_settings.personal.json` and edit, then `make sync-claude`
- Personalize Claude instructions: `cp claude/.claude/CLAUDE.personal.md.example claude/.claude/CLAUDE.personal.md` and edit
- `make sync-claude` merges `CLAUDE.base.md` + `CLAUDE.personal.md` → `~/.claude/CLAUDE.md`
- `make sync-claude` is conservative and will not overwrite unmanaged Claude files; use `make sync-claude-force` to replace local contents explicitly
- `make sync-ccstatusline` symlinks `ccstatusline/.config/ccstatusline/settings.json` → `~/.config/ccstatusline/settings.json`
- Add agents: Create in `claude/.claude/agents/`
- Add commands: Create in `claude/.claude/commands/`
- Add skills: Create in `claude/.claude/skills/`
- `make sync-opencode` symlinks `opencode/agents/` → `~/.config/opencode/agents`
- `make sync-opencode` is conservative and will not overwrite unmanaged local contents; use `make sync-opencode-force` to replace them explicitly

### Window Management
- Aerospace: Edit `aerospace/.config/aerospace/aerospace.toml`
- Borders: Edit `borders/.config/borders/bordersrc`

### Linux Desktop (Omarchy/Hyprland)
- Hyprland: Edit `omarchy/hypr/` configuration files
- Monitor setup: Copy appropriate `monitors.conf.*` to `monitors.conf`
- WiFi fix: See `omarchy/fix-brcmfmac/` for brcmfmac issues

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
- `jq` (for merging Claude settings)
- Neovim 0.8+
- Node.js (for LSP servers)

**Optional:**
- Python 3, Go (language support)
- ripgrep, bat, eza, zoxide, fzf (enhanced shell tools)
- bun (for Claude Code status line)
- alacritty (GPU-accelerated terminal)

## 📝 License

MIT
