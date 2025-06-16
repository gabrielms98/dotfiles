return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  config = function()
    local harpoon = require 'harpoon'
    local map = function(key, func)
      vim.keymap.set("n", key, func)
    end

    harpoon:setup()

    map("<leader>a", function() harpoon:list():add() end)
    map("<C-s>", function() harpoon:list():select(1) end)
    map("<C-t>", function() harpoon:list():select(2) end)
    map("<C-n>", function() harpoon:list():select(3) end)
    map("<C-e>", function() harpoon:list():select(4) end)
    map("<C-g>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

  end,
}
