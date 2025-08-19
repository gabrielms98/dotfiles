return {
  'saghen/blink.cmp',
  -- optional: provides snippets for the snippet source
  dependencies = {
    'rafamadriz/friendly-snippets',
    {
      "L3MON4D3/LuaSnip",
      version = "2.*",
      build = (function()
        -- Build Step is needed for regex support in snippets.
        -- This step is not supported in many windows environments.
        -- Remove the below condition to re-enable on windows.
        if vim.fn.has "win32" == 1 or vim.fn.executable "make" == 0 then
          return
        end
        return "make install_jsregexp"
      end)(),
      dependencies = {},
      opts = {}
    },
    "folke/lazydev.nvim"
  },

  -- use a release tag to download pre-built binaries
  version = '1.*',
  -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
  -- build = 'cargo build --release',
  -- If you use nix, you can build from source using latest nightly rust with:
  -- build = 'nix run .#build-plugin',

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    keymap = { preset = 'default' },

    appearance = {
      nerd_font_variant = 'mono'
    },

    -- (Default) Only show the documentation popup when manually triggered
    completion = {
      documentation = { auto_show = true },
      accept = {
        auto_brackets = { enabled = false }
      },
      menu = {
        draw = {
          columns = { 
            { "label", "label_description", gap = 1 },
            { "kind_icon", "kind", gap = 1},
            { "source_name" },
          }
        }
      }
    },

    -- Default list of enabled providers defined so that you can extend it
    -- elsewhere in your config, without redefining it, due to `opts_extend`
    sources = {
      default = { 'lsp', 'path', 'snippets', 'lazydev' },
      providers = {
        lazydev = {module = "lazydev.integrations.blink", score_offset = 100}
      }
    },
    snippets = { preset = "luasnip" },

    -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
    -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
    -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
    --
    -- See the fuzzy documentation for more information
    fuzzy = { implementation = "prefer_rust_with_warning" },
    signature = {enabled = true}
  },
  opts_extend = { "sources.default" },
}
