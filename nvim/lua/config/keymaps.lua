local map = vim.keymap.set
local silent = { silent = true }

-- tmux popups
map("n", "<leader>lg", "<cmd>silent !bash ~/.config/tmux-lazygit.sh<CR>")
map("n", "<leader>ldc", "<cmd>silent !bash ~/.config/tmux-lazydocker.sh<CR>")
map("n", "<leader>cl", "<cmd>silent !bash ~/.config/tmux-claude-code.sh<CR>")
map("n", "<leader>op", "<cmd>silent !bash ~/.config/tmux-opencode-agent.sh<CR>")
map("n", "<C-b>", "<cmd>silent !tmux neww ~/.config/tmux-finder.sh<CR>")

-- Editing
map("n", "J", "mzJ`z")
map("v", "J", ":m '>+1<CR>gv=gv", silent)
map("v", "K", ":m '<-2<CR>gv=gv", silent)
map("n", "<C-d>", "<C-d>zz", silent)
map("n", "<C-u>", "<C-u>zz", silent)
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")
map("i", "<C-c>", "<Esc>")

-- Terminal split
map("n", "<C-\\>", function() require("config.terminal").toggle() end, { desc = "Toggle terminal" })

-- Undotree (built in)
map("n", "<leader>u", function()
  vim.cmd.packadd("nvim.undotree")
  vim.cmd.Undotree()
end, { desc = "Undotree" })

-- Angular
map("n", "<leader>ac", function() require("config.snippets").angular_component() end,
  { desc = "Angular Component Snippet" })

-- File paths
map("n", "<leader>Y", function()
  local path = vim.fn.expand("%:p")
  vim.fn.setreg("+", path)
  vim.notify("Copied " .. path)
end, { desc = "Copy File Path" })
map("n", "<leader>y", function()
  local path = vim.fn.expand("%:~:.")
  vim.fn.setreg("+", path)
  vim.notify("Copied " .. path)
end, { desc = "Copy Relative File Path" })

-- Seamless split/tmux pane navigation (replaces vim-tmux-navigator).
-- The tmux side is the vim-tmux-navigator tmux plugin in tmux.conf.
local function navigate(wincmd, tmux_dir)
  return function()
    local win = vim.api.nvim_get_current_win()
    vim.cmd.wincmd(wincmd)
    if vim.env.TMUX and win == vim.api.nvim_get_current_win() then
      vim.system({ "tmux", "select-pane", "-" .. tmux_dir })
    end
  end
end
map("n", "<C-Left>", navigate("h", "L"), { desc = "Pane left" })
map("n", "<C-Down>", navigate("j", "D"), { desc = "Pane down" })
map("n", "<C-Up>", navigate("k", "U"), { desc = "Pane up" })
map("n", "<C-Right>", navigate("l", "R"), { desc = "Pane right" })
