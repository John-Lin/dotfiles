# Neovim

## Overview

Neovim config lives in `nvim/.config/nvim/` and is installed with:

```bash
make sync-neovim
```

## Main Files

- `init.lua` - entry point
- `lua/` - plugins, providers, and LSP setup
- `lazy-lock.json` - plugin lockfile

## Plugins

- `lazy.nvim` - plugin management
- `lazydev.nvim` - Lua development support for Neovim runtime
- `Telescope` - fuzzy finder
- `nvim-tree` - file explorer
- `Mason` - LSP installer
- `nvim-cmp` - auto-completion
- `claudecode.nvim` - Claude AI assistance
- `opencode.nvim` - OpenCode AI assistance
- `copilot.vim` - GitHub Copilot integration
- `nvim-treesitter` - syntax highlighting and parsing
- `none-ls.nvim` - formatting and linting integration
- `snacks.nvim` - QoL plugin collection
- `Comment.nvim` - commenting helpers
- `vim-fugitive` - Git integration

## Language Support

| Language | LSP Server | Tools |
|----------|------------|-------|
| Python | `basedpyright` + `ruff` + `ty` | Type checking, formatting |
| Go | `gopls` | `gofumpt` formatting |
| Lua | `lua_ls` | `lazydev` integration |
| Terraform | `terraformls` | Auto-formatting |
| YAML/Helm | `yamlls` + `helm_ls` | Schema validation |
| C/C++ | `clangd` | `clang-format` |

## Key Bindings

### Essential

- `<Space>` - leader key
- `<Leader>t` - toggle file tree
- `<Leader>f` - format code
- `gd` - go to definition
- `K` - show hover docs

### LSP And Diagnostics

- `[d` / `]d` - previous/next diagnostic
- `<Leader>e` - open diagnostic float
- `<Leader>q` - open diagnostic location list
- `gD` - go to declaration
- `gi` - go to implementation
- `<Leader>k` - signature help
- `<Leader>rn` - rename symbol
- `<Leader>ca` - code action
- `<Leader>gr` - show references
- `<Leader>D` - type definition

### Claude AI (`<Leader>a` prefix)

- `ac` - toggle Claude
- `as` - send selection
- `aa/ad` - accept/deny diff

## Customization

- Plugins: edit `lua/plugins/`
- LSP: modify `lua/lsp_config.lua`
- Auto-open file tree: set `vim.g.auto_open_nvim_tree = true` in `init.lua`
