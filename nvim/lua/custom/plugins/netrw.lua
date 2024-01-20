return {
    "prichrd/netrw.nvim",
    config = function()
        vim.g.netrw_banner = 0
        require("netrw").setup()
    end
}
