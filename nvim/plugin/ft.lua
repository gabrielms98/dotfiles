-- if a file is a .env or .envrc file, set the filetype to sh
vim.filetype.add({
  filename = {
    [".env"] = "sh",
    [".envrc"] = "sh",
    ["*.env"] = "sh",
    ["*.envrc"] = "sh"
  }
})

-- Nvim only scans the first 40 lines for @if/*ngIf and such, so a template
-- carrying nothing but interpolation reads as plain HTML. A template is the
-- .html with a component beside it — in an Angular project, index.html is the
-- only one without. Returning nil falls back to that content detection.
vim.filetype.add({
  pattern = {
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
