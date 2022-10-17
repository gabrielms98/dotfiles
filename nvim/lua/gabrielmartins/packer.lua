return require("packer").startup(function()
    use("wbthomason/packer.nvim")

    -- Git
    use { 'TimUntersberger/neogit', requires = 'nvim-lua/plenary.nvim' }
    use("f-person/git-blame.nvim")

    -- main plugins
    use("nvim-lua/plenary.nvim")
    use("nvim-lua/popup.nvim")
    use("nvim-telescope/telescope.nvim")
    use {
      'nvim-lualine/lualine.nvim',
      requires = { 'kyazdani42/nvim-web-devicons', opt = true }
    }

    -- LSP
    use("neovim/nvim-lspconfig")
    use("hrsh7th/cmp-nvim-lsp")
    use("hrsh7th/cmp-buffer")
    use("hrsh7th/nvim-cmp")
 	use({'tzachar/cmp-tabnine', run='./install.sh', requires = 'hrsh7th/nvim-cmp'})
    use("onsails/lspkind-nvim")
    use("nvim-lua/lsp_extensions.nvim")
    use("glepnir/lspsaga.nvim")
    use("simrat39/symbols-outline.nvim")
    use("L3MON4D3/LuaSnip")
    use("saadparwaiz1/cmp_luasnip")

    -- DAP
    use("mfussenegger/nvim-dap")
    use("rcarriga/nvim-dap-ui")
    use("theHamsta/nvim-dap-virtual-text")
    use("nvim-telescope/telescope-dap.nvim")
    use("mfussenegger/nvim-dap-python")

    -- Harpooooooon
    use("ThePrimeagen/git-worktree.nvim")
    use("ThePrimeagen/harpoon")

    -- Colorscheme section
    use("gruvbox-community/gruvbox")
    use("nvim-treesitter/nvim-treesitter", {
        run = ":TSUpdate"
    })

    use("nvim-treesitter/playground")
    use("romgrk/nvim-treesitter-context")
    use("p00f/nvim-ts-rainbow")
    -- Formatting
    use("sbdchd/neoformat")

    use("mbbill/undotree")

    -- Goodbye netrw
    use("lambdalisue/nerdfont.vim")
    use({ "lambdalisue/fern.vim", branch = "main" })
    use("lambdalisue/fern-renderer-nerdfont.vim")
    use("lambdalisue/fern-hijack.vim")
    use("antoinemadec/FixCursorHold.nvim")

    -- Maks
    use("tversteeg/registers.nvim")
end)

