-- ~/.config/nvim/lua/rust.lua
local rust_tools_status_ok, rust_tools = pcall(require, "rust-tools")
if not rust_tools_status_ok then
  vim.notify("Plugin 'rust-tools.nvim' not found for Rust setup.")
  return
end

local lsp_settings = require("lsp") -- Get on_attach and capabilities from lsp.lua

local opts = {
  tools = { 
    autoSetHints = true,
    hover_actions = {
      border = {
        { "╭", "FloatBorder" }, {"─", "FloatBorder" }, { "╮", "FloatBorder" },
        { "│", "FloatBorder" },                               { "│", "FloatBorder" },
        { "╰", "FloatBorder" }, {"─", "FloatBorder" }, { "╯", "FloatBorder" },
      },
      auto_focus = true,
    },
    inlay_hints = {
      auto = true, 
      show_parameter_hints = true,
      parameter_hints_prefix = "燈 ", 
      other_hints_prefix = "=> ",
      only_current_line = false, 
    },
  },
  server = {
    on_attach = lsp_settings.on_attach,
    capabilities = lsp_settings.capabilities,
    settings = {
      ["rust-analyzer"] = {
        checkOnSave = true, -- Changed to boolean
        cargo = {
          allFeatures = true,
          loadOutDirsFromCheck = true,
          runBuildScripts = true,
        },
        procMacro = {
          enable = true,
        },
      },
    },
  },
}

rust_tools.setup(opts)

