local Remap = require("gabrielmartins.keymap")

local nnoremap = Remap.nnoremap
local vnoremap = Remap.vnoremap

nnoremap("<F6>", ":lua require('dap').continue()<CR>")
nnoremap("<M-d>b", ":lua require('dap').toggle_breakpoint()<CR>")
nnoremap("<M-d>o", ":lua require('dapui').toggle()<CR>")

nnoremap("<leader>dn", ":lua require('dap-python').test_method()<CR>")
nnoremap("<leader>df", ":lua require('dap-python').test_class()<CR>")
vnoremap("<leader>ds", "<ESC>:lua require('dap-python').debug_selection()<CR>")

