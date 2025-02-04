return {
    'vim-test/vim-test',
    config = function ()
       vim.keymap.set('n', '<leader>t', function() vim.cmd('TestNearest') end)
       vim.keymap.set('n', '<leader>T', function() vim.cmd('TestFile') end)
       vim.keymap.set('n', '<leader>a', function() vim.cmd('TestSuit') end)
       vim.cmd('let test#strategy = "vimux"')
    end
}
