return {
  -- Autoformat
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>nft',
      function()
        require('conform').format { async = true, lsp_format = 'fallback' }
      end,
      mode = 'n',
      desc = '[F]ormat buffer',
    },
  },
  opts = {
    notify_on_error = false,
    formatters_by_ft = {
      lua = { 'stylua' },
      typescript = { 'prettier', 'eslint_d', stop_after_first = true },
      python = { 'isort', 'black' },
      javascript = { 'prettier', stop_after_first = true },
      htmlangular = { 'prettier', stop_after_first = true },
      html = { 'prettier', stop_after_first = true },
      angular = { 'prettier', stop_after_first = true },
      json = { 'prettier', stop_after_first = true },
      css = { 'prettier', stop_after_first = true },
      scss = { 'prettier', stop_after_first = true },
      yaml = { 'prettier', stop_after_first = true },
      markdown = { 'prettier', stop_after_first = true },
      csharp = { 'csharpier', stop_after_first = true },
    },
  },
}
