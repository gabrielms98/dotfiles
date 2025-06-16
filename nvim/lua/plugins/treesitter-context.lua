return {
  "nvim-treesitter/nvim-treesitter-context",
  config = function()
    require("treesitter-context").setup({
      enable = true,
      max_lines = 0,         -- No limit on the number of lines
      trim_scope = "outer",  -- Show context for outer scope
      min_window_height = 0, -- No minimum window height
      mode = "cursor",       -- Show context at cursor position
      zindex = 20,           -- Set z-index for the context window
      line_numbers = true,   -- Show line numbers in context
    })
  end,

}
