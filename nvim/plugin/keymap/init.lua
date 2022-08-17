local Remap = require("gabrielmartins.keymap")
local nnoremap = Remap.nnoremap
local vnoremap = Remap.vnoremap
local inoremap = Remap.inoremap
local xnoremap = Remap.xnoremap
local tnoremap = Remap.tnoremap
local nmap = Remap.nmap

-- Nice to have
nmap("<leader>gs", ":Neogit<CR>")
nmap("<leader>nft", ":Neoformat<CR>")

-- Terminal mode
tnoremap("<Esc>", "<C-\\><C-n>")

nnoremap("Y", "yg$")
nnoremap("n", "nzzzv")
nnoremap("N", "Nzzzv")
nnoremap("J", "mzJ`z")
nnoremap("<C-d>", "<C-d>zz")
nnoremap("<C-u>", "<C-u>zz")
vnoremap("J", ":m '>+1<CR>gv=gv")
vnoremap("K", ":m '<-2<CR>gv=gv")

xnoremap("<leader>p", "\"_dP")
nnoremap("<leader>s", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>")

-- Tmux session maker
nnoremap("<C-f>", "<cmd>silent !tmux neww ~/.config/tmux-finder.sh<CR>")
