#!/bin/bash

set -euo pipefail

REPO_ROOT=$(pwd)

assert_exists() {
	if [ ! -e "$1" ]; then
		printf 'Expected path to exist: %s\n' "$1" >&2
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

main() {
	local home_dir
	home_dir=$(mktemp -d)

	cd "$REPO_ROOT"

	HOME="$home_dir" make sync-neovim
	assert_exists "$home_dir/.config/nvim/init.lua"

	HOME="$home_dir" make sync-zsh
	assert_symlink_resolves_to "$home_dir/.zshrc" "$REPO_ROOT/zsh/.zshrc"
	assert_symlink_resolves_to "$home_dir/.p10k.zsh" "$REPO_ROOT/zsh/.p10k.zsh"

	HOME="$home_dir" make sync-tig
	assert_symlink_resolves_to "$home_dir/.tigrc" "$REPO_ROOT/tig/.tigrc"

	HOME="$home_dir" make sync-ccstatusline
	assert_symlink_resolves_to "$home_dir/.config/ccstatusline/settings.json" "$REPO_ROOT/ccstatusline/.config/ccstatusline/settings.json"

	HOME="$home_dir" make sync-opencode
	assert_symlink_resolves_to "$home_dir/.config/opencode/agents" "$REPO_ROOT/opencode/agents"

	HOME="$home_dir" make sync-claude
	assert_exists "$home_dir/.claude/CLAUDE.md"
	assert_exists "$home_dir/.claude/settings.json"
	assert_symlink_resolves_to "$home_dir/.claude/agents" "$REPO_ROOT/claude/.claude/agents"
	assert_symlink_resolves_to "$home_dir/.claude/commands" "$REPO_ROOT/claude/.claude/commands"
	assert_symlink_resolves_to "$home_dir/.claude/skills" "$REPO_ROOT/claude/.claude/skills"
}

main "$@"
