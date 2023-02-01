local Remap = require("gabrielmartins.keymap")

local nnoremap = Remap.nnoremap
local inoremap = Remap.inoremap

local cmp = require("cmp")
local lspkind = require("lspkind")

cmp.setup({
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
        ['<C-y>'] = cmp.mapping.confirm({ select = true }),
		["<C-u>"] = cmp.mapping.scroll_docs(-4),
		["<C-d>"] = cmp.mapping.scroll_docs(4),
		["<C-h>"] = cmp.mapping.complete(),
	}),

    formatting = { format = lspkind.cmp_format({
            mode = "symbol_text",
            maxwidth = 50,
            menu = {
                cmp_tabnine = "[TN]",
                nvim_lsp = "[LSP]",
                luasnip = "[LUA]",
                buffer = "[BUF]",
                path = "[PATH]",
            }
        })
    },

	sources = {
		{ name = "cmp_tabnine" },
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "buffer" },
        { name = 'path' }
	},

})

local tabnine = require("cmp_tabnine.config")
tabnine:setup({
	max_lines = 1000,
	max_num_results = 20,
	sort = true,
	run_on_every_keystroke = true,
	snippet_placeholder = "..",
})

local function config(_config)
	return vim.tbl_deep_extend("force", {
		capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities()),
		on_attach = function()
			nnoremap("gd", function() vim.lsp.buf.definition() end)
			nnoremap("K", function() vim.lsp.buf.hover() end)
			nnoremap("<leader>gws", function() vim.lsp.buf.workspace_symbol() end)
			nnoremap("<space>e", function() vim.diagnostic.open_float() end)
			nnoremap("[d", function() vim.diagnostic.goto_next() end)
			nnoremap("]d", function() vim.diagnostic.goto_prev() end)
			nnoremap("<leader>ca", function() vim.lsp.buf.code_action() end)
			nnoremap("<leader>gr", function() vim.lsp.buf.references() end)
			nnoremap("<leader>rn", function() vim.lsp.buf.rename() end)
			inoremap("<C-h>", function() vim.lsp.buf.signature_help() end)
		end,
	}, _config or {})
end

require("lspconfig").pyright.setup(config())

require("lspconfig").tsserver.setup(config())

require("lspconfig").cssls.setup(config({
    settings = {
        tailwindCSS = {
            lint = {
             cssConflict = "warning",
             unknownAtRules = "ignore"
            }
        },
        css = {
            lint = {
                unknownAtRules = "ignore"
            }
        },
        scss = {
            lint = {
                unknownAtRules = "ignore"
            }
        }
    }
}))

require("lspconfig").rust_analyzer.setup(config({
    on_attach=on_attach,
    settings = {
        ["rust-analyzer"] = {
            imports = {
                granularity = {
                    group = "module",
                },
                prefix = "self",
            },
            cargo = {
                buildScripts = {
                    enable = true,
                },
            },
            procMacro = {
                enable = true
            },
        }
    }
}))

require("lspconfig").cssmodules_ls.setup(config())


require("lspconfig").emmet_ls.setup(config({
    filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "htmldjango" },
    init_options = {
      html = {
        options = {
          -- For possible options, see: https://github.com/emmetio/emmet/blob/master/src/config.ts#L79-L267
          ["bem.enabled"] = true,
        },
      },
    }
}))

require"lspconfig".eslint.setup(config())

require("lspconfig").html.setup(config())

require("lspconfig").angularls.setup(config())
