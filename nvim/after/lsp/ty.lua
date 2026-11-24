return {
  settings = {
    ty = {
      -- "workspace" re-checks the whole repo on every change: a freeze source
      -- on big projects. Use <leader>L / `ty check` for the full picture.
      diagnosticMode = "openFilesOnly",
      completions = {
        -- Suggest symbols from the whole workspace (and add the import)
        -- without needing the defining file to be open first.
        autoImport = true,
      },
    },
  },
}
