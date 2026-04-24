-- Xcode / sourcekit-lsp integration.
--
-- :XcodeRefresh   incremental build, append fresh compile flags to .compile,
--                 then restart sourcekit-lsp. Run after adding files or
--                 changing build settings.
-- :XcodeRefresh!  same but does a clean build and overwrites .compile.

local function find_root()
  local dir = vim.fn.getcwd()
  while dir and dir ~= "/" do
    if vim.fn.filereadable(dir .. "/buildServer.json") == 1 then
      return dir
    end
    local parent = vim.fn.fnamemodify(dir, ":h")
    if parent == dir then break end
    dir = parent
  end
  return nil
end

local function read_bsp(root)
  local f = io.open(root .. "/buildServer.json", "r")
  if not f then return nil end
  local content = f:read("*a")
  f:close()
  local ok, data = pcall(vim.json.decode, content)
  if not ok then return nil end
  return data
end

local function project_args(bsp)
  local ws = bsp.workspace or ""
  if ws:match("/project%.xcworkspace$") then
    return { "-project", (ws:gsub("/project%.xcworkspace$", "")) }
  end
  return { "-workspace", ws }
end

local function notify(msg, level)
  vim.notify(msg, level or vim.log.levels.INFO, { title = "Xcode" })
end

local function restart_sourcekit()
  for _, c in ipairs(vim.lsp.get_clients({ name = "sourcekit" })) do
    vim.lsp.stop_client(c.id, true)
  end
end

local function refresh(clean)
  local root = find_root()
  if not root then
    notify("buildServer.json not found in cwd ancestors", vim.log.levels.ERROR)
    return
  end
  local bsp = read_bsp(root)
  if not bsp or not bsp.scheme then
    notify("could not read scheme from buildServer.json", vim.log.levels.ERROR)
    return
  end

  local xcb = { "xcodebuild" }
  for _, a in ipairs(project_args(bsp)) do table.insert(xcb, a) end
  vim.list_extend(xcb, {
    "-scheme", bsp.scheme,
    "-destination", "generic/platform=iOS Simulator",
  })
  if clean then table.insert(xcb, "clean") end
  table.insert(xcb, "build")

  local quoted = {}
  for _, a in ipairs(xcb) do table.insert(quoted, vim.fn.shellescape(a)) end
  local parse = clean
      and "xcode-build-server parse"
      or ("xcode-build-server parse -a -o " .. vim.fn.shellescape(root .. "/.compile"))
  local cmd = string.format(
    "cd %s && %s 2>&1 | %s",
    vim.fn.shellescape(root),
    table.concat(quoted, " "),
    parse
  )

  notify(string.format("xcodebuild %sbuild (scheme=%s)…", clean and "clean " or "", bsp.scheme))

  vim.fn.jobstart({ "sh", "-c", cmd }, {
    stdout_buffered = true,
    stderr_buffered = true,
    on_exit = function(_, code)
      vim.schedule(function()
        if code == 0 then
          notify("build & parse OK — restarting sourcekit")
          restart_sourcekit()
        else
          notify("xcodebuild/parse exited " .. code, vim.log.levels.ERROR)
        end
      end)
    end,
  })
end

vim.api.nvim_create_user_command("XcodeRefresh", function(opts)
  refresh(opts.bang)
end, {
  bang = true,
  desc = "Rebuild Xcode project & refresh sourcekit-lsp (! = clean build)",
})
