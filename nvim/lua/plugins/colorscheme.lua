return {
  -- Theme inspired by Atom
  "navarasu/onedark.nvim",
  priority = 1000,
  tag = "v0.1.0",
  config = function()
    require("onedark").setup {
      style = "deep",
      transparent = true
    }
    vim.cmd.colorscheme "onedark"
  end
}
