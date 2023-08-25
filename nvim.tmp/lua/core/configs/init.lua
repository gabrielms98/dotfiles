require("core.configs.treesitter")
require("core.configs.harpoon")
require("core.configs.lsp")
require("core.configs.telescope")
require("core.configs.copilot")
require("core.configs.lualine")
require("core.configs.gitsigns")
require("core.configs.neoformat")

local augroup = vim.api.nvim_create_augroup
local GabrielGroup = augroup('GabrielGroup', {})

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup('HighlightYank', {})

function R(name)
    require("plenary.reload").reload_module(name)
end

autocmd('TextYankPost', {
    group = yank_group,
    pattern = '*',
    callback = function()
        vim.highlight.on_yank({
            higroup = 'IncSearch',
            timeout = 40,
        })
    end,
})

autocmd({"BufWritePre"}, {
    group = GabrielGroup,
    pattern = "*",
    command = "%s/\\s\\+$//e",
})

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
vim.g.netrw_localrmdir = "rm -rf"

vim.g.python3_host_prog = "/opt/homebrew/bin/python3"
