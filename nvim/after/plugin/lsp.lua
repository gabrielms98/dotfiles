local lsp = require("lsp-zero")
lsp.preset("recommended")

lsp.configure(
    "pylsp",
    {
        settings = {
            pylsp = {
                plugins = {
                    pycodestyle = {
                        ignore = {"W391", "W503", "E203"},
                        maxLineLength = 120
                    }
                }
            }
        }
    }
)

lsp.ensure_installed(
    {
        "tsserver",
        "eslint",
        "rust_analyzer",
        "pylsp",
    }
)

lsp.nvim_workspace()

lsp.on_attach(
    function(_, bufnr)
        local opts = {buffer = bufnr, remap = false}

        vim.keymap.set(
            "n",
            "gd",
            function()
                vim.lsp.buf.definition()
            end,
            opts
        )
        vim.keymap.set(
            "n",
            "K",
            function()
                vim.lsp.buf.hover()
            end
        )
        vim.keymap.set(
            "n",
            "<leader>gws",
            function()
                vim.lsp.buf.workspace_symbol()
            end
        )
        vim.keymap.set(
            "n",
            "<space>e",
            function()
                vim.diagnostic.open_float()
            end
        )
        vim.keymap.set(
            "n",
            "[d",
            function()
                vim.diagnostic.goto_next()
            end
        )
        vim.keymap.set(
            "n",
            "]d",
            function()
                vim.diagnostic.goto_prev()
            end
        )
        vim.keymap.set(
            "n",
            "<leader>ca",
            function()
                vim.lsp.buf.code_action()
            end
        )
        vim.keymap.set(
            "n",
            "<leader>gr",
            function()
                vim.lsp.buf.references()
            end
        )
        vim.keymap.set(
            "n",
            "<leader>rn",
            function()
                vim.lsp.buf.rename()
            end
        )
        vim.keymap.set(
            "i",
            "<C-h>",
            function()
                vim.lsp.buf.signature_help()
            end
        )
    end
)

lsp.setup_nvim_cmp(
    {
        sources = {
            {name = "nvim_lsp"},
            {name = "luasnip"},
            {name = "buffer"},
            {name = "path"}
        },
        mapping = lsp.defaults.cmp_mappings(
            {
                -- disable completion with tab
                ["<Tab>"] = vim.NIL,
                ["<S-Tab>"] = vim.NIL,
                -- disable confirm with Enter key
                ["<CR>"] = vim.NIL
            }
        )
    }
)

require("lsp_signature").setup()

lsp.setup()

vim.diagnostic.config(
    {
        virtual_text = true,
        signs = true,
        update_in_insert = false,
        underline = true,
        severity_sort = false,
        float = true
    }
)
