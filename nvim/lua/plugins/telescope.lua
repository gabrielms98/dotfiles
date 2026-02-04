return {
  'nvim-telescope/telescope.nvim',
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      cond = function()
        return vim.fn.executable "make" == 1
      end
    },
    { "nvim-telescope/telescope-ui-select.nvim" },
    -- Useful for getting pretty icons, but requires a Nerd Font.
    { "nvim-tree/nvim-web-devicons",            enabled = vim.g.have_nerd_font }
  },
  config = function()
    require('telescope').setup({
      extensions = {
        ["ui-select"] = {
          require("telescope.themes").get_dropdown()
        }
      },
      defaults = {
        file_ignore_patterns = { 'node_modules', '.git' },
        mappings = {
          i = {
            ['<C-u>'] = false, -- Disable clearing the prompt
            ['<C-d>'] = false, -- Disable deleting half of the prompt
          },
        },
      },
      find_files = {
        hidden = true,
      }
    })

    pcall(require("telescope").load_extension, "fzf")
    pcall(require("telescope").load_extension, "ui-select")

    local builtin = require("telescope.builtin")
    vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
    vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
    vim.keymap.set("n", "<leader>l", function() builtin.diagnostics({ path_display = { "tail" }, bufnr = 0 }) end,
      { desc = "Buffer diagnostics" }
    )
    vim.keymap.set("n", "<leader>L", function() builtin.diagnostics({ path_display = { "tail" } }) end,
      { desc = "Workspace diagnostics" }
    )


    vim.keymap.set(
      "n",
      "<leader>fp",
      function()
        vim.ui.input({ prompt = "Grep > " }, function(query)
          if not query or query == "" then return end
          builtin.grep_string({ search = query })
        end)
      end
    )
    -- Shortcut for searching your Neovim configuration files
    vim.keymap.set(
      "n",
      "<leader>sn",
      function()
        builtin.find_files { cwd = vim.fn.stdpath "config" }
      end,
      { desc = "[S]earch [N]eovim files" }
    )
  end
}
