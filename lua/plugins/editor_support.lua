return {
    {
        "windwp/nvim-autopairs",
        event = { "InsertEnter" },
        config = function()
            require("nvim-autopairs").setup({
                fast_wrap = {},
                disable_filetype = { "TelescopePrompt", "vim", "sh" },
            })
        end,
    },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        },
    },
    {
        "numToStr/Comment.nvim",
        config = function()
            require("Comment").setup()
        end,
    },
}
