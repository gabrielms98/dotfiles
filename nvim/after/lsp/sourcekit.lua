return {
  -- Resolve the Xcode toolchain's sourcekit-lsp only when a Swift buffer
  -- starts the server, not on every Neovim startup.
  cmd = function(dispatchers, config)
    local out = vim.system({ "xcrun", "-f", "sourcekit-lsp" }, { text = true }):wait()
    local bin = out.code == 0 and vim.trim(out.stdout) or "sourcekit-lsp"
    return vim.lsp.rpc.start({ bin }, dispatchers, { cwd = config.root_dir })
  end,
  filetypes = { "swift" },
  root_markers = {
    "buildServer.json",
    "Package.swift",
    "compile_commands.json",
    ".sourcekit-lsp",
    ".git",
  },
  get_language_id = function(_, ftype) return ftype end,
  capabilities = {
    workspace = {
      didChangeWatchedFiles = { dynamicRegistration = true },
    },
    textDocument = {
      diagnostic = { dynamicRegistration = true, relatedDocumentSupport = true },
    },
  },
}
