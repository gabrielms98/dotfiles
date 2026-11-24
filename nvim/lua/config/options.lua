vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- oil.nvim browses directories
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local o = vim.opt

-- Editing
o.clipboard = "unnamedplus"
o.expandtab = true
o.shiftwidth = 2
o.smartindent = true
o.breakindent = true
o.wrap = true
o.iskeyword:append("-") -- "foo-bar" is one word for w, *, ciw...
o.undofile = true
o.swapfile = false
o.backup = false
o.writebackup = false
o.confirm = true
o.fileencoding = "utf-8"
o.mouse = "a"

-- Search
o.ignorecase = true
o.smartcase = true
o.hlsearch = true
o.incsearch = true

-- UI
o.termguicolors = true
o.number = true
o.relativenumber = true
o.numberwidth = 4
o.cursorline = true
o.signcolumn = "yes:1"
o.scrolloff = 8
o.splitbelow = true
o.splitright = true
o.showtabline = 0
o.showmode = true
o.showcmd = false
o.ruler = true
o.title = true
o.cmdheight = 1
o.fillchars = { eob = " " }
o.winborder = "none"
o.guicursor = ""
o.guifont = "GeistMono NF:h17"
o.conceallevel = 0
o.pumheight = 12

-- Timing
o.timeoutlen = 1000
o.updatetime = 250

-- Completion (native). Buffers without an LSP get keyword autocompletion;
-- LSP buffers switch to vim.lsp.completion autotrigger (see config/lsp.lua).
o.autocomplete = true
o.complete = ".^5,w^5,b^5"
o.completeopt = { "menuone", "noselect", "popup", "fuzzy" }

-- ui2: native floating cmdline + messages (no "Press ENTER")
require("vim._core.ui2").enable({
  msg = {
    targets = {
      default = "msg",
      emsg = "pager",
      echoerr = "pager",
      lua_error = "pager",
      rpc_error = "pager",
      list_cmd = "pager",
      shell_out = "pager",
      shell_err = "pager",
      verbose = "pager",
      search_count = "cmd",
      typed_cmd = "cmd",
      wildlist = "cmd",
      confirm = "cmd",
    },
    msg = { height = 0.3 },
    pager = { height = 0.5 },
  },
})
o.messagesopt = "hit-enter,history:1000,progress:c,timeout:4000"

vim.api.nvim_create_user_command("Vex", "vsplit", {})
vim.api.nvim_create_user_command("Sex", "split", {})
