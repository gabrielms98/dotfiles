require('nvim-treesitter.configs').setup({
    ensure_installed = { "c", "cpp", "javascript", "python", "rust", "lua", "typescript", "html", "css", "scss" },
    sync_install = false,

    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },

  rainbow = {
    enable = true,
    extended_mode = false,
    max_file_lines = nil,
  }
})


