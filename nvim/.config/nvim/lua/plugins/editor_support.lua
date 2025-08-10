return {
	{
		"windwp/nvim-autopairs",
		event = { "InsertEnter" },
		config = function()
			require("nvim-autopairs").setup({
				fast_wrap = {},
				disable_filetype = { "TelescopePrompt", "vim", "sh" },
			})
		end,
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
	},
	{
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
	},
	{
		keys = {
			{ "<localleader>t", ":Trim<CR>", desc = "Trim the buffer right away" },
		},
		"cappyzawa/trim.nvim",
		config = function()
			require("trim").setup({
				-- if you want to ignore markdown file.
				-- you can specify filetypes.
				ft_blocklist = { "markdown" },
				-- if you want to remove multiple blank lines
				patterns = {
					[[%s/\(\n\n\)\n\+/\1/]], -- replace multiple blank lines with a single line
				},
				-- if you want to disable trim on write by default
				trim_on_write = false,
				-- highlight trailing spaces
				highlight = true,
			})
		end,
	},
}
