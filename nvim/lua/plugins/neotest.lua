---@diagnostic disable: missing-fields
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
    -- Helper function to find Nx project root by looking for nx.json
    local function get_project_root(path)
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

      -- Fallback: return the original path if nx.json not found
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

    require("neotest").setup {
      adapters = {
        require("neotest-jest")({
          -- 1. Use 'nx test' command to run tests via the Nx task runner
          jestCommand = "nx test",

          -- 2. Define how Neotest finds the project root (the specific app/lib)
          cwd = function(path)
            vim.print("Determining project root for path: " .. path .. " | " .. get_project_root(path))
            return get_project_root(path)
          end,

          -- 3. Pass the project name to the nx command dynamically
          jestArguments = function(default_args, context)
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
                -- Skip Jest-specific flags that Nx doesn't understand
              elseif not arg:match("^--testLocationInResults")
                  and not arg:match("^--json")
                  and not arg:match("^--outputFile")
                  and not arg:match("^--listTests")
                  and not arg:match("^--findRelatedTests")
                  and not arg:match("^--forceExit") then
                -- Keep other arguments that might be useful for Nx
                table.insert(nx_args, arg)
              end
            end

            -- Add test file using Nx's --testFile flag if found
            if test_file then
              -- Convert absolute path to relative path from project root if needed
              local project_root = get_project_root(context.file)
              local plenary_path = require("plenary.path")
              local test_path = plenary_path:new(test_file)

              -- Try to make path relative to project root
              local relative_path = test_path:make_relative(project_root)
              table.insert(nx_args, "--testFile=" .. relative_path)
            end

            return nx_args
          end,
          env = { CI = true },
        }),
      },
      icons = {
        passed = "✔️",
        running = "🏃",
        failed = "❌",
        skipped = "⏭️",
        unknown = "❓",
      },
      log_level = vim.log.levels.DEBUG,
    }

    vim.api.nvim_set_keymap("n", "<leader>tw",
      "<cmd>lua require('neotest').run.run()<cr>", {})
  end
}
