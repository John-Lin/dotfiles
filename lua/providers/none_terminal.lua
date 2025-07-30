-- ABOUTME: No-operation terminal provider for claudecode.nvim
-- ABOUTME: Disables terminal functionality while maintaining interface compatibility

local M = {
  setup = function(config)
    -- Do nothing - just store config if needed
  end,

  open = function(cmd_string, env_table, effective_config, focus)
    -- Do nothing - no terminal to open
  end,

  close = function()
    -- Do nothing - no terminal to close
  end,

  simple_toggle = function(cmd_string, env_table, effective_config)
    -- Do nothing - no terminal to toggle
  end,

  focus_toggle = function(cmd_string, env_table, effective_config)
    -- Do nothing - no terminal to focus/hide
  end,

  get_active_bufnr = function()
    -- Return nil since there's no terminal buffer
    return nil
  end,

  is_available = function()
    -- Always available since it does nothing
    return true
  end,

  -- Optional function
  toggle = function(cmd_string, env_table, effective_config)
    -- Do nothing - no terminal to toggle
  end,

  _get_terminal_for_test = function()
    -- For testing only - return nil
    return nil
  end,
}

return M