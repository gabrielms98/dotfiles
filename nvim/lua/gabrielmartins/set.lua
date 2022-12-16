vim.opt.number = false
vim.opt.relativenumber = true
vim.opt.nu = true

vim.opt.cursorline = true
vim.opt.autoindent = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.smartindent = true

vim.opt.mouse = "a"
vim.opt.ma = true
vim.opt.clipboard = "unnamedplus"
vim.opt.wrap = false
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"

vim.opt.swapfile = false
vim.opt.guicursor="i:block"

-- Ignore files
vim.opt.wildignore:append("*.pyc")
vim.opt.wildignore:append("*_build/*")
vim.opt.wildignore:append("**/coverage/*")
vim.opt.wildignore:append("**/node_modules/*")
vim.opt.wildignore:append("**/android/*")
vim.opt.wildignore:append("**/ios/*")
vim.opt.wildignore:append("**/.git/*")

vim.opt.cmdheight = 1
vim.opt.shortmess:append("c")

vim.g.mapleader = " "
vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.undofile = true
