# Dotfiles

Personal dotfiles for macOS and Linux, managed with `make` and `GNU Stow`.

## Quick Start

```bash
# Clone the repository
git clone https://github.com/John-Lin/dotfiles ~/dotfiles
cd ~/dotfiles

# Show available install targets
make sync

# Common installs
make sync-zsh
make sync-neovim
make sync-ghostty
```

Most sync targets fail fast if the destination already contains unmanaged files or symlinks.
Use the corresponding `*-force` target only when you explicitly want to replace local contents.

## Common Commands

```bash
make sync-neovim        # Neovim configuration
make sync-zsh           # Zsh shell configuration
make sync-tig           # Tig Git interface
make sync-ghostty       # Ghostty terminal (macOS)
make sync-ghostty-linux # Ghostty terminal (Linux)
make sync-aerospace     # Aerospace window manager + Borders (macOS)

make sync-ghostty-linux-force

make test
make clean
```

- `make test` runs syntax checks, linting, safety regression tests, and sync smoke tests.
- `make clean` removes repo-managed symlinks and generated files while preserving unmanaged local files.

## Neovim Plugin Sync

When the automated lazy.nvim lockfile PR is merged, pull the repo and then sync your local plugin installs to the updated lockfile:

```bash
git pull
nvim --headless "+Lazy! restore" +qa
```

Inside Neovim you can do the same thing with `:Lazy` and then press `R`.
Use restore here, not update: `restore` matches your local plugins to `lazy-lock.json`, while `update` moves plugins forward and rewrites the lockfile.

## Repo Layout

- `nvim/` - Neovim configuration
- `zsh/` - Zsh shell configuration
- `tig/` - Tig configuration
- `ghostty/` - Ghostty config for macOS
- `ghostty-linux/` - Ghostty config for Linux, including `custom.conf`
- `aerospace/`, `borders/` - macOS window management
- `omarchy/` - Linux desktop and Hyprland-related setup

## Platform Notes

- This repo is portable enough for personal reuse, but it is still opinionated and machine-specific in places.
- `zsh/.zshrc` still assumes a macOS/Homebrew-oriented toolchain.
- `aerospace/` and `borders/` are macOS-specific.
- `omarchy/` is Linux-specific and includes Arch-oriented setup.
- Put machine-specific secrets and overrides in `~/.zshrc.local`.

## AI Agent Config

Claude Code, OpenCode, ccstatusline, and pi config now live in a separate repo:
[agent-configs](https://github.com/John-Lin/agent-configs).

## More Docs

- `docs/neovim.md` - plugins, language support, key bindings, Neovim customization
- `docs/shell.md` - aliases, terminal setup, local shell overrides
- `docs/desktop.md` - Aerospace, Borders, Omarchy, and Linux desktop notes
- `omarchy/fix-brcmfmac/README.md` - Broadcom Wi-Fi workaround

## Requirements

Essential:
- macOS or Linux
- Git
- Make
- GNU Stow
- `jq`
- Neovim (recent version; current config uses modern built-in LSP APIs)
- Node.js

Optional:
- Python 3, Go
- ripgrep, bat, eza, zoxide, fzf
- bun
- alacritty

## License

MIT
