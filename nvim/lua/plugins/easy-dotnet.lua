return {
  "GustavEikaas/easy-dotnet.nvim",
  dependencies = { "nvim-lua/plenary.nvim", 'folke/snacks.nvim', },
  config = function()
    -- The .NET installer drops `~/.dotnet/tools` into /etc/paths.d/dotnet-cli-tools,
    -- but path_helper never expands the tilde, so the entry is dead and
    -- `dotnet-easydotnet` — the binary this plugin spawns Roslyn with — is
    -- unreachable. Prepend the real path before setup() registers the cmd.
    local tools = vim.fs.joinpath(vim.env.HOME, ".dotnet/tools")
    if vim.uv.fs_stat(tools) and not vim.env.PATH:find(tools, 1, true) then
      vim.env.PATH = tools .. ":" .. vim.env.PATH
    end

    require("easy-dotnet").setup()
  end
}
