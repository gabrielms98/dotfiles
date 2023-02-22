function Colors(color)
    color = color or "catppuccin-mocha"

    vim.cmd.colorscheme(color)

    vim.api.nvim_set_hl(0, "Normal", {bg = "none"})
    vim.api.nvim_set_hl(0, "NormalFloat", {bg = "none"})

    local hl = function(thing, opts)
        vim.api.nvim_set_hl(0, thing, opts)
    end

    hl(
        "SignColumn",
        {
            bg = "none"
        }
    )

    hl(
        "ColorColumn",
        {
            ctermbg = 0,
            bg = "#555555"
        }
    )

    hl(
        "CursorLineNR",
        {
            bg = "None"
        }
    )

    hl(
        "Normal",
        {
            bg = "none"
        }
    )

    hl(
        "LineNr",
        {
            fg = "#5eacd3"
        }
    )

    hl(
        "netrwDir",
        {
            fg = "#5eacd3"
        }
    )
end

require("catppuccin").setup(
    {
        flavour = "mocha", -- latte, frappe, macchiato, mocha
        term_colors = true,
        transparent_background = true,
        no_italic = false,
        no_bold = false,
        styles = {
            comments = {},
            conditionals = {},
            loops = {},
            functions = {},
            keywords = {},
            strings = {},
            variables = {},
            numbers = {},
            booleans = {},
            properties = {},
            types = {}
        },
        color_overrides = {
            mocha = {
                base = "#000000",
                mantle = "#000000",
                crust = "#000000"
            }
        },
        highlight_overrides = {
            mocha = function(C)
                return {
                    TabLineSel = {bg = C.pink},
                    CmpBorder = {fg = C.surface2},
                    Pmenu = {bg = C.none},
                    TelescopeBorder = {link = "FloatBorder"}
                }
            end
        }
    }
)

Colors()
