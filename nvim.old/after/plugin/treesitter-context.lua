require("nvim-gps").setup()

vim.keymap.set(
    "n",
    "gc",
    function()
        require("treesitter-context").go_to_context()
    end,
    {silent = true}
)
