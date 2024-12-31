local safeRequire = require("lib").safeRequire
local nvim_lsp = safeRequire("lspconfig")

-- The nvim-cmp almost supports LSP's capabilities so You should advertise it to LSP servers..
local capabilities = require("cmp_nvim_lsp").default_capabilities()
require("neodev").setup({
	-- add any options here, or leave empty to use the default settings
})

nvim_lsp.lua_ls.setup({
	capabilities = capabilities,
	settings = {
		Lua = {
			runtime = {
				-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
				version = "LuaJIT",
			},
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = { "vim", "hs" },
			},
			workspace = {
				checkThirdParty = false,
				-- Make the server aware of Neovim runtime files
				library = {
					vim.api.nvim_get_runtime_file("", true),
					"/Applications/Hammerspoon.app/Contents/Resources/extensions/hs/",
					vim.fn.expand("~/lualib/share/lua/5.4"),
					vim.fn.expand("~/lualib/lib/luarocks/rocks-5.4"),
					"/opt/homebrew/opt/openresty/lualib",
				},
			},
			completion = {
				callSnippet = "Replace",
			},
			-- Do not send telemetry data containing a randomized but unique identifier
			telemetry = {
				enable = false,
			},
		},
	},
})

nvim_lsp.ruff.setup({
	capabilities = capabilities,
	-- https://github.com/astral-sh/ruff-lsp?tab=readme-ov-file#example-neovim
	on_attach = function(client, _)
		if client.name == "ruff_lsp" then
			-- Disable hover in favor of Pyright
			client.server_capabilities.hoverProvider = false
		end
	end,
})

nvim_lsp.pyright.setup({
	capabilities = {
		textDocument = {
			publishDiagnostics = {
				tagSupport = {
					valueSet = { 2 },
				},
			},
		},
	},
	-- https://docs.astral.sh/ruff/editors/setup/#neovim
	settings = {
		-- Using Ruff's import organizer
		-- https://github.com/astral-sh/ruff-lsp/issues/384#issuecomment-2038623937
		pyright = {
			disableOrganizeImports = true,
			disableTaggedHints = true,
		},
		python = {
			pythonPath = ".venv/bin/python",
			analysis = {
				-- Ignore all files for analysis to exclusively use Ruff for linting
				ignore = { "*" },
			},
			diagnosticSeverityOverrides = {
				-- https://github.com/microsoft/pyright/blob/main/docs/configuration.md#type-check-diagnostics-settings
				reportUndefinedVariable = "none",
			},
		},
	},
})

nvim_lsp.terraformls.setup({
	capabilities = capabilities,
	vim.api.nvim_create_autocmd({ "BufWritePre" }, {
		pattern = { "*.tf", "*.tfvars" },
		callback = function()
			vim.lsp.buf.format()
		end,
	}),
})

-- Setup go language server gopls
nvim_lsp.gopls.setup({
	capabilities = capabilities,
	cmd = { "gopls" },
	root_dir = require("lspconfig").util.root_pattern(".git", "go.mod", "."),
	filetypes = { "go", "gomod", "gowork", "gotmpl" },
	settings = {
		gopls = {
			completeUnimported = true,
			usePlaceholders = true,
			analyses = {
				unusedparams = true,
			},
			staticcheck = true,
			gofumpt = true,
		},
	},
})

-- setup helm-ls
nvim_lsp.helm_ls.setup({
	capabilities = capabilities,
	settings = {
		["helm-ls"] = {
			yamlls = {
				path = "yaml-language-server",
			},
		},
	},
})

-- setup yamlls
nvim_lsp.yamlls.setup({
	settings = {
		yaml = {
			schemas = {
				["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
				["https://json.schemastore.org/kustomization.json"] = "kustomization.yaml",
				["https://json.schemastore.org/chart.json"] = "Chart.yaml",
				["https://json.schemastore.org/chart-lock.json"] = "Chart.lock",
			},
		},
	},
})

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		-- Enable completion triggered by <c-x><c-o>
		vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

		-- Buffer local mappings.
		-- See `:help vim.lsp.*` for documentation on any of the below functions
		local opts = { buffer = ev.buf }
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
		vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
		vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
		vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
		vim.keymap.set("n", "<leader>wl", function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, opts)
		vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
		vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
		vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, opts)
		vim.keymap.set("n", "<leader>f", function()
			vim.lsp.buf.format({ async = true })
		end, opts)
	end,
})
