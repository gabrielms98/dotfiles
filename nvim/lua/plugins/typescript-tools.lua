return {
  "pmizio/typescript-tools.nvim",
  dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  opts = {
    settings = {
      tsserver_max_memory = "4096",
      -- Prefer path aliases (e.g. @scope/lib) over relative paths for Nx @nx/enforce-module-boundaries
      tsserver_file_preferences = {
        importModuleSpecifierPreference = "project-relative",
        quotePreference = "single",
        includeCompletionsForModuleExports = true,
        allowIncompleteCompletions = true,
      },
    },
  },
}
