return {
	{
		"nvim-tree/nvim-tree.lua",
		lazy = vim.g.auto_open_nvim_tree ~= true, -- Only lazy load if auto-open is not explicitly enabled
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

				-- Custom mappings to ensure compatibility with NERDTree habits
				vim.keymap.set('n', 's', api.node.open.vertical, opts('Open: Vertical Split'))
				vim.keymap.set('n', 'i', api.node.open.horizontal, opts('Open: Horizontal Split'))
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
			-- Set vim.g.auto_open_nvim_tree = true to enable (also disables lazy loading)
			-- Set vim.g.auto_open_nvim_tree = false to disable (enables lazy loading)
			-- Default: disabled for better startup performance
			if vim.g.auto_open_nvim_tree == true then
				vim.api.nvim_create_autocmd("VimEnter", {
					callback = function()
						if vim.fn.argc() == 0 then
							-- Use vim.schedule to ensure nvim-tree is fully loaded
							vim.schedule(function()
								require("nvim-tree.api").tree.open()
							end)
						end
					end,
				})
			end
		end,
	},
}