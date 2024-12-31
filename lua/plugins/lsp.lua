return {
	{
		"folke/neodev.nvim",
	},
	{
		"williamboman/mason.nvim",
		build = ":MasonUpdate", -- :MasonUpdate updates registry contents
		config = function()
			require("mason").setup()
			require("mason-lspconfig").setup({
				ensure_installed = { "helm_ls", "lua_ls", "gopls", "pyright", "terraformls", "zls", "yamlls", "ruff" },
			})
		end,
	},
	{
		"nvimtools/none-ls.nvim", -- none-ls is an active community fork of null-ls
		dependencies = {
			"nvimtools/none-ls-extras.nvim",
		},
		lazy = true,
		event = { "BufReadPost", "BufNewFile", "BufWritePre" },
		config = function()
			local null_ls = require("null-ls")
			local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
			local formatting = null_ls.builtins.formatting
			local code_actions = null_ls.builtins.code_actions

			null_ls.setup({
				sources = {
					formatting.shfmt,
					-- code_actions.shellcheck,
					-- for go
					formatting.gofmt,
					formatting.goimports,
					code_actions.gomodifytags,
					code_actions.impl,
					-- for lua
					formatting.stylua,
					-- for python
					formatting.black,
				},
				-- configure format on save
				on_attach = function(client, bufnr)
					if client.supports_method("textDocument/formatting") then
						vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
						vim.api.nvim_create_autocmd("BufWritePre", {
							group = augroup,
							buffer = bufnr,
							callback = function()
								vim.lsp.buf.format({ async = false })
							end,
						})
					end
				end,
			})
		end,
	},
	{
		event = "VeryLazy",
		"neovim/nvim-lspconfig",
		dependencies = { "williamboman/mason-lspconfig.nvim" },
		config = function()
			require("lsp_config")
		end,
	},
}
