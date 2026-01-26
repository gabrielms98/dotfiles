local api = vim.api

-- don't auto comment new line
api.nvim_create_autocmd("BufEnter", { command = [[set formatoptions-=cro]] })

-- wrap words softly
api.nvim_create_autocmd("FileType", {
  pattern = "mail",
  callback = function()
    vim.opt.textwidth = 0
    vim.opt.wrapmargin = 0
    vim.opt.warp = rtue
    vim.opt.linebreak = true
    vim.opt.columns = 80
    vim.opt.colorcolumn = "80"
  end
})

-- highlight on yank
api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end
})

-- go to last loc when opening a buffer
-- this mean that when you open a file, you will be at the last position
api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Enable spell checking for certain file types
api.nvim_create_autocmd(
  { "BufRead", "BufNewFile" },
  -- { pattern = { "*.txt", "*.md", "*.tex" }, command = [[setlocal spell<cr> setlocal spelllang=en,de<cr>]] }
  {
    pattern = { "*.txt", "*.md", "*.tex" },
    callback = function()
      vim.opt.spell = true
      vim.opt.spelllang = "en"
    end,
  }
)

-- resize neovim split when terminal is resized
vim.api.nvim_command("autocmd VimResized * wincmd =")

-- Helpers to apply specific tsserver code actions via ts_ls
local function ts_apply_action_by_kind(kind)
  -- Prefer context.only to request a specific server-side action
  vim.lsp.buf.code_action({ context = { only = { kind } } })
end

local function ts_add_missing_imports()
  ts_apply_action_by_kind("source.addMissingImports.ts")
end

local function ts_organize_imports()
  ts_apply_action_by_kind("source.organizeImports.ts")
end

api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
  callback = function(event)
    local map = function(keys, func, desc)
      vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
    end
    local client = vim.lsp.get_client_by_id(event.data.client_id)

    -- Bind gs/gi to ts_ls filtered code actions (works when ts_ls provides them)
    if client and client.name == "ts_ls" then
      map("gs", ts_organize_imports, "Organize Imports")
      map("gi", ts_add_missing_imports, "Import All")
    elseif client and client.name == "typescript-tools" then
      map("gs", "<cmd>TSToolsOrganizeImports<CR>", "Organize Imports")
      map("gi", "<cmd>TSToolsAddMissingImports<CR>", "Import All")
    end

    map("<leader>e", vim.diagnostic.open_float, "Open Diagnostic Float")
    map("K", vim.lsp.buf.hover, "Hover Documentation")
    -- Custom gd: go to first non-node_modules definition without opening quickfix
    local function go_to_first_definition()
      vim.lsp.buf.definition({
        on_list = function(options)
          local items = options.items or {}
          -- filter out node_modules and .d.ts
          local filtered = {}
          for _, it in ipairs(items) do
            local fname = it.filename or it.uri or ""
            local lower = tostring(fname):lower()
            if not lower:find("node_modules") and not lower:find("%.d%.ts$") then
              table.insert(filtered, it)
            end
          end
          if #filtered == 0 then
            filtered = items
          end
          if #filtered == 1 then
            vim.fn.setqflist({ filtered[1] }, "r")
            vim.cmd("cfirst")
          else
            -- Jump to first; do not keep the list open
            options.items = filtered
            vim.fn.setqflist({}, " ", options)
            vim.cmd("cfirst")
            vim.cmd("cclose")
          end
        end,
      })
    end
    map("gd", go_to_first_definition, "Go to Definition")
    map("ga", vim.lsp.buf.code_action, "Code Action")
    map("<leader>rn", vim.lsp.buf.rename, "Rename")
    map("gD", vim.lsp.buf.declaration, "Go To Declaration")
    map("gr", vim.lsp.buf.references, "Go To References")
    vim.keymap.set('i', '<C-s>', vim.lsp.buf.signature_help,
      { silent = true, buffer = true, desc = "Show function signature" })

    vim.keymap.set('i', '<c-space>', function()
      vim.lsp.completion.get()
    end)

    local function client_supports_method(client, method, bufnr)
      if vim.fn.has 'nvim-0.11' == 1 then
        return client:supports_method(method, bufnr)
      else
        return client.supports_method(method, { bufnr = bufnr })
      end
    end

    if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
      local highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })

      vim.api.nvim_create_autocmd('LspDetach', {
        group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds { group = 'lsp-highlight', buffer = event2.buf }
        end,
      })
    end

    if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
      map('<leader>th', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
      end, '[T]oggle Inlay [H]ints')
    end
  end
})

-- Command: jump to type definition under cursor
vim.api.nvim_create_user_command('LspGoToType', function()
  vim.lsp.buf.type_definition({
    on_list = function(options)
      local items = options.items or {}
      local filtered = {}
      for _, it in ipairs(items) do
        local fname = it.filename or it.uri or ""
        local lower = tostring(fname):lower()
        if not lower:find("node_modules") and not lower:find("%.d%.ts$") then
          table.insert(filtered, it)
        end
      end
      if #filtered == 0 then filtered = items end
      if #filtered == 1 then
        vim.fn.setqflist({ filtered[1] }, "r")
        vim.cmd("cfirst")
      else
        options.items = filtered
        vim.fn.setqflist({}, " ", options)
        vim.cmd("cfirst")
        vim.cmd("cclose")
      end
    end,
  })
end, { desc = "Go to type definition" })

api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup('lsp-type-def', { clear = true }),
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client.name == "ts_ls" then
      vim.keymap.set("n", "gy", function() vim.cmd("LspGoToType") end, { buffer = event.buf, desc = "LSP: Go to Type" })
    end
  end,
})

api.nvim_create_autocmd("FileType", {
  callback = function()
    pcall(vim.treesitter.start)
  end,
})
