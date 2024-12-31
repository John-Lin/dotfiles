
all: sync

sync:
	mkdir -p ~/.config/nvim
	mkdir -p ~/.config/ghosty

	[ -d ~/.config/nvim/lua/ ] || ln -s $(PWD)/.config/nvim/lua ~/.config/nvim/lua
	[ -f ~/.config/nvim/init.lua ] || ln -s $(PWD)/init.lua ~/.config/nvim/init.lua
	[ -f ~/.tigrc ] || ln -s $(PWD)/tigrc ~/.tigrc
	[ -f ~/.config/ghostty/config ] || ln -s $(PWD)/ghostty.config ~/.config/ghostty/config

clean:
	rm -rf ~/.config/nvim/lua/
	rm -f ~/.config/nvim/init.lua
	rm -f ~/.tigrc
	rm -f ~/.config/ghostty/config

.PHONY: all clean sync
