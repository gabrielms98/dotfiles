vim.filetype.add({
  extension = {
    env = "dotenv",
  },
  filename = {
    [".env"] = "dotenv",
    ["env"] = "dotenv",
    [".envrc"] = "sh",
  },
  pattern = {
    ["[jt]sconfig.*.json"] = "jsonc",
    ["%.env%.[%w_.-]+"] = "dotenv",

    -- Nvim only scans the first 40 lines for @if/*ngIf and such, so a template
    -- carrying nothing but interpolation reads as plain HTML. A template is the
    -- .html with a component beside it — in an Angular project, index.html is
    -- the only one without. Returning nil falls back to content detection.
    [".*%.component%.html"] = "htmlangular",
    [".*%.container%.html"] = "htmlangular",
    [".*%.html"] = function(path)
      if vim.fn.filereadable((path:gsub("%.html$", ".ts"))) == 1
          and vim.fs.root(path, { "angular.json", "nx.json" }) then
        return "htmlangular"
      end
    end,
  },
})
