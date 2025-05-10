return {
  'stevearc/oil.nvim',
  config = function()
    require('oil').setup {
      keymaps = {
        ['g?'] = 'actions.show_help',
        ['<CR>'] = 'actions.select',
        ['<C-c>'] = false,
        ['<C-l>'] = 'actions.refresh',
        ['-'] = 'actions.parent',
        ['_'] = 'actions.open_cwd',
        ['gs'] = 'actions.change_sort',
        ['g\\'] = 'actions.toggle_trash',
      },
      use_default_keymaps = false,
      view_options = {
        show_hidden = true,
      },
    }

    vim.keymap.set('n', '<C-f>', '<cmd>Oil<CR>')
    vim.api.nvim_create_user_command('Vex', 'vsplit', {})
    vim.api.nvim_create_user_command('Sex', 'split', {})
  end,
}
