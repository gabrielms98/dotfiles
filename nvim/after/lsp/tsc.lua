-- typescript-go. lspconfig's `tsc` probes binaries with a blocking
-- `tsc --version` (a Node startup or two, ~200ms of frozen UI on the first TS
-- buffer). Go straight to tsgo: the project's copy if any, else the global one.
local lockfiles = { "package-lock.json", "yarn.lock", "pnpm-lock.yaml", "bun.lockb", "bun.lock" }

return {
  cmd = function(dispatchers, config)
    local bin = "tsgo"
    if config.root_dir then
      local found = vim.fs.find("node_modules/.bin/tsgo", { path = config.root_dir, upward = true })[1]
      if found then bin = found end
    end
    return vim.lsp.rpc.start({ bin, "--lsp", "--stdio" }, dispatchers)
  end,
  root_dir = function(bufnr, on_dir)
    if vim.fs.root(bufnr, { "deno.json", "deno.jsonc", "deno.lock" }) then return end
    on_dir(vim.fs.root(bufnr, { lockfiles, { ".git" } }) or vim.fn.getcwd())
  end,
  settings = {
    typescript = {
      preferences = {
        includeCompletionsForModuleExports = true,
        includePackageJsonAutoImports = "auto",
      },
      suggest = { autoImports = true },
      updateImportsOnFileMove = { enabled = "always" },
    },
  },
}
