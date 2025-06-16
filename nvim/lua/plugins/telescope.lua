return {
  'nvim-telescope/telescope.nvim',
  tag = '0.1.8',
  dependencies = {
    'folke/noice.nvim',
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },
  config = function()
    require('telescope').setup({
      defaults = {
        file_ignore_patterns = { 'node_modules', '.git' },
        mappings = {
          i = {
            ['<C-u>'] = false, -- Disable clearing the prompt
            ['<C-d>'] = false, -- Disable deleting half of the prompt
          },
        },
      },
      find_files = { hidden = true }
    })

    require("telescope").load_extension("noice")

    local builtin = require("telescope.builtin")
    vim.keymap.set(
      "n",
      "<C-p>",
      function() builtin.find_files(require("telescope.themes").get_ivy({})) end,
      { desc = "[S]earch [F]iles" }
    )
  end
}
