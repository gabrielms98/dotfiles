vim.cmd [[packadd packer.nvim]]

return require("packer").startup(
    function(use)
        -- Packer can manage itself
        use("wbthomason/packer.nvim")

        --Telescope
        use {
            "nvim-telescope/telescope.nvim",
            tag = "0.1.1",
            requires = {{"nvim-lua/plenary.nvim"}}
        }

        use("nvim-treesitter/nvim-treesitter", {run = ":TSUpdate"})
        use("romgrk/nvim-treesitter-context")

        use {"ellisonleao/gruvbox.nvim"}
        use {"catppuccin/nvim", as = "catppuccin"}

        -- Harpoon
        use("ThePrimeagen/harpoon")

        -- Undotree
        use("mbbill/undotree")

        -- Git
        use("tpope/vim-fugitive")

        -- LSP
        use {
            "VonHeikemen/lsp-zero.nvim",
            branch = "v1.x",
            requires = {
                -- LSP Support
                {"neovim/nvim-lspconfig"}, -- Required
                {"williamboman/mason.nvim"}, -- Optional
                {"williamboman/mason-lspconfig.nvim"}, -- Optional
                -- Autocompletion
                {"hrsh7th/nvim-cmp"}, -- Required
                {"hrsh7th/cmp-nvim-lsp"}, -- Required
                {"hrsh7th/cmp-buffer"}, -- Optional
                {"hrsh7th/cmp-path"}, -- Optional
                {"saadparwaiz1/cmp_luasnip"}, -- Optional
                {"hrsh7th/cmp-nvim-lua"}, -- Optional
                -- Snippets
                {"L3MON4D3/LuaSnip"}, -- Required
                {"rafamadriz/friendly-snippets"}, -- Optional
            }
        }
        use("sbdchd/neoformat")
        use("ray-x/lsp_signature.nvim")
        use("integralist/vim-mypy")

        use(
            {
                "nvim-lualine/lualine.nvim",
                requires = {"kyazdani42/nvim-web-devicons", opt = true}
            }
        )

        use("tpope/vim-sleuth")

        use("lewis6991/gitsigns.nvim")

        use("github/copilot.vim")

        use("tpope/vim-commentary")

        use("kdheepak/lazygit.nvim")
    end
)
