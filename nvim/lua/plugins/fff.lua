return {
  "dmtrKovalenko/fff.nvim",
  build = "cargo build --release",
  opts = {
    -- pass here all the options
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
