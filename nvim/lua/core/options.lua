vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.opt.guicursor = ''

vim.opt.backspace = '2'
vim.opt.showcmd = true
vim.opt.laststatus = 2
vim.opt.autowrite = true
vim.opt.cursorline = true
vim.opt.autoread = true
vim.opt.signcolumn = "yes"

-- use spaces for tabs and whatnot
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.shiftround = true
vim.opt.expandtab = true

vim.cmd [[ set noswapfile ]]
vim.opt.undodir = os.getenv("HOME") .. "/.undodir"
vim.opt.undofile = true

--Line numbers
vim.opt.relativenumber = true
vim.opt.nu = true

vim.opt.wrap = false
vim.opt.scrolloff = 8
vim.opt.showmatch = false
