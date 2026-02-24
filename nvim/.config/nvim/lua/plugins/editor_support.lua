return {
  {
    'windwp/nvim-autopairs',
    event = { 'InsertEnter' },
    config = function()
      require('nvim-autopairs').setup({
        fast_wrap = {},
        disable_filetype = { 'TelescopePrompt', 'vim', 'sh' },
      })
    end,
  },
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    config = function()
      local wk = require('which-key')
      wk.setup({
        preset = 'helix',
        win = {
          border = 'rounded',
          padding = { 2, 2, 2, 2 },
        },
      })
      wk.add({
        { '<leader>a', group = 'AI' },
        { '<leader>w', group = 'Workspace' },
        { '<leader>f', desc = 'Format buffer' },
        { '<leader>t', desc = 'Toggle tree' },
        { '<leader>l', desc = 'Locate file in tree' },
        { '<leader>p', desc = 'Find files' },
        { '<leader>P', desc = 'Grep files' },
        { '<leader>e', desc = 'Diagnostic float' },
        { '<leader>q', desc = 'Diagnostic list' },
        { '<leader>k', desc = 'Signature help' },
        { '<leader>D', desc = 'Type definition' },
        { '<leader>rn', desc = 'Rename' },
        { '<leader>ca', desc = 'Code action' },
        { '<leader>gr', desc = 'References' },
      })
    end,
  },
  {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end,
  },
  {
    keys = {
      { '<localleader>t', ':Trim<CR>', desc = 'Trim the buffer right away' },
    },
    'cappyzawa/trim.nvim',
    config = function()
      require('trim').setup({
        -- if you want to ignore markdown file.
        -- you can specify filetypes.
        ft_blocklist = { 'markdown' },
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
