return {
  'zbirenbaum/copilot.lua',
  dependencies = {
    "copilotlsp-nvim/copilot-lsp", -- (optional) for NES functionality
  },
  config = function()
    require('copilot').setup {
      nes = { enabled = true },
      -- Use a specific model ID for completions (optional).
      -- Run :Copilot model list to see available models for your account;
      -- :Copilot model select to pick interactively. Leave "" for server default.
      copilot_model = '',
      suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = {
          accept = '<C-l>',
          next = '<C-j>',
          prev = '<C-k>',
          dismiss = '<C-\\>',
        },
      },
      panel = {
        enabled = true,
        auto_refresh = true,
        keymap = {
          jump_prev = '[[',
          jump_next = ']]',
          accept = '<CR>',
          refresh = 'gr',
          open = '<M-CR>',
        },
        layout = { position = 'bottom', ratio = 0.4 },
      },
      -- Tune suggestion quality and count
      server_opts_overrides = {
        settings = {
          advanced = {
            -- More suggestions in the panel (default 10)
            listCount = 10,
            -- More inline suggestions to cycle through (default 3)
            inlineSuggestCount = 5,
            -- Slightly lower = more focused/predictable completions (0.0–1.0)
            temperature = 0.2,
            -- Nucleus sampling; lower = more deterministic (0.0–1.0)
            top_p = 0.95,
          },
        },
      },
    }
  end,
}
