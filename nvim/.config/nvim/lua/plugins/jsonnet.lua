return {
  {
    'Duologic/nvim-jsonnet',
    ft = { 'jsonnet', 'libsonnet' },
    config = function()
      require('nvim-jsonnet').setup({
        load_lsp_config = false,
        load_dap_config = false,
      })
    end,
  },
}
