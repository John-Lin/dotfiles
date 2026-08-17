#!/bin/bash

set -euo pipefail

REPO_ROOT=$(pwd)
CONFIG="$REPO_ROOT/tmux/.config/tmux/tmux.conf"
SOCKET="dotfiles-tmux-test-$$"

cleanup() {
	env -u TMUX tmux -L "$SOCKET" kill-server 2>/dev/null || true
}

trap cleanup EXIT

assert_equal() {
	local expected="$1"
	local actual="$2"
	local description="$3"

	if [ "$actual" != "$expected" ]; then
		printf 'Expected %s to be %q, got %q\n' "$description" "$expected" "$actual" >&2
		exit 1
	fi
}

assert_contains() {
	local value="$1"
	local expected="$2"
	local description="$3"

	if [[ "$value" != *"$expected"* ]]; then
		printf 'Expected %s to contain %q, got %q\n' "$description" "$expected" "$value" >&2
		exit 1
	fi
}

assert_not_contains() {
	local value="$1"
	local unexpected="$2"
	local description="$3"

	if [[ "$value" == *"$unexpected"* ]]; then
		printf 'Expected %s to omit %q, got %q\n' "$description" "$unexpected" "$value" >&2
		exit 1
	fi
}

tmux_test() {
	env -u TMUX tmux -L "$SOCKET" "$@"
}

main() {
	cd "$REPO_ROOT"

	tmux_test -f /dev/null new-session -d
	tmux_test source-file "$CONFIG"

	assert_equal 'C-Space' "$(tmux_test show-options -gv prefix)" 'tmux prefix'
	assert_equal 'tmux-256color' "$(tmux_test show-options -gv default-terminal)" 'default terminal'
	assert_equal 'external' "$(tmux_test show-options -gv set-clipboard)" 'clipboard integration'
	assert_equal '10' "$(tmux_test show-options -sv escape-time)" 'escape time'
	assert_equal '100000' "$(tmux_test show-options -gv history-limit)" 'history limit'
	assert_equal 'off' "$(tmux_test show-options -wgv aggressive-resize)" 'aggressive resize'
	assert_equal 'off' "$(tmux_test show-options -gv set-titles)" 'terminal title updates'

	local terminal_overrides
	terminal_overrides=$(tmux_test show-options -gqv terminal-overrides)
	assert_not_contains "$terminal_overrides" 'smcup@' 'terminal overrides'
	assert_not_contains "$terminal_overrides" 'rmcup@' 'terminal overrides'
	assert_not_contains "$terminal_overrides" ':Tc' 'terminal overrides'

	assert_equal "$HOME/.local/share/tmux/plugins/" \
		"$(tmux_test show-environment -g TMUX_PLUGIN_MANAGER_PATH | cut -d= -f2-)" \
		'TPM plugin path'

	local status_left
	status_left=$(tmux_test show-options -gv status-left)
	assert_not_contains "$status_left" '#{prefix_highlight}' 'status-left'
	assert_contains "$status_left" 'client_prefix' 'status-left'

	local copy_bindings
	copy_bindings=$(tmux_test list-keys -T copy-mode-vi)
	assert_contains "$copy_bindings" 'y' 'copy-mode bindings'
	assert_contains "$copy_bindings" 'copy-selection-and-cancel' 'copy-mode bindings'
	assert_not_contains "$copy_bindings" 'pbcopy' 'copy-mode bindings'

	assert_not_contains "$(<"$CONFIG")" 'tmux-plugins/tmux-yank' 'tmux plugins'
	assert_not_contains "$(<"$CONFIG")" 'tmux-plugins/tmux-sensible' 'tmux plugins'
	assert_not_contains "$(<"$CONFIG")" 'tmux-plugins/tmux-prefix-highlight' 'tmux plugins'

	local sync_binding
	sync_binding=$(tmux_test list-keys -T prefix | grep -E '[[:space:]]C-s[[:space:]]')
	assert_contains "$sync_binding" 'fg=colour148' 'synchronize-panes binding'
	assert_not_contains "$sync_binding" 'pane-border-format' 'synchronize-panes binding'

	if tmux_test list-keys -T edit-mode-vi >/dev/null 2>&1; then
		printf 'Expected edit-mode-vi table to be absent\n' >&2
		exit 1
	fi
}

main "$@"
