local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
    vim.fn.system(
        {
            "git",
            "clone",
            "--filter=blob:none",
            "https://github.com/folke/lazy.nvim.git",
            "--branch=stable", -- latest stable release
            lazypath
        }
    )
end

vim.opt.rtp:prepend(lazypath)

local plugins = {
    "folke/which-key.nvim",
    {"folke/neoconf.nvim", cmd = "Neoconf"},
    "folke/neodev.nvim",
    "nvim-lua/plenary.nvim",
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.2",
        dependencies = {"nvim-lua/plenary.nvim"}
    },
    -- Treesitter
    "nvim-treesitter/nvim-treesitter",
    "romgrk/nvim-treesitter-context",
    {
        -- Theme inspired by Atom
        "navarasu/onedark.nvim",
        priority = 1000,
        config = function()
            vim.cmd.colorscheme "onedark"
        end
    },
    -- harpooon
    "ThePrimeagen/harpoon",
    {
        "VonHeikemen/lsp-zero.nvim",
        branch = "v2.x",
        dependencies = {
            -- LSP Support
            {"neovim/nvim-lspconfig"}, -- Required
            {
                -- Optional
                "williamboman/mason.nvim",
                build = function()
                    pcall(vim.api.nvim_command, "MasonUpdate")
                end
            },
            {"williamboman/mason-lspconfig.nvim"}, -- Optional
            -- Autocompletion
            {"hrsh7th/nvim-cmp"}, -- Required
            {"hrsh7th/cmp-nvim-lsp"}, -- Required
            {"L3MON4D3/LuaSnip"} -- Required
        }
    },
    "ray-x/lsp_signature.nvim",
    "github/copilot.vim",
    -- lualine
    "nvim-tree/nvim-web-devicons",
    "nvim-lualine/lualine.nvim",
    -- git
    "lewis6991/gitsigns.nvim",
    {"kdheepak/lazygit.nvim", name = "lazygit"},
    -- format
    "sbdchd/neoformat",
    "mbbill/undotree",
    "tpope/vim-commentary",
    "tpope/vim-sleuth",
    {
        -- Set lualine as statusline
        "nvim-lualine/lualine.nvim",
        -- See `:help lualine.txt`
        opts = {
            options = {
                icons_enabled = false,
                theme = "onedark",
                component_separators = "|",
                section_separators = ""
            }
        }
    },
    {
        -- Add indentation guides even on blank lines
        "lukas-reineke/indent-blankline.nvim",
        -- Enable `lukas-reineke/indent-blankline.nvim`
        -- See `:help indent_blankline.txt`
        opts = {
            char = "┊",
            show_trailing_blankline_indent = false
        }
    }
}

local opts = {}

require("lazy").setup(plugins, opts)
