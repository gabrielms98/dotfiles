local group = vim.api.nvim_create_augroup("user", { clear = true })
local au = function(event, opts)
  opts.group = group
  vim.api.nvim_create_autocmd(event, opts)
end

-- Don't continue comments on new lines (ftplugins set formatoptions, hence FileType)
au("FileType", { command = "setlocal formatoptions-=cro" })

-- Treesitter highlighting for every filetype that has a parser
au("FileType", { callback = function(ev) pcall(vim.treesitter.start, ev.buf) end })

au("FileType", {
  pattern = "mail",
  callback = function()
    vim.opt_local.textwidth = 0
    vim.opt_local.wrapmargin = 0
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.colorcolumn = "80"
  end,
})

au("FileType", {
  pattern = { "markdown", "text", "tex" },
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.spelllang = "en"
  end,
})

au("TextYankPost", { callback = function() vim.hl.on_yank() end })

-- Reopen files at the last cursor position
au("BufReadPost", {
  callback = function(ev)
    local mark = vim.api.nvim_buf_get_mark(ev.buf, '"')
    if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(ev.buf) then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

au("VimResized", { command = "wincmd =" })
