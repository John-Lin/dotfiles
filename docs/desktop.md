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
- `omarchy/hypr/` - Hyprland configuration
- `omarchy/pre-install.sh` - setup script
- `omarchy/fix-brcmfmac/` - Broadcom Wi-Fi workaround

Notes:
- Monitor setup: copy the appropriate `monitors.conf.*` to `monitors.conf`
- Wi-Fi fix: see `omarchy/fix-brcmfmac/README.md`

## Portability Notes

This repo supports both macOS and Linux, but several areas are intentionally machine- or OS-specific:

- `zsh/` assumes a macOS/Homebrew-oriented environment in several places
- `aerospace/` and `borders/` only make sense on macOS
- `omarchy/` is Linux-specific and includes Arch-oriented assumptions
- terminal configs differ between macOS and Linux
