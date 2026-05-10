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

assert_not_exists() {
	if [ -e "$1" ]; then
		printf 'Expected path to not exist: %s\n' "$1" >&2
		exit 1
	fi
}

main() {
	local home_dir
	home_dir=$(mktemp -d)
	trap '[ -n "${home_dir-}" ] && rm -rf "$home_dir"' EXIT

	cd "$REPO_ROOT"

	assert_not_exists "$REPO_ROOT/claude/.claude/skills/web-browser"
	assert_not_exists "$REPO_ROOT/claude/.claude/skills/uv-package-manager/SKILL.md"
	assert_file_not_contains "$REPO_ROOT/claude/README.md" "skills/web-browser"
	assert_file_not_contains "$REPO_ROOT/claude/README.md" "uv-package-manager"
	assert_file_contains "$REPO_ROOT/docs/ai.md" '- `typescript-pro` - TypeScript specialist'
	assert_file_not_contains "$REPO_ROOT/docs/ai.md" "/sc:analyze"
	assert_file_not_contains "$REPO_ROOT/docs/ai.md" "web-browser"
	assert_file_not_contains "$REPO_ROOT/docs/ai.md" "uv-package-manager"
	assert_file_contains "$REPO_ROOT/README.md" 'make sync-pi'
	assert_file_not_contains "$REPO_ROOT/README.md" 'Neovim 0.8+'
	assert_file_contains "$REPO_ROOT/jsonnet/README.md" '| `gpt-5.5` | GPT-5.5 | 5.00 | 30.00 |'

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
	assert_exists "$home_dir/.config/opencode/opencode.json"
	assert_symlink_resolves_to "$home_dir/.config/opencode/agents" "$REPO_ROOT/opencode/agents"

	HOME="$home_dir" make sync-claude
	assert_exists "$home_dir/.claude/CLAUDE.md"
	assert_exists "$home_dir/.claude/settings.json"
	assert_symlink_resolves_to "$home_dir/.claude/agents" "$REPO_ROOT/claude/.claude/agents"
	assert_symlink_resolves_to "$home_dir/.claude/skills" "$REPO_ROOT/claude/.claude/skills"
	assert_not_exists "$home_dir/.claude/skills/web-browser"
	assert_not_exists "$home_dir/.claude/skills/uv-package-manager/SKILL.md"
}

main "$@"
