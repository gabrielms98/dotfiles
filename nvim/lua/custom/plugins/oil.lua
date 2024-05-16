return {
    "stevearc/oil.nvim",
    config = function()
        require("oil").setup(
            {
                keymaps = {
                    ["g?"] = "actions.show_help",
                    ["<CR>"] = "actions.select",
                    ["<C-c>"] = "actions.close",
                    ["<C-l>"] = "actions.refresh",
                    ["-"] = "actions.parent",
                    ["_"] = "actions.open_cwd",
                    ["gs"] = "actions.change_sort",
                    ["g\\"] = "actions.toggle_trash"
                },
                use_default_keymaps = false,
                view_options = {
                    show_hidden = true
                }
            }
        )
    end
}
