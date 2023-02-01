local nnoremap = require("gabrielmartins.keymap").nnoremap

local silent = { silent = true }

nnoremap("<leader>a", function() require("harpoon.mark").add_file() end, silent)
nnoremap("<C-e>", function() require("harpoon.ui").toggle_quick_menu() end, silent)
nnoremap("<leader>tc", function() require("harpoon.cmd-ui").toggle_quick_menu() end, silent)

nnoremap("<M-n>", function() require("harpoon.ui").nav_file(1) end, silent) -- Option + n
nnoremap("<M-e>", function() require("harpoon.ui").nav_file(2) end, silent) -- Option + e
nnoremap("<M-i>", function() require("harpoon.ui").nav_file(3) end, silent) -- Option + i
nnoremap("<M-o>", function() require("harpoon.ui").nav_file(4) end, silent) -- Option + o
