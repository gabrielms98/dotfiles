require("core.lsp")

-- Compatibility shim for Neovim versions where vim.treesitter.language.ft_to_lang was removed
-- Some plugins (like older Telescope versions) still call this function.
if vim.treesitter
  and vim.treesitter.language
  and vim.treesitter.language.get_lang
  and vim.treesitter.language.ft_to_lang == nil
then
  vim.treesitter.language.ft_to_lang = function(ft)
    return vim.treesitter.language.get_lang(ft)
  end
end

require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.snippets")

require("core.lazy")
