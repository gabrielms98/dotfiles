return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  lazy = false,
  config = function()
    require("neo-tree").setup({
      filesystem = {
        hijack_netrw_behavior = "disabled",
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_by_name = { "node_modules", ".yarn", ".git", ".vscode", ".nx" },
        },
      },
    })
    vim.keymap.set('n', '<leader>neo', ':Neotree filesystem reveal right<CR>', { noremap = true, silent = true })
  end
}
