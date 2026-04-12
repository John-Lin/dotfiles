# Shell And Terminal

## Shell

Zsh config is installed with:

```bash
make sync-zsh
```

Tracked shell files:
- `zsh/.zshrc`
- `zsh/.p10k.zsh`

Machine-specific secrets and overrides should go in:

```bash
~/.zshrc.local
```

`zsh/.zshrc` sources `~/.zshrc.local` automatically when it exists.

## Common Aliases

| Alias | Command | Purpose |
|-------|---------|---------|
| `grep` | `rg` | ripgrep search |
| `cat` | `bat` | syntax-highlighted file output |
| `vim` / `vi` | `nvim` | Neovim |
| `vimdiff` | `nvim -d` | Neovim diff mode |
| `ls` | `eza` | modern ls replacement |
| `lsa` | `ls -a` | list all files including hidden |
| `lt` | `eza --tree` | tree view with git info |
| `lta` | `lt -a` | tree view with all files |
| `ff` | `fzf --preview 'bat ...'` | fzf with preview |
| `cd` | `zd` | zoxide smart cd |
| `python` | `python3` | Python 3 |
| `kubectl` | `kubecolor` | colored kubectl output |

## Ghostty

Install:

```bash
make sync-ghostty
make sync-ghostty-linux
```

Files:
- `ghostty/.config/ghostty/config` - macOS Ghostty config
- `ghostty-linux/.config/ghostty/config` - Linux Ghostty config
- `ghostty-linux/.config/ghostty/custom.conf` - extra Linux overrides

If Linux already has `~/.config/ghostty/config`, `make sync-ghostty-linux` only installs `custom.conf`.
If `custom.conf` already exists with unmanaged contents, the sync stops unless you use `make sync-ghostty-linux-force`.

## Alacritty

- Config file: `alacritty/alacritty.toml`
- This is manual setup, not stow-managed by the Makefile flow

## Remote Ghostty Setup

```bash
infocmp -x xterm-ghostty | ssh YOUR-SERVER -- tic -x -
```
