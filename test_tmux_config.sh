#!/bin/bash

set -euo pipefail

REPO_ROOT=$(pwd)
CONFIG="$REPO_ROOT/tmux/.config/tmux/tmux.conf"
SOCKET="dotfiles-tmux-test-$$"
SUBAGENT_SOCKET="/tmp/dotfiles-test-$$-tmux-subagents.sock"

cleanup() {
	env -u TMUX tmux -L "$SOCKET" kill-server 2>/dev/null || true
	env -u TMUX tmux -S "$SUBAGENT_SOCKET" kill-server 2>/dev/null || true
	rm -f "$SUBAGENT_SOCKET"
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

subagent_tmux_test() {
	env -u TMUX tmux -S "$SUBAGENT_SOCKET" "$@"
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

	local prefix_bindings
	prefix_bindings=$(tmux_test list-keys -T prefix)

	local sync_binding
	sync_binding=$(grep -E '[[:space:]]C-s[[:space:]]' <<<"$prefix_bindings")
	assert_contains "$sync_binding" 'fg=colour148' 'synchronize-panes binding'
	assert_not_contains "$sync_binding" 'pane-border-format' 'synchronize-panes binding'

	local new_session_binding
	new_session_binding=$(grep -E '[[:space:]]N[[:space:]]' <<<"$prefix_bindings" || true)
	assert_contains "$new_session_binding" 'command-prompt' 'new-session binding'
	assert_contains "$new_session_binding" 'new-session -s' 'new-session binding'

	local choose_session_binding
	choose_session_binding=$(grep -E '[[:space:]]S[[:space:]]' <<<"$prefix_bindings" || true)
	assert_contains "$choose_session_binding" 'choose-tree -Zs' 'session picker binding'

	if tmux_test list-keys -T edit-mode-vi >/dev/null 2>&1; then
		printf 'Expected edit-mode-vi table to be absent\n' >&2
		exit 1
	fi

	subagent_tmux_test -f /dev/null new-session -d
	subagent_tmux_test source-file "$CONFIG"

	assert_equal 'C-b' "$(subagent_tmux_test show-options -gv prefix)" 'subagent tmux prefix'
	assert_equal '0' "$(subagent_tmux_test show-options -gv base-index)" 'subagent window base index'
	assert_equal '0' "$(subagent_tmux_test show-options -wgv pane-base-index)" 'subagent pane base index'
	assert_equal 'off' "$(subagent_tmux_test show-options -gv status)" 'subagent status bar'
	assert_equal '0.0' \
		"$(subagent_tmux_test list-panes -F '#{window_index}.#{pane_index}')" \
		'subagent initial target'

	if subagent_tmux_test show-environment -g TMUX_PLUGIN_MANAGER_PATH >/dev/null 2>&1; then
		printf 'Expected subagent tmux to skip TPM configuration\n' >&2
		exit 1
	fi
}

main "$@"
