return {
  'nvim-telescope/telescope.nvim',
  tag = '0.1.8',
  dependencies = { 'nvim-lua/plenary.nvim' },
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
    })

    local builtin = require("telescope.builtin")
    vim.keymap.set(
      "n",
      "<C-p>",
      function() builtin.find_files(require("telescope.themes").get_ivy({})) end,
      { desc = "[S]earch [F]iles" }
    )
  end
}
