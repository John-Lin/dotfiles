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

Tracked plugins include:

- `lazy.nvim` - plugin management
- `lazydev.nvim` - Lua development support for Neovim runtime
- `Telescope` - fuzzy finder
- `nvim-tree` - file explorer
- `Mason` + `nvim-lspconfig` - LSP installation and wiring
- `nvim-cmp` - auto-completion
- `nvim-autopairs` - bracket/quote pairing
- `claudecode.nvim` - Claude AI assistance
- `opencode.nvim` - OpenCode AI assistance
- `copilot.vim` - GitHub Copilot integration
- `nvim-treesitter` + textobjects - syntax highlighting, parsing, and text objects
- `none-ls.nvim` - formatting and linting integration
- `snacks.nvim` - OpenCode picker/input helpers and terminal utilities
- `which-key.nvim` - keymap discovery
- `Comment.nvim` - commenting helpers
- `trim.nvim` - whitespace trimming helpers
- `nvim-jsonnet` - Jsonnet filetype support
- `vim-fugitive` - Git integration

## Language Support

| Language | LSP Server | Tools |
|----------|------------|-------|
| Python | `basedpyright` + `ruff` + `ty` | Type checking, Ruff formatting |
| Go | `gopls` | `gofmt`, `goimports`, and `gopls` with `gofumpt` enabled |
| Lua | `lua_ls` | `lazydev` integration |
| Terraform | `terraformls` | LSP formatting via `<Leader>f` |
| YAML/Helm | `yamlls` + `helm_ls` | Schema validation |
| JSONNet | `jsonnet_ls` | `nvim-jsonnet` filetype support |
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
- `af` - focus Claude
- `ar` - resume Claude
- `aC` - continue Claude
- `as` - send selection in visual mode, or add the current tree file
- `aa/ad` - accept/deny diff

### OpenCode AI

- `<C-a>` - ask OpenCode about the current selection/context
- `<C-x>` - open the OpenCode action picker
- `<C-.>` - toggle OpenCode
- `go` / `goo` - send a range or line to OpenCode
- `<S-C-u>` / `<S-C-d>` - scroll the OpenCode session buffer
- `+` / `-` - keep increment/decrement available after remapping `<C-a>` / `<C-x>`

## Customization

- Plugins: edit `lua/plugins/`
- LSP: modify `lua/lsp_config.lua`
- Auto-open file tree is enabled by default via `vim.g.auto_open_nvim_tree = true` in `init.lua`
- Format-on-save is disabled; use `<Leader>f` for manual formatting
