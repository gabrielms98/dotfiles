return {
  "pmizio/typescript-tools.nvim",
  dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  opts = {
    settings = {
      tsserver_max_memory = "4096",
      tsserver_file_preferences = {
        importModuleSpecifierPreference = "auto",
        quotePreference = "single",
        includeCompletionsForModuleExports = true,
        allowIncompleteCompletions = true,
      },
    },
  },
}
