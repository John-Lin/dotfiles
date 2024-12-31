return {
	{
		keys = {
			{ "<leader>t", ":NERDTreeToggle<CR>", desc = "toggle nerdtree" },
			{ "<leader>l", ":NERDTreeFind<CR>", desc = "nerdtree find" },
		},
		"preservim/nerdtree",
		event = "BufEnter", -- 當進入緩衝區（文件）時載入
		config = function()
			vim.cmd([[let NERDTreeShowHidden=1]])
			vim.api.nvim_create_autocmd("VimEnter", {
				callback = function()
					if vim.fn.argc() == 0 then
						vim.cmd("NERDTree")
					end
				end,
			})
		end,
		dependencies = {
			"Xuyuanp/nerdtree-git-plugin",
			"ryanoasis/vim-devicons",
		},
	},
}
