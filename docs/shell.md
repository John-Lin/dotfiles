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

## Remote Ghostty SSH

Both Ghostty configs enable `ssh-env` and explicitly disable `ssh-terminfo`. For interactive `ssh` commands, Ghostty's shell integration uses `TERM=xterm-256color` instead of installing the `xterm-ghostty` terminfo entry. It also requests forwarding for `COLORTERM`, `TERM_PROGRAM`, and `TERM_PROGRAM_VERSION`; the remote SSH server may discard those optional variables unless its `AcceptEnv` configuration permits them.

Ghostty injects shell integration only into the shell it launches directly. The tracked `.zshrc` sources the official integration when `GHOSTTY_RESOURCES_DIR` is present so the SSH wrapper also remains available inside tmux-created zsh shells.

The wrapper applies to interactive `ssh` entered in that shell. Tools that launch SSH themselves, such as Git, `scp`, `rsync`, `mosh`, and non-interactive scripts, do not inherit shell functions. See the [Ghostty SSH documentation](https://ghostty.org/docs/features/ssh) for those cases.
