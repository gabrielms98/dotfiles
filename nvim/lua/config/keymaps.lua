local opts = { noremap = true, silent = true }

vim.keymap.set("n", "<leader>lg", "<cmd>silent !bash ~/.config/tmux-lazygit.sh<CR>")
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("n", "<C-d>", "<C-d>zz", opts)
vim.keymap.set("n", "<C-u>", "<C-u>zz", opts)
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("i", "<C-c>", "<Esc>")
vim.keymap.set("n", "<C-b>", "<cmd>silent !tmux neww ~/.config/tmux-finder.sh<CR>")
vim.keymap.set("n", "<leader>ac", "<cmd>lua AngularComponentSnippet()<CR>", { desc = "Angular Component Snippet" })
