---@diagnostic disable: missing-fields
local function get_project_root(path)
  local plenary_path = require("plenary.path")
  local current_path = plenary_path:new(path or vim.fn.expand("%:p"))

  -- If path is a file, get its directory
  if not current_path:is_dir() then
    current_path = current_path:parent()
  end

  -- Walk up the directory tree looking for project.json first
  local root = current_path
  while root do
    local project_json = root / "project.json"
    if project_json:exists() then
      return tostring(root)
    end

    local parent = root:parent()
    -- Stop if we've reached the filesystem root
    if not parent or tostring(parent) == tostring(root) then
      break
    end
    root = parent
  end

  -- Fallback: look for nx.json if project.json not found
  root = current_path
  while root do
    local nx_json = root / "nx.json"
    if nx_json:exists() then
      return tostring(root)
    end

    local parent = root:parent()
    -- Stop if we've reached the filesystem root
    if not parent or tostring(parent) == tostring(root) then
      break
    end
    root = parent
  end

  -- Fallback: look for .git if neither project.json nor nx.json found
  root = current_path
  while root do
    local git_dir = root / ".git"
    if git_dir:exists() then
      return tostring(root)
    end

    local parent = root:parent()
    -- Stop if we've reached the filesystem root
    if not parent or tostring(parent) == tostring(root) then
      break
    end
    root = parent
  end

  -- Final fallback: return the original path if none found
  return tostring(current_path)
end

-- Helper function to find the monorepo root (where nx.json is)
local function get_monorepo_root(path)
  local plenary_path = require("plenary.path")
  local current_path = plenary_path:new(path or vim.fn.expand("%:p"))

  -- If path is a file, get its directory
  if not current_path:is_dir() then
    current_path = current_path:parent()
  end

  -- Walk up the directory tree looking for nx.json
  local root = current_path
  while root do
    local nx_json = root / "nx.json"
    if nx_json:exists() then
      return tostring(root)
    end

    local parent = root:parent()
    -- Stop if we've reached the filesystem root
    if not parent or tostring(parent) == tostring(root) then
      break
    end
    root = parent
  end

  -- Fallback: look for .git if nx.json not found
  root = current_path
  while root do
    local git_dir = root / ".git"
    if git_dir:exists() then
      return tostring(root)
    end

    local parent = root:parent()
    -- Stop if we've reached the filesystem root
    if not parent or tostring(parent) == tostring(root) then
      break
    end
    root = parent
  end

  -- Final fallback: return the original path
  return tostring(current_path)
end

-- Helper function to find project.json and extract the name attribute
local function get_project_name(path)
  local plenary_path = require("plenary.path")
  local current_path = plenary_path:new(path or vim.fn.expand("%:p"))

  -- If path is a file, get its directory
  if not current_path:is_dir() then
    current_path = current_path:parent()
  end

  -- Walk up the directory tree looking for project.json
  local search_path = current_path
  while search_path do
    local project_json = search_path / "project.json"
    if project_json:exists() then
      -- Read and parse the JSON file
      local content = project_json:read()
      local ok, parsed = pcall(vim.json.decode, content)
      if ok and parsed and parsed.name then
        return parsed.name
      end
    end

    local parent = search_path:parent()
    -- Stop if we've reached the filesystem root
    if not parent or tostring(parent) == tostring(search_path) then
      break
    end
    search_path = parent
  end

  -- Fallback: extract project name from path if project.json not found
  local project_root = get_project_root(path)
  return project_root:match(".*/([^/]+)$") or ""
end
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
    -- Helper function to find Nx project root by looking for project.json (or nx.json as fallback)

    require("neotest").setup {
      adapters = {
        require("neotest-jest")({
          jestCommand = "nx test",
          cwd = function(path)
            -- Use monorepo root (where nx.json is) as the working directory
            return get_monorepo_root(path)
          end,
          jestArguments = function(default_args, context)
            vim.print({ default_args = default_args, context = context })
            local project_name = get_project_name(context.file)

            -- Filter out Jest-specific flags that Nx doesn't understand
            -- and extract the test file path
            local nx_args = { project_name }
            local test_file = nil

            -- Process default_args to find the test file and filter Jest flags
            for _, arg in ipairs(default_args) do
              -- Check if this is a test file path (ends with .test.ts, .test.tsx, .spec.ts, etc.)
              if arg:match("%.test%.[jt]sx?$") or arg:match("%.spec%.[jt]sx?$") then
                test_file = arg
                -- Convert --testNamePattern to -t for Nx
              elseif arg:match("^--testNamePattern") then
                local pattern = arg:match("^--testNamePattern=(.+)$")
                if pattern then
                  table.insert(nx_args, "-t")
                  table.insert(nx_args, pattern)
                else
                  -- Handle case where pattern might be in next argument
                  table.insert(nx_args, "-t")
                end
                -- Allow --json flag (needed for neotest to parse results)
                -- Allow --outputFile flag (needed for neotest to read results)
                -- Skip Jest-specific flags that Nx doesn't understand
              elseif not arg:match("^--testLocationInResults")
                  and not arg:match("^--listTests")
                  and not arg:match("^--findRelatedTests")
                  and not arg:match("^--forceExit")
                  and not arg:match("^--testPathPattern")
                  and not arg:match("^--testMatch") then
                -- Keep other arguments that might be useful for Nx (including --json and --outputFile)
                table.insert(nx_args, arg)
              end
            end

            -- Add test file using Nx's --testFile flag if found
            if test_file then
              -- Convert absolute path to relative path from monorepo root
              local monorepo_root = get_monorepo_root(context.file)
              local plenary_path = require("plenary.path")
              local test_path = plenary_path:new(test_file)

              -- Make path relative to monorepo root
              local relative_path = test_path:make_relative(monorepo_root)
              table.insert(nx_args, "--testFile=" .. relative_path)
            end

            return nx_args
          end,
          env = { CI = true },
        }),
      },
    }

    vim.api.nvim_set_keymap("n", "<leader>tr", "<cmd>lua require('neotest').run.run()<cr>", {})
    vim.api.nvim_set_keymap("n", "<leader>tf", "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>", {})
    vim.api.nvim_set_keymap("n", "<leader>ts", "<cmd>lua require('neotest').summary.toggle()<cr>", {})
    vim.api.nvim_set_keymap("n", "<leader>to", "<cmd>lua require('neotest').output_panel.toggle()<cr>", {})
  end
}
