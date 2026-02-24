return {
  {
    cmd = 'Telescope',
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = {
      {
        '<Leader>p',
        function()
          require('telescope.builtin').find_files()
        end,
        desc = 'Find files',
      },
      {
        '<Leader>P',
        function()
          require('telescope.builtin').live_grep()
        end,
        desc = 'Grep files',
      },
      {
        '<Leader>rs',
        function()
          require('telescope.builtin').resume()
        end,
        desc = 'Resume last search',
      },
      {
        '<Leader>mru',
        function()
          require('telescope.builtin').oldfiles()
        end,
        desc = 'Recent files',
      },
    },
    'nvim-telescope/telescope.nvim',
    tag = 'v0.2.1',
  },
}
