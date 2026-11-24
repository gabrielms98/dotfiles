local M = {}

local buf = nil
local HEIGHT_RATIO = 0.30

function M.toggle()
  local valid = buf and vim.api.nvim_buf_is_valid(buf)
  if valid then
    local win = vim.fn.bufwinid(buf)
    if win ~= -1 then
      vim.api.nvim_win_close(win, true)
      return
    end
  end

  vim.cmd(math.floor(vim.o.lines * HEIGHT_RATIO) .. "split")
  if valid then
    vim.api.nvim_win_set_buf(0, buf)
  else
    vim.cmd.terminal()
    buf = vim.api.nvim_get_current_buf()
  end
end

return M
