return {
	{ "rhysd/conflict-marker.vim", event = "VeryLazy" },
	{ "airblade/vim-gitgutter", event = "VeryLazy" },
	{
		event = "VeryLazy",
		"tpope/vim-fugitive",
		cmd = "Git",
		config = function()
			-- convert
			vim.cmd.cnoreabbrev([[git Git]])
		end,
	},
}
