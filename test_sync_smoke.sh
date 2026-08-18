#!/bin/bash

set -euo pipefail

REPO_ROOT=$(pwd)

assert_exists() {
	if [ ! -e "$1" ]; then
		printf 'Expected path to exist: %s\n' "$1" >&2
		exit 1
	fi
}

assert_not_exists() {
	if [ -e "$1" ] || [ -L "$1" ]; then
		printf 'Expected path to be absent: %s\n' "$1" >&2
		exit 1
	fi
}

assert_symlink_resolves_to() {
	local path="$1"
	local expected="$2"

	if [ ! -L "$path" ]; then
		printf 'Expected symlink: %s\n' "$path" >&2
		exit 1
	fi

	if [ "$(realpath "$path")" != "$expected" ]; then
		printf 'Expected %s to resolve to %s\n' "$path" "$expected" >&2
		exit 1
	fi
}

assert_file_contains() {
	local path="$1"
	local needle="$2"

	if ! grep -Fq -- "$needle" "$path"; then
		printf 'Expected %s to contain: %s\n' "$path" "$needle" >&2
		exit 1
	fi
}

assert_file_not_contains() {
	local path="$1"
	local needle="$2"

	if grep -Fq -- "$needle" "$path"; then
		printf 'Expected %s to not contain: %s\n' "$path" "$needle" >&2
		exit 1
	fi
}

main() {
	local home_dir
	home_dir=$(mktemp -d)
	trap '[ -n "${home_dir-}" ] && rm -rf "$home_dir"' EXIT

	cd "$REPO_ROOT"

	assert_file_not_contains "$REPO_ROOT/README.md" 'Neovim 0.8+'
	assert_file_contains "$REPO_ROOT/.github/workflows/ci.yml" 'sudo apt-get install -y stow tmux'
	assert_file_contains "$REPO_ROOT/.github/workflows/ci.yml" 'make test-tmux-config'
	assert_file_contains "$REPO_ROOT/ghostty/.config/ghostty/config" 'ssh-env,no-ssh-terminfo'
	assert_file_contains "$REPO_ROOT/ghostty-linux/.config/ghostty/config" 'ssh-env,no-ssh-terminfo'
	assert_file_contains "$REPO_ROOT/zsh/.zshrc" 'shell-integration/zsh/ghostty-integration'
	assert_file_contains "$REPO_ROOT/docs/shell.md" 'TERM=xterm-256color'
	assert_file_not_contains "$REPO_ROOT/docs/shell.md" 'infocmp -x xterm-ghostty'
	assert_not_exists "$REPO_ROOT/xterm-ghostty.terminfo"

	HOME="$home_dir" make sync-neovim
	assert_exists "$home_dir/.config/nvim/init.lua"

	HOME="$home_dir" make sync-zsh
	assert_symlink_resolves_to "$home_dir/.zshrc" "$REPO_ROOT/zsh/.zshrc"
	assert_symlink_resolves_to "$home_dir/.p10k.zsh" "$REPO_ROOT/zsh/.p10k.zsh"

	HOME="$home_dir" make sync-tig
	assert_symlink_resolves_to "$home_dir/.tigrc" "$REPO_ROOT/tig/.tigrc"

	HOME="$home_dir" make sync-tmux
	assert_symlink_resolves_to "$home_dir/.config/tmux" "$REPO_ROOT/tmux/.config/tmux"
	assert_file_contains "$home_dir/.config/tmux/tmux.conf" 'set -g prefix C-Space'
	assert_file_not_contains "$home_dir/.config/tmux/tmux.conf" 'set -g prefix C-a'
}

main "$@"
