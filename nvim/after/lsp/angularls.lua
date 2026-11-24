-- ngserver loads @angular/language-service out of the *project*, so the server
-- shell and that package have to be the same major. Upstream runs whatever
-- `ngserver` is on PATH — the global copy, since in an npm-workspaces repo
-- node_modules/.bin exists only at the hoisted root and never beside
-- angular.json. A v18 shell on a v22 project answers every query with null.
local function node_modules_dirs(root_dir)
  local dirs = vim.fs.find("node_modules", {
    path = root_dir, upward = true, type = "directory", limit = math.huge,
  })

  -- Global copy last: a project's own version outranks it.
  local exe = vim.fn.exepath("ngserver")
  if exe ~= "" then
    local global = vim.fs.normalize(
      vim.fs.joinpath(vim.fs.dirname(vim.uv.fs_realpath(exe) or exe), "../../.."))
    if vim.uv.fs_stat(global) and not vim.list_contains(dirs, global) then
      dirs[#dirs + 1] = global
    end
  end

  return dirs
end

return {
  cmd = function(dispatchers, config)
    local probes = node_modules_dirs(config.root_dir or vim.fn.getcwd())

    local bin = "ngserver"
    for _, nm in ipairs(probes) do
      local candidate = vim.fs.joinpath(nm, ".bin/ngserver")
      if vim.fn.executable(candidate) == 1 then
        bin = candidate
        break
      end
    end

    local core = ""
    for _, nm in ipairs(probes) do
      local ok, json = pcall(function()
        return vim.json.decode(vim.fn.readblob(vim.fs.joinpath(nm, "@angular/core/package.json")))
      end)
      if ok and json and json.version then
        core = json.version
        break
      end
    end

    -- Both layouts: hoisted (workspace root) and nested (global install).
    local ng_probes = {}
    for _, nm in ipairs(probes) do
      ng_probes[#ng_probes + 1] = nm
      ng_probes[#ng_probes + 1] = vim.fs.joinpath(nm, "@angular/language-server/node_modules")
    end

    return vim.lsp.rpc.start({
      bin,
      "--stdio",
      "--tsProbeLocations", table.concat(probes, ","),
      "--ngProbeLocations", table.concat(ng_probes, ","),
      "--angularCoreVersion", core,
    }, dispatchers)
  end,

  -- An Angular CLI tsconfig.json is solution-style ("files": [] plus
  -- references), so a template opened on its own would land in an empty
  -- program. The server already handles that by loading the sibling .ts —
  -- but only when the languageId is exactly "html", and nvim sends the
  -- filetype verbatim, which for a template is "htmlangular".
  get_language_id = function(_, filetype)
    return filetype == "htmlangular" and "html" or filetype
  end,

  settings = {
    angular = {
      suggest = {
        autoImports = true,
        componentSelectors = true,
        htmlElements = true,
        htmlAttributes = true,
      },
    },
  },
}
