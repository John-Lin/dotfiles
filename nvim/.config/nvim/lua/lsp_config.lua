local safeRequire = require("lib").safeRequire

-- The nvim-cmp almost supports LSP's capabilities so You should advertise it to LSP servers..
local capabilities = require("cmp_nvim_lsp").default_capabilities()
require("neodev").setup({
	-- add any options here, or leave empty to use the default settings
})

vim.lsp.config('lua_ls', {
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

vim.lsp.config('basedpyright', {
	capabilities = capabilities,
	cmd = { "basedpyright-langserver", "--stdio" },
	filetypes = { "python" },
	settings = {
		basedpyright = {
			disableOrganizeImports = true,
			disableTaggedHints = true,
			analysis = {
				autoSearchPaths = true,
				autoImportCompletions = true,
				useLibraryCodeForTypes = true,
				diagnosticMode = "openFilesOnly",
				typeCheckingMode = "standard",
				diagnosticSeverityOverrides = {
					reportMissingModuleSource = "none",
					reportMissingImports = "none",
				},
				inlayHints = {
					variableTypes = true,
					callArgumentNames = true,
					functionReturnTypes = true,
					genericTypes = false,
				},
			},
		},
	},
})

vim.lsp.config('ruff', {
	capabilities = capabilities,
	-- https://github.com/astral-sh/ruff-lsp?tab=readme-ov-file#example-neovim
	on_attach = function(client, _)
		if client.name == "ruff" then
			-- Disable hover in favor of Pyright
			client.server_capabilities.hoverProvider = false
		end
	end,
})

vim.lsp.config('terraformls', {
	capabilities = capabilities,
})

-- Setup clangd for C/C++
vim.lsp.config('clangd', {
	capabilities = capabilities,
	cmd = { "clangd", "--background-index", "--clang-tidy", "--header-insertion=iwyu" },
	filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
	root_markers = {
		".clangd",
		".clang-tidy",
		".clang-format",
		"compile_commands.json",
		"compile_flags.txt",
		"configure.ac",
		".git"
	},
	settings = {
		clangd = {
			checkUpdates = true,
		},
	},
})

-- Setup go language server gopls
vim.lsp.config('gopls', {
	capabilities = capabilities,
	cmd = { "gopls" },
	root_markers = { ".git", "go.mod", "." },
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
vim.lsp.config('helm_ls', {
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
vim.lsp.config('yamlls', {
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
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "open diagnostic float" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "open diagnostic location list" })

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
