-- Plugins are managed by the built-in vim.pack (:h vim.pack).
--   update:  :lua vim.pack.update()
--   remove:  :lua vim.pack.del({ "name" })
-- Versions are pinned in nvim-pack-lock.json (commit it).

-- WORKAROUND(macOS 27): the Command Line Tools ship the MacOSX27 SDK but a
-- linker that can't read it ("unknown architecture arm64e.x1"), so every
-- parser/native build fails. Xcode's SDK links fine. Drop this once
-- `cc -shared` works again after a CLT update.
local xcode_sdk = "/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk"
if vim.fn.has("mac") == 1 and not vim.env.SDKROOT and vim.uv.fs_stat(xcode_sdk) then
  vim.env.SDKROOT = xcode_sdk
end

-- Build steps. Must be registered before vim.pack.add() so they run on install.
vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if kind ~= "install" and kind ~= "update" then return end

    local function load()
      if not ev.data.active then vim.cmd.packadd(name) end
    end

    if name == "nvim-treesitter" then
      load()
      vim.cmd("TSUpdate")
    elseif name == "fff.nvim" then
      load()
      require("fff.download").download_or_build_binary()
    elseif name == "markdown-preview.nvim" then
      load()
      vim.fn["mkdp#util#install"]()
    elseif name == "firenvim" then
      -- Helium isn't detected by the installer; copy the manifest by hand:
      --   cp ~/Library/Application\ Support/Google/Chrome/NativeMessagingHosts/firenvim.json \
      --      ~/Library/Application\ Support/net.imput.helium/NativeMessagingHosts/firenvim.json
      load()
      vim.fn["firenvim#install"](0)
    end
  end,
})

local gh = function(repo) return "https://github.com/" .. repo end

vim.pack.add({
  { src = gh("navarasu/onedark.nvim"), version = "v0.1.0" },
  gh("nvim-tree/nvim-web-devicons"),
  gh("nvim-lua/plenary.nvim"),

  gh("neovim/nvim-lspconfig"),
  gh("folke/lazydev.nvim"),
  { src = gh("nvim-treesitter/nvim-treesitter"), version = "main" },
  gh("nvim-treesitter/nvim-treesitter-context"),
  gh("stevearc/conform.nvim"),
  gh("lewis6991/gitsigns.nvim"),

  gh("stevearc/oil.nvim"),
  { src = gh("ThePrimeagen/harpoon"), version = "harpoon2" },
  gh("dmtrKovalenko/fff.nvim"),
  gh("folke/snacks.nvim"),

  gh("iamcco/markdown-preview.nvim"),
  gh("glacambre/firenvim"),
  gh("GustavEikaas/easy-dotnet.nvim"),
}, { confirm = false })

---------------------------------------------------------------------------
-- Colorscheme
require("onedark").setup({ style = "deep", transparent = true })
vim.cmd.colorscheme("onedark")

---------------------------------------------------------------------------
-- Treesitter: highlighting is native (autocmds.lua); this only installs parsers.
require("nvim-treesitter").install({
  "angular", "bash", "c_sharp", "comment", "css", "diff", "dockerfile", "gitcommit",
  "go", "html", "javascript", "jsdoc", "json", "lua", "luadoc", "markdown",
  "markdown_inline", "python", "query", "regex", "rust", "scss", "swift", "toml",
  "tsx", "typescript", "vim", "vimdoc", "yaml",
})

require("treesitter-context").setup({ max_lines = 3, multiline_threshold = 1 })

---------------------------------------------------------------------------
require("lazydev").setup({
  library = {
    { path = "${3rd}/luv/library", words = { "vim%.uv" } },
  },
})

---------------------------------------------------------------------------
-- Formatting (manual, <leader>nft)
require("conform").setup({
  notify_on_error = false,
  formatters_by_ft = {
    lua = { "stylua" },
    typescript = { "prettier", "eslint_d", stop_after_first = true },
    python = { "ruff_fix", "ruff_organize_imports", "ruff_format" },
    javascript = { "prettier" },
    htmlangular = { "prettier" },
    html = { "prettier" },
    json = { "prettier" },
    css = { "prettier" },
    scss = { "prettier" },
    yaml = { "prettier" },
    markdown = { "prettier" },
    swift = { "swiftformat" },
  },
})
vim.keymap.set("n", "<leader>nft", function()
  require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "Format buffer" })

