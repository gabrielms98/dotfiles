local augroup = vim.api.nvim_create_augroup
GabrielGroup = augroup("GabrielMartins", {})

require("gabrielmartins.set")
require("gabrielmartins.packer")
require("gabrielmartins.neogit")

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
vim.g.gitblame_enabled = 0

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup('HighlightYank', {})

vim.g.python3_host_prog = "/usr/bin/python3"
vim.g.loaded_perl_provider = 0

vim.opt.clipboard:append({ "unnamedplus" })


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

autocmd({"BufEnter", "BufWinEnter", "TabEnter"}, {
    group = GabrielGroup,
    pattern = "*.rs",
    callback = function()
        require("lsp_extensions").inlay_hints{}
    end
})

autocmd({"BufWritePre"}, {
    group = GabrielGroup,
    pattern = "*",
    command = "%s/\\s\\+$//e",
})

autocmd({"BufWritePre"}, {
    group = GabrielGroup,
    pattern = "*.{js,jsx,ts,tsx}",
    command = "EslintFixAll"
})
