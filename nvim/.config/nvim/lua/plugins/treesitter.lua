return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    build = ':TSUpdate',
    config = function()
      local enabled = {
        'c',
        'lua',
        'vim',
        'vimdoc',
        'query',
        'markdown',
        'python',
        'javascript',
        'go',
        'gomod',
        'gosum',
        'terraform',
        'json',
        'vrl',
        'yaml',
        'make',
        'gitignore',
      }
      local treesitter = require('nvim-treesitter')
      local installed = treesitter.get_installed()
      local to_install = vim
        .iter(enabled)
        :filter(function(parser)
          return not vim.tbl_contains(installed, parser)
        end)
        :totable()

      if #to_install > 0 then
        treesitter.install(to_install)
      end

      vim.api.nvim_create_autocmd('FileType', {
        callback = function(args)
          pcall(vim.treesitter.start, args.buf)
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main',
    lazy = false,
    config = function()
      require('nvim-treesitter-textobjects').setup({
        select = {
          lookahead = true,
          selection_modes = {
            ['@parameter.outer'] = 'v',
            ['@function.outer'] = 'V',
            ['@class.outer'] = '<c-v>',
          },
          include_surrounding_whitespace = true,
        },
      })

      local select = require('nvim-treesitter-textobjects.select')
      vim.keymap.set({ 'x', 'o' }, 'af', function()
        select.select_textobject('@function.outer', 'textobjects')
      end)
      vim.keymap.set({ 'x', 'o' }, 'if', function()
        select.select_textobject('@function.inner', 'textobjects')
      end)
      vim.keymap.set({ 'x', 'o' }, 'aa', function()
        select.select_textobject('@parameter.outer', 'textobjects')
      end)
      vim.keymap.set({ 'x', 'o' }, 'ia', function()
        select.select_textobject('@parameter.inner', 'textobjects')
      end)
      vim.keymap.set({ 'x', 'o' }, 'ac', function()
        select.select_textobject('@class.outer', 'textobjects')
      end)
      vim.keymap.set({ 'x', 'o' }, 'ic', function()
        select.select_textobject('@class.inner', 'textobjects')
      end, { desc = 'Select inner part of a class region' })
      vim.keymap.set({ 'x', 'o' }, 'as', function()
        select.select_textobject('@scope', 'locals')
      end, { desc = 'Select language scope' })

      local swap = require('nvim-treesitter-textobjects.swap')
      vim.keymap.set('n', '<leader>ts', function()
        swap.swap_next('@parameter.inner')
      end)
      vim.keymap.set('n', '<leader>tS', function()
        swap.swap_previous('@parameter.inner')
      end)
    end,
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
  },
}
