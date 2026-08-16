# Desktop And Platform-Specific Config

## Aerospace And Borders

macOS window-management config lives in:

- `aerospace/.config/aerospace/aerospace.toml`
- `borders/.config/borders/bordersrc`

Install with:

```bash
make sync-aerospace
```

These configs are macOS-specific and include `osascript`-based workflows.

## Omarchy / Hyprland

Linux desktop-related config lives in `omarchy/`.

Key areas:
- `omarchy/hypr/` - Hyprland configuration (Omarchy 3 `.conf` format, reference only)
- `omarchy/MIGRATION-4.0.md` - porting these configs to Omarchy 4's Lua config
- `omarchy/pre-install.sh` - setup script
- `omarchy/fix-brcmfmac/` - Broadcom Wi-Fi workaround

Notes:
- Omarchy 4.0 replaced the Hyprland `.conf` tree with Lua. `omarchy/hypr/*.conf`
  is kept as the record of the old setup, not as something to install. Follow
  `omarchy/MIGRATION-4.0.md` when setting up a 4.x machine.
- Monitor setup: copy the appropriate `monitors.conf.*` to `monitors.conf`
- Wi-Fi fix: see `omarchy/fix-brcmfmac/README.md`

## Portability Notes

This repo supports both macOS and Linux, but several areas are intentionally machine- or OS-specific:

- `zsh/` assumes a macOS/Homebrew-oriented environment in several places
- `aerospace/` and `borders/` only make sense on macOS
- `omarchy/` is Linux-specific and includes Arch-oriented assumptions
- terminal configs differ between macOS and Linux
