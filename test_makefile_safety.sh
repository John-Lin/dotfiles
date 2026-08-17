#!/bin/bash

set -euo pipefail

REPO_ROOT=$(pwd)
TEST_OUTPUT=$(mktemp /tmp/makefile-safety.out.XXXXXX)

cleanup() {
	rm -f "$TEST_OUTPUT"
}

trap cleanup EXIT

assert_file_exists() {
	if [ ! -f "$1" ]; then
		printf 'Expected file to exist: %s\n' "$1" >&2
		exit 1
	fi
}

assert_dir_exists() {
	if [ ! -d "$1" ]; then
		printf 'Expected directory to exist: %s\n' "$1" >&2
		exit 1
	fi
}

assert_path_absent() {
	if [ -e "$1" ] || [ -L "$1" ]; then
		printf 'Expected path to be absent: %s\n' "$1" >&2
		exit 1
	fi
}

assert_contains() {
	local file="$1"
	local expected="$2"

	if ! grep -Fq "$expected" "$file"; then
		printf 'Expected %s to contain: %s\n' "$file" "$expected" >&2
		exit 1
	fi
}

assert_symlink_target() {
	local path="$1"
	local expected="$2"

	if [ ! -L "$path" ]; then
		printf 'Expected symlink: %s\n' "$path" >&2
		exit 1
	fi

	if [ "$(readlink "$path")" != "$expected" ]; then
		printf 'Expected %s to point to %s\n' "$path" "$expected" >&2
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

assert_make_fails() {
	local home_dir="$1"
	shift

	if HOME="$home_dir" make "$@" >"$TEST_OUTPUT" 2>&1; then
		printf 'Expected make %s to fail\n' "$*" >&2
		cat "$TEST_OUTPUT" >&2
		exit 1
	fi
}

test_sync_ghostty_linux_preserves_existing_custom_conf() {
	local home_dir
	home_dir=$(mktemp -d)
	trap '[ -n "${home_dir-}" ] && rm -rf "$home_dir"' RETURN

	mkdir -p "$home_dir/.config/ghostty"
	printf 'base config\n' >"$home_dir/.config/ghostty/config"
	printf 'keep me\n' >"$home_dir/.config/ghostty/custom.conf"

	assert_make_fails "$home_dir" sync-ghostty-linux
	assert_file_exists "$home_dir/.config/ghostty/custom.conf"
	assert_contains "$home_dir/.config/ghostty/custom.conf" 'keep me'
}

test_sync_ghostty_linux_force_replaces_existing_custom_conf() {
	local home_dir
	home_dir=$(mktemp -d)
	trap '[ -n "${home_dir-}" ] && rm -rf "$home_dir"' RETURN

	mkdir -p "$home_dir/.config/ghostty"
	printf 'base config\n' >"$home_dir/.config/ghostty/config"
	printf 'replace me\n' >"$home_dir/.config/ghostty/custom.conf"

	HOME="$home_dir" make sync-ghostty-linux-force >"$TEST_OUTPUT" 2>&1
	assert_symlink_target "$home_dir/.config/ghostty/custom.conf" "$REPO_ROOT/ghostty-linux/.config/ghostty/custom.conf"
}

test_clean_neovim_preserves_unmanaged_directory_without_stow() {
	local home_dir
	home_dir=$(mktemp -d)
	trap '[ -n "${home_dir-}" ] && rm -rf "$home_dir"' RETURN

	mkdir -p "$home_dir/.config/nvim"
	printf 'keep me\n' >"$home_dir/.config/nvim/init.lua"

	PATH="/usr/bin:/bin" HOME="$home_dir" make clean-neovim >"$TEST_OUTPUT" 2>&1
	assert_dir_exists "$home_dir/.config/nvim"
	assert_file_exists "$home_dir/.config/nvim/init.lua"
	assert_contains "$home_dir/.config/nvim/init.lua" 'keep me'
}

test_clean_zsh_preserves_unmanaged_files_without_stow() {
	local home_dir
	home_dir=$(mktemp -d)
	trap '[ -n "${home_dir-}" ] && rm -rf "$home_dir"' RETURN

	printf 'keep me\n' >"$home_dir/.zshrc"
	printf 'keep me too\n' >"$home_dir/.p10k.zsh"

	PATH="/usr/bin:/bin" HOME="$home_dir" make clean-zsh >"$TEST_OUTPUT" 2>&1
	assert_file_exists "$home_dir/.zshrc"
	assert_file_exists "$home_dir/.p10k.zsh"
	assert_contains "$home_dir/.zshrc" 'keep me'
	assert_contains "$home_dir/.p10k.zsh" 'keep me too'
}

test_clean_ghostty_preserves_unmanaged_custom_conf_without_stow() {
	local home_dir
	home_dir=$(mktemp -d)
	trap '[ -n "${home_dir-}" ] && rm -rf "$home_dir"' RETURN

	mkdir -p "$home_dir/.config/ghostty"
	printf 'keep me\n' >"$home_dir/.config/ghostty/custom.conf"

	PATH="/usr/bin:/bin" HOME="$home_dir" make clean-ghostty >"$TEST_OUTPUT" 2>&1
	assert_file_exists "$home_dir/.config/ghostty/custom.conf"
	assert_contains "$home_dir/.config/ghostty/custom.conf" 'keep me'
}

test_sync_tmux_rejects_legacy_config() {
	local home_dir
	home_dir=$(mktemp -d)
	trap '[ -n "${home_dir-}" ] && rm -rf "$home_dir"' RETURN

	printf 'keep me\n' >"$home_dir/.tmux.conf"

	assert_make_fails "$home_dir" sync-tmux
	assert_file_exists "$home_dir/.tmux.conf"
	assert_contains "$home_dir/.tmux.conf" 'keep me'
}

test_sync_tmux_warns_when_tpm_is_missing() {
	local home_dir xdg_data_home
	home_dir=$(mktemp -d)
	xdg_data_home="$home_dir/xdg-data"
	trap '[ -n "${home_dir-}" ] && rm -rf "$home_dir"' RETURN

	HOME="$home_dir" XDG_DATA_HOME="$xdg_data_home" make sync-tmux >"$TEST_OUTPUT" 2>&1

	assert_contains "$TEST_OUTPUT" 'TPM is not installed'
	assert_contains "$TEST_OUTPUT" "$xdg_data_home/tmux/plugins/tpm"
	assert_contains "$TEST_OUTPUT" 'make install-tmux-plugins'
	assert_file_exists "$home_dir/.config/tmux/tmux.conf"
}

test_install_tmux_plugins_bootstraps_tpm() {
	local home_dir xdg_data_home fake_tpm_repo plugin_dir
	home_dir=$(mktemp -d)
	xdg_data_home="$home_dir/xdg-data"
	fake_tpm_repo=$(mktemp -d)
	plugin_dir="$xdg_data_home/tmux/plugins"
	trap '[ -n "${home_dir-}" ] && rm -rf "$home_dir"; [ -n "${fake_tpm_repo-}" ] && rm -rf "$fake_tpm_repo"' RETURN

	mkdir -p "$fake_tpm_repo/bin"
	cat >"$fake_tpm_repo/tpm" <<'EOF'
#!/bin/bash
exit 0
EOF
	cat >"$fake_tpm_repo/bin/install_plugins" <<'EOF'
#!/bin/bash
set -euo pipefail
config="${XDG_CONFIG_HOME:-$HOME/.config}/tmux/tmux.conf"
plugin_dir="${XDG_DATA_HOME:-$HOME/.local/share}/tmux/plugins/tmux-open"
test -f "$config"
mkdir -p "$plugin_dir"
printf 'installed\n' >"$plugin_dir/.installed-by-test"
EOF
	chmod +x "$fake_tpm_repo/tpm" "$fake_tpm_repo/bin/install_plugins"
	git -C "$fake_tpm_repo" init -q
	git -C "$fake_tpm_repo" add tpm bin/install_plugins
	git -C "$fake_tpm_repo" -c user.name='Dotfiles Test' -c user.email='test@example.com' commit -qm 'test fixture'

	HOME="$home_dir" XDG_DATA_HOME="$xdg_data_home" make sync-tmux >"$TEST_OUTPUT" 2>&1
	HOME="$home_dir" XDG_DATA_HOME="$xdg_data_home" make \
		TPM_REPOSITORY="$fake_tpm_repo" install-tmux-plugins >"$TEST_OUTPUT" 2>&1

	assert_file_exists "$plugin_dir/tpm/tpm"
	assert_file_exists "$plugin_dir/tmux-open/.installed-by-test"
	assert_contains "$TEST_OUTPUT" 'tmux plugins installed'
}

test_clean_tmux_preserves_unmanaged_config_without_stow() {
	local home_dir
	home_dir=$(mktemp -d)
	trap '[ -n "${home_dir-}" ] && rm -rf "$home_dir"' RETURN

	mkdir -p "$home_dir/.config/tmux"
	printf 'keep me\n' >"$home_dir/.config/tmux/tmux.conf"

	PATH="/usr/bin:/bin" HOME="$home_dir" make clean-tmux >"$TEST_OUTPUT" 2>&1
	assert_file_exists "$home_dir/.config/tmux/tmux.conf"
	assert_contains "$home_dir/.config/tmux/tmux.conf" 'keep me'
}

test_clean_tmux_removes_relative_stow_link_without_stow() {
	local home_dir
	home_dir=$(mktemp -d)
	trap '[ -n "${home_dir-}" ] && rm -rf "$home_dir"' RETURN

	mkdir -p "$home_dir/.config"
	HOME="$home_dir" stow -t "$home_dir" tmux
	assert_file_exists "$home_dir/.config/tmux/tmux.conf"

	PATH="/usr/bin:/bin" HOME="$home_dir" make clean-tmux >"$TEST_OUTPUT" 2>&1
	assert_path_absent "$home_dir/.config/tmux"
}

test_clean_tmux_removes_folded_config_link_without_stow() {
	local home_dir
	home_dir=$(mktemp -d)
	trap '[ -n "${home_dir-}" ] && rm -rf "$home_dir"' RETURN

	HOME="$home_dir" stow -t "$home_dir" tmux
	assert_symlink_resolves_to "$home_dir/.config" "$REPO_ROOT/tmux/.config"

	PATH="/usr/bin:/bin" HOME="$home_dir" make clean-tmux >"$TEST_OUTPUT" 2>&1
	assert_path_absent "$home_dir/.config"
}

main() {
	cd "$REPO_ROOT"
	test_sync_ghostty_linux_preserves_existing_custom_conf
	test_sync_ghostty_linux_force_replaces_existing_custom_conf
	test_clean_neovim_preserves_unmanaged_directory_without_stow
	test_clean_zsh_preserves_unmanaged_files_without_stow
	test_clean_ghostty_preserves_unmanaged_custom_conf_without_stow
	test_sync_tmux_rejects_legacy_config
	test_sync_tmux_warns_when_tpm_is_missing
	test_install_tmux_plugins_bootstraps_tpm
	test_clean_tmux_preserves_unmanaged_config_without_stow
	test_clean_tmux_removes_relative_stow_link_without_stow
	test_clean_tmux_removes_folded_config_link_without_stow
}

main "$@"
