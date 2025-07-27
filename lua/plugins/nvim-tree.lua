return {
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = {
			"nvim-tree/nvim-web-devicons", -- for file icons
		},
		keys = {
			{ "<leader>t", ":NvimTreeToggle<CR>", desc = "toggle nvim-tree" },
			{ "<leader>l", ":NvimTreeFindFile<CR>", desc = "nvim-tree find" },
		},
		config = function()
			-- disable netrw at the very start
			vim.g.loaded_netrw = 1
			vim.g.loaded_netrwPlugin = 1

			-- optionally enable 24-bit colour
			vim.opt.termguicolors = true

			local function my_on_attach(bufnr)
				local api = require("nvim-tree.api")

				local function opts(desc)
					return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
				end

				-- default mappings
				api.config.mappings.default_on_attach(bufnr)

				-- custom mappings can be added here if needed
			end

			require("nvim-tree").setup({
				on_attach = my_on_attach,
				sort = {
					sorter = "case_sensitive",
				},
				view = {
					width = 30,
				},
				renderer = {
					group_empty = true,
					icons = {
						show = {
							file = true,
							folder = true,
							folder_arrow = true,
							git = true,
						},
					},
				},
				filters = {
					dotfiles = false, -- show hidden files (equivalent to NERDTreeShowHidden=1)
				},
				git = {
					enable = true,
					ignore = false,
					show_on_dirs = true,
					show_on_open_dirs = true,
					timeout = 400,
				},
			})

			-- Auto open nvim-tree when starting nvim with no file arguments
			vim.api.nvim_create_autocmd("VimEnter", {
				callback = function()
					if vim.fn.argc() == 0 then
						require("nvim-tree.api").tree.open()
					end
				end,
			})
		end,
	},
}