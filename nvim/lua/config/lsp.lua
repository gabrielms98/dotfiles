-- Server definitions come from nvim-lspconfig (lsp/*.lua); local overrides
-- live in after/lsp/<name>.lua. Inspect with :checkhealth vim.lsp,
-- restart with :lsp restart.
vim.lsp.enable({
  "lua_ls",
  "tsc", -- typescript-go
  "angularls",
  "eslint",
  "html",
  "jsonls",
  "tailwindcss",
  "emmet_ls",
  "css_variables",
  "ruff",
  "ty",
  "sourcekit",
  "copilot",
})

local icons = { ERROR = "󰅚 ", WARN = "󰀪 ", INFO = "󰋽 ", HINT = "󰌶 " }
local S = vim.diagnostic.severity

vim.diagnostic.config({
  virtual_text = true,
  underline = false,
  update_in_insert = false,
  severity_sort = true,
  float = { border = "rounded", source = true },
  signs = {
    text = {
      [S.ERROR] = icons.ERROR,
      [S.WARN] = icons.WARN,
      [S.INFO] = icons.INFO,
      [S.HINT] = icons.HINT,
    },
    numhl = { [S.ERROR] = "ErrorMsg", [S.WARN] = "WarningMsg" },
  },
  status = {
    format = function(counts)
      local hl = { [S.ERROR] = "DiagnosticError", [S.WARN] = "DiagnosticWarn",
        [S.INFO] = "DiagnosticInfo", [S.HINT] = "DiagnosticHint" }
      local out = {}
      for _, sev in ipairs({ S.ERROR, S.WARN, S.INFO, S.HINT }) do
        if counts[sev] then
          out[#out + 1] = ("%%#%s#%s%d"):format(hl[sev], icons[S[sev]], counts[sev])
        end
      end
      return table.concat(out, " ") .. "%*"
    end,
  },
})

--- Jump to a definition-like location, skipping node_modules and .d.ts when
--- there's something better, without leaving the quickfix list open.
local function goto_filtered(method)
  return function()
    method({
      on_list = function(opts)
        local items = vim.tbl_filter(function(it)
          local f = (it.filename or ""):lower()
          return not f:find("node_modules", 1, true) and not f:find("%.d%.ts$")
        end, opts.items)
        if #items == 0 then items = opts.items end
        vim.fn.setqflist({}, " ", { title = opts.title, items = items })
        vim.cmd("silent cfirst")
      end,
    })
  end
end

-- Clients whose completions are noisy or slow when asked on every keystroke;
-- they still answer on their own trigger characters.
local passive_completion = { emmet_ls = true, tailwindcss = true, css_variables = true }

local word_chars = {}
for c in ("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_"):gmatch(".") do
  word_chars[#word_chars + 1] = c
end

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("user-lsp", { clear = true }),
  callback = function(ev)
    local buf = ev.buf
    local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
    local map = function(mode, lhs, rhs, desc, opts)
      vim.keymap.set(mode, lhs, rhs, vim.tbl_extend("force", { buffer = buf, desc = "LSP: " .. desc }, opts or {}))
    end
    local M = vim.lsp.protocol.Methods

    -- Navigation & actions (native defaults grn/gra/grr/gri/grt/gO also work)
    map("n", "gd", goto_filtered(vim.lsp.buf.definition), "Go to Definition")
    map("n", "gy", goto_filtered(vim.lsp.buf.type_definition), "Go to Type Definition")
    map("n", "gD", vim.lsp.buf.declaration, "Go to Declaration")
    map("n", "gr", vim.lsp.buf.references, "References", { nowait = true })
    map({ "n", "x" }, "ga", vim.lsp.buf.code_action, "Code Action")
    map("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
    map("n", "K", vim.lsp.buf.hover, "Hover")
    map("n", "<leader>e", vim.diagnostic.open_float, "Diagnostic Float")
    map("i", "<C-s>", vim.lsp.buf.signature_help, "Signature Help")

    if client.name == "tsc" then
      local source_action = function(kind)
        return function()
          vim.lsp.buf.code_action({ context = { only = { kind }, diagnostics = {} }, apply = true })
        end
      end
      map("n", "gs", source_action("source.organizeImports"), "Organize Imports")
      -- typescript-go has no addMissingImports kind; fixAll includes it.
      map("n", "gi", source_action("source.fixAll"), "Import All")
    end

    -- Completion: native popup, auto-triggered on every word char. <C-y> accepts
    -- (and applies auto-imports), <C-space> forces it, <C-e> closes.
    if client:supports_method(M.textDocument_completion, buf) and client.name ~= "copilot" then
      if not passive_completion[client.name] then
        local provider = client.server_capabilities.completionProvider
        provider.triggerCharacters = vim.list_extend(vim.deepcopy(word_chars), provider.triggerCharacters or {})
      end
      vim.lsp.completion.enable(true, client.id, buf, { autotrigger = true })
      vim.bo[buf].autocomplete = false -- LSP takes over from keyword autocomplete
      map("i", "<C-Space>", vim.lsp.completion.get, "Trigger Completion")
    end

    -- Copilot ghost text: <C-l> accept, <C-j>/<C-k> cycle
    if client:supports_method(M.textDocument_inlineCompletion, buf) then
      vim.lsp.inline_completion.enable(true, { bufnr = buf })
      map("i", "<C-l>", function()
        if not vim.lsp.inline_completion.get() then return "<C-l>" end
      end, "Accept Copilot", { expr = true })
      map("i", "<C-j>", function() vim.lsp.inline_completion.select({ count = 1 }) end, "Next Copilot")
      map("i", "<C-k>", function() vim.lsp.inline_completion.select({ count = -1 }) end, "Prev Copilot")
    end

    -- Renaming an HTML/JSX open tag renames the closing one
    if client:supports_method(M.textDocument_linkedEditingRange, buf) then
      vim.lsp.linked_editing_range.enable(true, { client_id = client.id })
    end

    if client:supports_method(M.textDocument_inlayHint, buf) then
      map("n", "<leader>th", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = buf }), { bufnr = buf })
      end, "Toggle Inlay Hints")
    end

    -- Highlight other references of the symbol under the cursor
    if client:supports_method(M.textDocument_documentHighlight, buf) then
      local group = vim.api.nvim_create_augroup("user-lsp-highlight-" .. buf, { clear = true })
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        buffer = buf, group = group, callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        buffer = buf, group = group, callback = vim.lsp.buf.clear_references,
      })
    end
  end,
})

vim.api.nvim_create_autocmd("LspDetach", {
  group = vim.api.nvim_create_augroup("user-lsp-detach", { clear = true }),
  callback = function(ev)
    if #vim.lsp.get_clients({ bufnr = ev.buf, method = "textDocument/documentHighlight" }) <= 1 then
      vim.lsp.buf.clear_references()
      pcall(vim.api.nvim_del_augroup_by_name, "user-lsp-highlight-" .. ev.buf)
    end
  end,
})
