require('nvim-treesitter.configs').setup({
    ensure_installed = { "c", "cpp", "javascript", "python", "rust", "lua", "typescript", },
    sync_install = false,

    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },

  rainbow = {
    enable = true,
    extended_mode = true,
    max_file_lines = nil,
  }
})


