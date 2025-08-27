return {
  "dmtrKovalenko/fff.nvim",
  build = "cargo build --release",
  opts = {
    keymaps = { close = { '<C-c>', 'Esc' } },
    preview = { line_numbers = true },
  },
  keys = {
    {
      "<C-p>",
      function()
        require("fff").find_files()
      end,
      desc = "Toggle FFF",
    },
  },
}
