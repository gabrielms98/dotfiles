function _G.AngularComponentSnippet()
  local utils = require("config.utils")
  local bufnr = vim.api.nvim_get_current_buf()
  local file_name = vim.api.nvim_buf_get_name(bufnr)

  if not file_name or not file_name:match("%.component.ts$") then
    print("Not an Angular component file.")
    return
  end

  local component_name = vim.fn.fnamemodify(file_name, ":t:r"):gsub("%.component$", "")
  local selector_name = "app-" .. component_name

  local camel_case_name = utils.kebab_case_to_camel_case(component_name)
  local pascal_case_name = camel_case_name:sub(1, 1):upper() .. camel_case_name:sub(2)
  local class_name = pascal_case_name .. "Component"

  local template = {
    "/**",
    " * @file " .. vim.fn.fnamemodify(file_name, ":t"),
    " * @author Gabriel Martins",
    " *",
    " * " .. class_name .. " component",
    " */",
    "",
    "import { Component } from '@angular/core';",
    "",
    "@Component({",
    "  standalone: true,",
    "  selector: '" .. selector_name .. "',",
    "  templateUrl: './" .. component_name .. ".component.html',",
    "})",
    "export class " .. class_name .. " {",
    "}",
    "",
  }

  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, template)
end

