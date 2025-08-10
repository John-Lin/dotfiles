local set = vim.o
set.number = true
set.encoding = "UTF-8"
set.relativenumber = true
set.clipboard = "unnamed"

vim.o.tabstop = 4 -- A TAB character looks like 4 spaces
vim.o.expandtab = true -- Pressing the TAB key will insert spaces instead of a TAB character
vim.o.softtabstop = 4 -- Number of spaces inserted instead of a TAB character
vim.o.shiftwidth = 4 -- Number of spaces inserted when indenting

-- Undo persistence
vim.opt.undodir = vim.fn.stdpath("cache") .. "/nvim/undodir"
vim.opt.undofile = true

-- smaller updatetime for gitgutter
vim.opt.updatetime = 100
-- always show signcolumns
vim.opt.signcolumn = "yes"

-- highlight after yank
vim.api.nvim_create_autocmd("TextYankPost", {
	pattern = { "*" },
	callback = function()
		vim.highlight.on_yank({
			timeout = 50,
		})
	end,
})

-- keybindings
local opts = { noremap = true, silent = true }
-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Plugin configuration: disable nvim-tree auto-open for lazy loading
vim.g.auto_open_nvim_tree = false
vim.keymap.set("n", "<C-l>", "<C-w>l", opts)
vim.keymap.set("n", "<C-h>", "<C-w>h", opts)
vim.keymap.set("n", "<C-j>", "<C-w>j", opts)
vim.keymap.set("n", "<C-k>", "<C-w>k", opts)
vim.keymap.set("n", "<Leader>v", "<C-w>v", opts)
vim.keymap.set("n", "<Leader>s", "<C-w>s", opts)
vim.keymap.set("n", "<Leader>[", "<C-o>", opts)
vim.keymap.set("n", "<Leader>]", "<C-i>", opts)

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)
-- Setup lazy.nvim
require("lazy").setup("plugins")

-- https://www.reddit.com/r/neovim/comments/sk70rk/using_github_copilot_in_neovim_tab_map_has_been/
vim.g.copilot_no_tab_map = true
vim.g.copilot_assume_mapped = true
vim.g.copilot_tab_fallback = ""

-- Specific highlight groups
vim.api.nvim_set_hl(0, "@lsp.type.variable.lua", { link = "Normal" })
vim.api.nvim_set_hl(0, "Identifier", { link = "Normal" })
vim.api.nvim_set_hl(0, "TSVariable", { link = "Normal" })
vim.api.nvim_set_hl(0, "@variable.builtin.vim", { link = "Normal" })

-- Command line mode key mappings
local function cnoremap(lhs, rhs)
	vim.api.nvim_set_keymap("c", lhs, rhs, { noremap = true, silent = true })
end

-- markdown conceal level
vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	callback = function()
		vim.opt_local.conceallevel = 0
	end,
})

-- set history size
vim.o.history = 500
-- Bash-like command mapping
cnoremap("<C-a>", "<Home>") -- Ctrl+A go to beginning of line
cnoremap("<C-e>", "<End>") -- Ctrl+E go to end of line
cnoremap("<C-b>", "<Left>") -- Ctrl+B move left one character
cnoremap("<C-f>", "<Right>") -- Ctrl+F move right one character
cnoremap("<C-d>", "<Del>") -- Ctrl+D delete character under cursor
cnoremap("<C-_>", "<C-f>") -- Ctrl+_ maps to Ctrl+F

-- History navigation
cnoremap("<C-n>", "<Down>") -- Ctrl+N next history entry
cnoremap("<C-p>", "<Up>") -- Ctrl+P previous history entry

-- Beginning of line shortcut mapping
cnoremap("<C-*>", "<C-a>") -- Ctrl+* maps to Ctrl+A
