-- Library paths come from lazydev.nvim (only what a file actually requires),
-- instead of the whole runtimepath.
return {
  settings = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
}
