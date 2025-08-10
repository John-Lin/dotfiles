-- Neovim Lua configuration for luacheck
-- Allow vim global
globals = {
    "vim",
}

-- Ignore warnings about setting vim global
files["nvim/.config/nvim/init.lua"] = {
    globals = {"vim"},
}

files["nvim/.config/nvim/lua/lsp_config.lua"] = {
    globals = {"vim"},
}

files["nvim/.config/nvim/lua/lib.lua"] = {
    globals = {"vim", "M"},
}

files["nvim/.config/nvim/lua/plugins/*.lua"] = {
    globals = {"vim"},
}

-- Ignore line length warnings (we can adjust this)
max_line_length = 150

-- Ignore unused function parameters for callback functions
ignore = {
    "212",  -- unused argument (common in callbacks)
    "211",  -- unused function (template functions)
}