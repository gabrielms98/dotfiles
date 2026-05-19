return {
  "dmtrKovalenko/fff.nvim",
  build = "cargo build --release",
  opts = {
    keymaps = { close = { '<C-c>', 'Esc' } },
    preview = { line_numbers = true },
  },
  keys = {
    {
      "<C-p>",
      function()
        local current_buf = vim.api.nvim_get_current_buf()
        local current_win = vim.api.nvim_get_current_win()
        local ft = vim.bo[current_buf].filetype

        -- If in Oil, store the window so we can open the file there
        if ft == 'oil' then
          _G._fff_oil_win = current_win
        else
          _G._fff_oil_win = nil
        end

        require("fff").find_files()
      end,
      desc = "Toggle FFF",
    },
  },
  config = function(_, opts)
    require("fff").setup(opts)

    -- Override the select function to handle Oil windows
    local picker_ui = require("fff.picker_ui")
    local original_select = picker_ui.select

    picker_ui.select = function(action)
      local oil_win = _G._fff_oil_win
      _G._fff_oil_win = nil

      if oil_win and vim.api.nvim_win_is_valid(oil_win) and (action == nil or action == 'edit') then
        local items = picker_ui.state.filtered_items
        if #items == 0 or picker_ui.state.cursor > #items then return end

        local item = items[picker_ui.state.cursor]
        if not item then return end

        local relative_path = vim.fn.fnamemodify(item.path, ':.')

        vim.cmd('stopinsert')
        picker_ui.close()

        -- Open file in the Oil window
        vim.api.nvim_set_current_win(oil_win)
        vim.cmd('edit ' .. vim.fn.fnameescape(relative_path))
      else
        original_select(action)
      end
    end
  end,
}
