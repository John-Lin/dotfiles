return {
  { 'rhysd/conflict-marker.vim', event = 'VeryLazy' },
  {
    'lewis6991/gitsigns.nvim',
    event = 'VeryLazy',
    config = function()
      require('gitsigns').setup({
        signs = {
          add = { text = '+' },
          change = { text = '~' },
          delete = { text = '_' },
          topdelete = { text = '‾' },
          changedelete = { text = '~' },
        },
      })
    end,
  },
  {
    event = 'VeryLazy',
    'tpope/vim-fugitive',
    cmd = 'Git',
    config = function()
      -- convert
      vim.cmd.cnoreabbrev([[git Git]])
    end,
  },
}
