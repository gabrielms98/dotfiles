return {
    "mfussenegger/nvim-lint",
    config = function()
        local lint = require("lint")
        lint.linters_by_ft = {
            javascript = {"eslint"},
            typescript = {"eslint"},
            python = {"flake8"},
        }

        vim.api.nvim_create_autocmd(
        {"BufEnter", "BufWritePost"},
            {
                callback = function()
                    lint.try_lint()
                end
            }
        )
    end
}
