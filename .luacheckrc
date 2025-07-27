-- Neovim Lua configuration for luacheck
-- Allow vim global
globals = {
    "vim",
}

-- Ignore warnings about setting vim global
files["init.lua"] = {
    globals = {"vim"},
}

files["lua/lsp_config.lua"] = {
    globals = {"vim"},
}

files["lua/lib.lua"] = {
    globals = {"vim", "M"},
}

files["lua/plugins/*.lua"] = {
    globals = {"vim"},
}

-- Ignore line length warnings (we can adjust this)
max_line_length = 150

-- Ignore unused function parameters for callback functions
ignore = {
    "212",  -- unused argument (common in callbacks)
    "211",  -- unused function (template functions)
}