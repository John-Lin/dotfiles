return {
	{
		"RRethy/base16-nvim",
		lazy = false, -- make sure we load this during startup if it is your main colorscheme
		priority = 1000, -- make sure to load this before all the other start plugins
		config = function()
			-- load the colorscheme here
			-- vim.cmd([[colorscheme base16-tomorrow-night]])
			vim.cmd([[colorscheme base16-gruvbox-dark-hard]])
		end,
	},
}
