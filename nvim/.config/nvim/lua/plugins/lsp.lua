return {
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  {
    'williamboman/mason.nvim',
    build = ':MasonUpdate', -- :MasonUpdate updates registry contents
    config = function()
      require('mason').setup()
      require('mason-lspconfig').setup({
        ensure_installed = {
          'helm_ls',
          'lua_ls',
          'gopls',
          'basedpyright',
          'terraformls',
          'yamlls',
          'ruff',
          'ty', -- Python type checker
          'clangd', -- C/C++ language server
        },
      })
    end,
  },
  {
    'nvimtools/none-ls.nvim', -- none-ls is an active community fork of null-ls
    dependencies = {
      'nvimtools/none-ls-extras.nvim',
    },
    lazy = true,
    event = { 'BufReadPost', 'BufNewFile', 'BufWritePre' },
    config = function()
      local null_ls = require('null-ls')
      local augroup = vim.api.nvim_create_augroup('LspFormatting', {})
      local formatting = null_ls.builtins.formatting
      local code_actions = null_ls.builtins.code_actions
      local diagnostics = null_ls.builtins.diagnostics

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
          require('none-ls.formatting.ruff'),
          -- for C/C++
          formatting.clang_format.with({
            extra_args = { '--style=file', '--fallback-style=LLVM' },
          }),
        },
        -- NOTE: Auto-format on save is disabled. Use <leader>f for manual formatting.
        -- To re-enable auto-format, uncomment the block below:
        --[[
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
                --]]
        on_attach = nil, -- No auto-format on attach
      })
    end,
  },
  {
    event = 'VeryLazy',
    'neovim/nvim-lspconfig',
    dependencies = { 'williamboman/mason-lspconfig.nvim' },
    config = function()
      require('lsp_config')
    end,
  },
}
