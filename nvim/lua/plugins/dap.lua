return {
  "mfussenegger/nvim-dap",
  commit = "7ff6936010b7222fea2caea0f67ed77f1b7c60dd",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "theHamsta/nvim-dap-virtual-text",
    "mfussenegger/nvim-dap-python",
    {
      "microsoft/vscode-js-debug",
      opt = true,
      -- Build dapDebugServer (accepts port as argv; standard-compliant since 1.77, no nvim-dap-vscode-js needed)
      build = "npm install --legacy-peer-deps && npx gulp dapDebugServer && mv dist out",
    },
  },
  keys = {
    { "<leader>db", "<cmd>lua require('dap').toggle_breakpoint()<cr>", desc = "Toggle breakpoint" },
    { "<leader>dc", "<cmd>lua require('dap').continue()<cr>",          desc = "Continue" },
    { "<leader>di", "<cmd>lua require('dap').step_into()<cr>",         desc = "Step into" },
    { "<leader>do", "<cmd>lua require('dap').step_over()<cr>",         desc = "Step over" },
    { "<leader>dO", "<cmd>lua require('dap').step_out()<cr>",          desc = "Step out" },
    { "<leader>dr", "<cmd>lua require('dap').repl.toggle()<cr>",       desc = "Toggle REPL" },
    { "<leader>dl", "<cmd>lua require('dap').run_last()<cr>",          desc = "Run last" },
    { "<leader>du", "<cmd>lua require('dapui').toggle()<cr>",          desc = "Toggle DAP UI" },
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    -- DAP UI
    dapui.setup()
    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end

    -- Virtual text at breakpoints
    require("nvim-dap-virtual-text").setup({ commented = true })

    -- JavaScript/TypeScript: define adapters ourselves (no nvim-dap-vscode-js).
    -- See https://github.com/mfussenegger/nvim-dap/issues/1411 — vscode-js-debug 1.77+ is
    -- standard-compliant; run dapDebugServer.js with ${port} so nvim-dap knows the port upfront.
    local js_debug_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug"
    local dap_debug_js = js_debug_path .. "/out/src/dapDebugServer.js"
    if vim.fn.filereadable(dap_debug_js) == 1 then
      dap.adapters["pwa-node"] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = "node",
          args = { dap_debug_js, "${port}" },
        },
      }
      dap.adapters["pwa-chrome"] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = "node",
          args = { dap_debug_js, "${port}" },
        },
      }

      local js_configs = {
        {
          type = "pwa-node",
          request = "launch",
          name = "Monument API",
          runtimeExecutable = "yarn",
          runtimeArgs = { "start:debug", "--", "--inspect-brk" },
          console = "integratedTerminal",
          cwd = "${workspaceFolder}",
          rootPath = "${workspaceFolder}",
          sourceMaps = true,
          stopOnEntry = false,
        },
        {
          type = "pwa-node",
          request = "launch",
          name = "Launch current file (Node)",
          program = "${file}",
          cwd = "${workspaceFolder}",
        },
        {
          type = "pwa-node",
          request = "attach",
          name = "Attach to Node process",
          processId = require("dap.utils").pick_process,
          cwd = "${workspaceFolder}",
        },
        {
          type = "pwa-node",
          request = "attach",
          name = "Attach to Node (port 9229)",
          port = 9229,
          cwd = "${workspaceFolder}",
        },
        {
          type = "pwa-chrome",
          request = "launch",
          name = "Launch Chrome",
          url = "http://localhost:4200",
          webRoot = "${workspaceFolder}",
        },
      }

      for _, lang in ipairs({ "typescript", "javascript" }) do
        dap.configurations[lang] = js_configs
      end
    end

    -- Python (debugpy)
    require("dap-python").setup(nil)
    table.insert(dap.configurations.python, {
      type = "python",
      request = "launch",
      name = "Python: Flask",
      module = "flask",
      args = { "run", "--no-debugger", "--no-reload", "--host=0.0.0.0" },
      jinja = true,
      cwd = "${workspaceFolder}",
      env = { FLASK_APP = "app" },
    })
  end,
}
