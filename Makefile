
# Default target
all: sync

# Create symlinks for dotfiles configuration
sync:
	# Create necessary directories
	mkdir -p ~/.config/nvim
	mkdir -p ~/.config/ghostty

	# Link Neovim configuration files
	[ -f ~/.config/nvim/init.lua ] || ln -s $(PWD)/init.lua ~/.config/nvim/init.lua
	[ -f ~/.config/nvim/lazy-lock.json ] || ln -s $(PWD)/lazy-lock.json ~/.config/nvim/lazy-lock.json

	# Link Neovim lua directory
	[ -d ~/.config/nvim/lua ] || ln -s $(PWD)/lua ~/.config/nvim/lua

	# Link shell and terminal configuration files
	[ -f ~/.tigrc ] || ln -s $(PWD)/tigrc ~/.tigrc
	[ -f ~/.zshrc ] || ln -s $(PWD)/zshrc ~/.zshrc
	[ -f ~/.p10k.zsh ] || ln -s $(PWD)/p10k.zsh ~/.p10k.zsh
	[ -f ~/.config/ghostty/config ] || ln -s $(PWD)/ghostty.config ~/.config/ghostty/config

# Remove all symlinks and configuration directories
clean:
	rm -rf ~/.config/nvim/
	rm -f ~/.tigrc
	rm -f ~/.zshrc
	rm -f ~/.p10k.zsh
	rm -f ~/.config/ghostty/config

.PHONY: all clean sync