---------------------------------------------------------------------------
require("gitsigns").setup({
  signs = {
    add = { text = "+" },
    change = { text = "~" },
    delete = { text = "_" },
    topdelete = { text = "‾" },
    changedelete = { text = "~" },
  },
})

---------------------------------------------------------------------------
require("oil").setup({
  use_default_keymaps = false,
  keymaps = {
    ["g?"] = "actions.show_help",
    ["<CR>"] = "actions.select",
    ["-"] = "actions.parent",
    ["_"] = "actions.open_cwd",
    ["gs"] = "actions.change_sort",
    ["g\\"] = "actions.toggle_trash",
  },
  view_options = { show_hidden = true },
})
vim.keymap.set("n", "<C-f>", "<cmd>Oil<CR>", { desc = "Oil" })

---------------------------------------------------------------------------
local harpoon = require("harpoon")
harpoon:setup()
vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end, { desc = "Harpoon add" })
vim.keymap.set("n", "<C-s>", function() harpoon:list():select(1) end)
vim.keymap.set("n", "<C-t>", function() harpoon:list():select(2) end)
vim.keymap.set("n", "<C-n>", function() harpoon:list():select(3) end)
vim.keymap.set("n", "<C-e>", function() harpoon:list():select(4) end)
vim.keymap.set("n", "<C-g>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

---------------------------------------------------------------------------
-- Pickers: fff for files, snacks.picker for everything else (+ vim.ui.select)
require("fff").setup({
  keymaps = { close = { "<C-c>", "<Esc>" } },
  preview = { line_numbers = true },
  layout = { anchor = "bottom", width = 1.0, height = 0.4, prompt_position = "bottom" },
})
vim.keymap.set("n", "<C-p>", function() require("fff").find_files() end, { desc = "Find files" })

require("snacks").setup({
  picker = {
    enabled = true,
    ui_select = true,
    layout = { preset = "ivy" },
    sources = {
      files = { hidden = true },
      grep = { hidden = true },
    },
  },
})
local picker = function(name, opts)
  return function() Snacks.picker[name](opts) end
end
vim.keymap.set("n", "<leader>sg", picker("grep"), { desc = "Search by grep" })
vim.keymap.set({ "n", "x" }, "<leader>sw", picker("grep_word"), { desc = "Search current word" })
vim.keymap.set("n", "<leader>sr", picker("resume"), { desc = "Resume last search" })
vim.keymap.set("n", "<leader>sb", picker("buffers"), { desc = "Search buffers" })
vim.keymap.set("n", "<leader>sh", picker("help"), { desc = "Search help" })
vim.keymap.set("n", "<leader>sn", picker("files", { cwd = vim.fn.stdpath("config") }),
  { desc = "Search Neovim config" })
vim.keymap.set("n", "<leader>l", picker("diagnostics_buffer"), { desc = "Buffer diagnostics" })
vim.keymap.set("n", "<leader>L", picker("diagnostics"), { desc = "Workspace diagnostics" })
vim.keymap.set("n", "<leader>fp", function()
  vim.ui.input({ prompt = "Grep > " }, function(query)
    if query and query ~= "" then Snacks.picker.grep({ search = query }) end
  end)
end, { desc = "Grep for string" })

---------------------------------------------------------------------------
vim.g.mkdp_filetypes = { "markdown" }

-- easy-dotnet: the .NET installer drops ~/.dotnet/tools into /etc/paths.d,
-- but path_helper never expands the tilde, so dotnet-easydotnet is unreachable.
local dotnet_tools = vim.fs.joinpath(vim.env.HOME, ".dotnet/tools")
if vim.uv.fs_stat(dotnet_tools) and not vim.env.PATH:find(dotnet_tools, 1, true) then
  vim.env.PATH = dotnet_tools .. ":" .. vim.env.PATH
end
require("easy-dotnet").setup()
