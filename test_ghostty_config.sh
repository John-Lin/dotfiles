#!/bin/bash
# Run after editing the Linux Ghostty custom config to check effective settings.

set -euo pipefail

if [[ "${1:-}" == "--help" ]]; then
	printf 'Usage: bash test_ghostty_config.sh\nValidate the Linux custom config with Ghostty and check clipboard settings.\n'
	exit 0
fi

command -v ghostty >/dev/null || { printf 'Ghostty is required for this test.\n' >&2; exit 1; }
REPO_ROOT=$(cd -- "$(dirname -- "$0")" && pwd)
TEST_CONFIG_HOME=$(mktemp -d)
trap 'rm -rf "$TEST_CONFIG_HOME"' EXIT
mkdir -p "$TEST_CONFIG_HOME/ghostty"
ln -s "$REPO_ROOT/ghostty-linux/.config/ghostty/custom.conf" "$TEST_CONFIG_HOME/ghostty/config"

XDG_CONFIG_HOME="$TEST_CONFIG_HOME" ghostty +validate-config
config=$(XDG_CONFIG_HOME="$TEST_CONFIG_HOME" ghostty +show-config --no-pager)
defaults=$(ghostty +show-config --default --no-pager)
notifications=$(grep '^app-notifications = ' <<<"$config" || grep '^app-notifications = ' <<<"$defaults")

if [[ "$notifications" != 'app-notifications = clipboard-copy,config-reload' ]]; then
	printf 'Expected copy and reload notifications enabled, got: %s\n' "$notifications" >&2
	exit 1
fi

if ! grep -Fxq 'copy-on-select = clipboard' <<<"$config"; then
	printf 'Expected selection copying to the system clipboard to remain enabled.\n' >&2
	exit 1
fi

printf 'Ghostty configuration checks passed.\n'
