local M = {}

local function kebab_to_pascal(str)
  local camel = str:gsub("-(%a)", string.upper)
  return camel:sub(1, 1):upper() .. camel:sub(2)
end

function M.angular_component()
  local file = vim.api.nvim_buf_get_name(0)
  if not file:match("%.component%.ts$") then
    vim.notify("Not an Angular component file.", vim.log.levels.WARN)
    return
  end

  local name = vim.fn.fnamemodify(file, ":t:r"):gsub("%.component$", "")
  local class = kebab_to_pascal(name) .. "Component"

  vim.api.nvim_buf_set_lines(0, 0, -1, false, {
    "/**",
    " * @file " .. vim.fn.fnamemodify(file, ":t"),
    " * @author Gabriel Martins",
    " *",
    " * " .. class .. " component",
    " */",
    "",
    "import { Component } from '@angular/core';",
    "",
    "@Component({",
    "  standalone: true,",
    "  selector: 'app-" .. name .. "',",
    "  templateUrl: './" .. name .. ".component.html',",
    "})",
    "export class " .. class .. " {",
    "}",
    "",
  })
end

return M
