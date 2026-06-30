return {
  "dmtrKovalenko/fff.nvim",
  build = "cargo build --release",
  opts = {
    keymaps = { close = { '<C-c>', 'Esc' } },
    preview = { line_numbers = true },
    -- Full-width panel pinned to the bottom of the screen, like telescope's
    -- bottom_pane layout (height 0.4, prompt at the bottom).
    layout = {
      anchor = 'bottom',
      width = 1.0,
      height = 0.4,
      prompt_position = 'bottom',
    },
  },
  keys = {
    {
      "<C-p>",
      function() require("fff").find_files() end,
      desc = "Toggle FFF",
    },
  },
}
