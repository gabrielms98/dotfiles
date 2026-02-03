return {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  build = ':TSUpdate',
  config = function()
    require 'nvim-treesitter'.install { 'javascript', 'python', 'lua', 'rust', 'markdown', 'html', 'go', 'typescript' }
  end
}
