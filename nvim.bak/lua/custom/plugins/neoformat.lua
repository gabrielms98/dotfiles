return {
    "sbdchd/neoformat",
    config = function()
        vim.g.neoformat_try_formatprg = 1
        vim.g.neoformat_try_node_exe = 1
        vim.b.neoformat_basic_format_retab = 1
        vim.b.neoformat_basic_format_trim = 1
        vim.b.neoformat_basic_format_align = 1
        vim.b.neformat_run_all_formatters = 1
        vim.g.neoformat_enabled_python = {"pylint", "black", "autopep8", "isort"}

        vim.keymap.set("n", "<leader>nft", ":Neoformat<CR>")
    end
}
