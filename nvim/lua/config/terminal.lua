local M = {}

local terminal_buf_id = nil
local TERMINAL_HEIGHT_RATIO = 0.30

local function find_window_for_buf(buf_id)
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_buf(win) == buf_id then
      return win
    end
  end
  return nil
end

local function is_terminal_buf_valid()
  return terminal_buf_id
      and vim.api.nvim_buf_is_valid(terminal_buf_id)
      and vim.bo[terminal_buf_id].buftype == "terminal"
end

function M.toggle()
  if is_terminal_buf_valid() then
    local win = find_window_for_buf(terminal_buf_id)
    if win then
      vim.api.nvim_win_close(win, true)
      return
    end
  end

  -- Open or reopen terminal in a horizontal split at 30% height
  local height = math.floor(vim.o.lines * TERMINAL_HEIGHT_RATIO)
  vim.cmd(height .. "split")

  if is_terminal_buf_valid() then
    vim.api.nvim_win_set_buf(vim.api.nvim_get_current_win(), terminal_buf_id)
  else
    vim.cmd("terminal")
    terminal_buf_id = vim.api.nvim_get_current_buf()

  end
end

return M
