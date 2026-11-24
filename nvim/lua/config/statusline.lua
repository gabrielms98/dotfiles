-- Cheap statusline: everything here reads cached state, nothing spawns a
-- process. Branch comes from gitsigns' buffer variable.

local progress = ""

vim.api.nvim_create_autocmd("LspProgress", {
  group = vim.api.nvim_create_augroup("user-statusline", { clear = true }),
  callback = function(ev)
    local value = ev.data.params.value or {}
    if value.kind == "end" then
      progress = ""
    else
      local client = vim.lsp.get_client_by_id(ev.data.client_id)
      local pct = value.percentage and (" " .. value.percentage .. "%%") or ""
      progress = ("%s: %s%s"):format(client and client.name or "lsp", value.title or "", pct)
    end
    vim.cmd.redrawstatus()
  end,
})

local function lsp_names(buf)
  local names = {}
  for _, c in ipairs(vim.lsp.get_clients({ bufnr = buf })) do
    if c.name ~= "copilot" then names[#names + 1] = c.name end
  end
  return #names > 0 and ("󰒋 " .. table.concat(names, ",")) or ""
end

function _G.user_statusline()
  local buf = vim.api.nvim_win_get_buf(vim.g.statusline_winid or 0)
  local branch = vim.b[buf].gitsigns_head
  local name = vim.api.nvim_buf_get_name(buf)
  local file = name == "" and "[No Name]" or vim.fn.fnamemodify(name, ":~:.")

  local parts = {
    branch and ("󰊢 " .. branch .. " │ ") or "",
    file:gsub("%%", "%%%%"),
    " %m%r",
    "%=",
    progress ~= "" and (progress .. "  ") or "",
    vim.diagnostic.status(buf),
    "  ",
    lsp_names(buf),
    "  %l:%c ",
  }
  return table.concat(parts)
end

vim.o.statusline = "%!v:lua.user_statusline()"
