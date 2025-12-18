return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-neotest/neotest-jest",
  },
  config = function()
    require("neotest").setup {
      adapters = {
        require("neotest-jest") {
          jestCommand = "yarn nx test --",
          jestConfigFile = "jest.config.js",
          env = { CI = true },
          cwd = function(path)
            return vim.fn.getcwd()
          end,
        },
      },
      icons = {
        passed = "✔️",
        running = "🏃",
        failed = "❌",
        skipped = "⏭️",
        unknown = "❓",
      },
    }

    vim.api.nvim_set_keymap("n", "<leader>tw",
      "<cmd>lua require('neotest').run.run({ jestCommand = 'npx jest --watch ' })<cr>", {})
  end
}
