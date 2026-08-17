#!/bin/bash

set -euo pipefail

REPO_ROOT=$(pwd)
CONFIG="$REPO_ROOT/tmux/.config/tmux/tmux.conf"
SOCKET="dotfiles-tmux-test-$$"
SUBAGENT_SOCKET="/tmp/dotfiles-test-$$-tmux-subagents.sock"
TEST_HOME=$(mktemp -d)
TEST_XDG_DATA_HOME="$TEST_HOME/xdg-data"
CONTROL_CLIENT_PID=''

cleanup() {
	HOME="$TEST_HOME" XDG_DATA_HOME="$TEST_XDG_DATA_HOME" env -u TMUX tmux -L "$SOCKET" kill-server 2>/dev/null || true
	HOME="$TEST_HOME" XDG_DATA_HOME="$TEST_XDG_DATA_HOME" env -u TMUX tmux -S "$SUBAGENT_SOCKET" kill-server 2>/dev/null || true
	if [ -n "$CONTROL_CLIENT_PID" ]; then
		kill "$CONTROL_CLIENT_PID" 2>/dev/null || true
	fi
	rm -rf "$TEST_HOME"
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
	HOME="$TEST_HOME" XDG_DATA_HOME="$TEST_XDG_DATA_HOME" env -u TMUX tmux -L "$SOCKET" "$@"
}

subagent_tmux_test() {
	HOME="$TEST_HOME" XDG_DATA_HOME="$TEST_XDG_DATA_HOME" env -u TMUX tmux -S "$SUBAGENT_SOCKET" "$@"
}

assert_session_created_via_binding() {
	local client="$1"
	local session_name="$2"
	local sessions
	local attempt

	tmux_test send-keys -K -t "$client" C-Space
	tmux_test send-keys -K -t "$client" N
	tmux_test send-keys -Kl -t "$client" "$session_name"
	tmux_test send-keys -K -t "$client" Enter

	for ((attempt = 0; attempt < 50; attempt++)); do
		sessions=$(tmux_test list-sessions -F '#{session_name}')
		if grep -Fxq -- "$session_name" <<<"$sessions"; then
			return 0
		fi
		sleep 0.02
	done

	printf 'Expected session binding to preserve name %q, got:\n%s\n' "$session_name" "$sessions" >&2
	return 1
}

main() {
	cd "$REPO_ROOT"

	tmux_test -f "$CONFIG" new-session -d
	tmux_test source-file "$CONFIG"

	assert_equal 'C-Space' "$(tmux_test show-options -gv prefix)" 'tmux prefix'
	assert_contains "$(<"$CONFIG")" 'set -g default-terminal "tmux-256color"' 'tmux config'
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

	assert_not_contains "$(<"$CONFIG")" 'TMUX_PLUGIN_MANAGER_PATH' 'tmux config'
	assert_not_contains "$(<"$CONFIG")" 'tmux-plugins/' 'tmux config'
	assert_not_contains "$(<"$CONFIG")" 'tmux-open' 'tmux config'

	local status_left
	status_left=$(tmux_test show-options -gv status-left)
	assert_not_contains "$status_left" '#{prefix_highlight}' 'status-left'
	assert_contains "$status_left" 'client_prefix' 'status-left'

	local copy_bindings
	copy_bindings=$(tmux_test list-keys -T copy-mode-vi)
	assert_contains "$copy_bindings" 'y' 'copy-mode bindings'
	assert_contains "$copy_bindings" 'copy-selection-and-cancel' 'copy-mode bindings'
	assert_not_contains "$copy_bindings" 'pbcopy' 'copy-mode bindings'

	local prefix_bindings
	prefix_bindings=$(tmux_test list-keys -T prefix)
	assert_not_contains "$prefix_bindings" '/tpm/' 'prefix bindings'

	local sync_binding
	sync_binding=$(grep -E '[[:space:]]C-s[[:space:]]' <<<"$prefix_bindings")
	assert_contains "$sync_binding" 'fg=colour148' 'synchronize-panes binding'
	assert_not_contains "$sync_binding" 'pane-border-format' 'synchronize-panes binding'

	local new_session_binding
	new_session_binding=$(grep -E '[[:space:]]N[[:space:]]' <<<"$prefix_bindings" || true)
	assert_contains "$new_session_binding" 'command-prompt' 'new-session binding'
	assert_contains "$new_session_binding" 'new-session -s' 'new-session binding'
	assert_contains "$new_session_binding" "%%%" 'quote-safe new-session binding'

	local control_input="$TEST_HOME/control-input"
	local control_output="$TEST_HOME/control-output"
	local control_client=''
	local attempt
	mkfifo "$control_input"
	exec 9<>"$control_input"
	tmux_test -C attach-session <&9 >"$control_output" 2>&1 &
	CONTROL_CLIENT_PID=$!
	for ((attempt = 0; attempt < 50; attempt++)); do
		control_client=$(tmux_test list-clients -F '#{client_name}' 2>/dev/null | head -1 || true)
		[ -n "$control_client" ] && break
		sleep 0.02
	done
	if [ -z "$control_client" ]; then
		printf 'Expected tmux control client to attach\n' >&2
		exit 1
	fi
	assert_session_created_via_binding "$control_client" "session with spaces"
	assert_session_created_via_binding "$control_client" "session'quote"
	assert_session_created_via_binding "$control_client" 'session"quote'

	local choose_session_binding
	choose_session_binding=$(grep -E '[[:space:]]S[[:space:]]' <<<"$prefix_bindings" || true)
	assert_contains "$choose_session_binding" 'choose-tree -Zs' 'session picker binding'

	if tmux_test list-keys -T edit-mode-vi >/dev/null 2>&1; then
		printf 'Expected edit-mode-vi table to be absent\n' >&2
		exit 1
	fi

	subagent_tmux_test -f "$CONFIG" new-session -d

	assert_equal 'C-b' "$(subagent_tmux_test show-options -gv prefix)" 'subagent tmux prefix'
	assert_equal '0' "$(subagent_tmux_test show-options -gv base-index)" 'subagent window base index'
	assert_equal '0' "$(subagent_tmux_test show-options -wgv pane-base-index)" 'subagent pane base index'
	assert_equal 'off' "$(subagent_tmux_test show-options -gv status)" 'subagent status bar'
	assert_equal '0.0' \
		"$(subagent_tmux_test list-panes -F '#{window_index}.#{pane_index}')" \
		'subagent initial target'

}

main "$@"
