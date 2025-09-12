-- ~/.config/nvim/lua/lsp.lua
vim.api.nvim_create_augroup("LspFormat", { clear = true })
local M = {} -- Module to hold settings to be returned/used by other modules

local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

vim.diagnostic.config({
    virtual_text = {
        prefix = '●', 
        spacing = 4,
        source = "if_many", 
    },
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
        source = "always", 
        border = "rounded",
        focusable = false,
        style = "minimal",
    }
})

-- Global mappings for LSP actions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, { desc = "Open diagnostics float" })
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, { desc = "Open diagnostics in loclist" })

-- Inlay hints toggle function
local inlay_hints_enabled = true
function M.toggle_inlay_hints()
  inlay_hints_enabled = not inlay_hints_enabled
  for _, client in ipairs(vim.lsp.get_active_clients()) do
    if client.supports_method("textDocument/inlayHint") then
      if inlay_hints_enabled then
        vim.lsp.inlay_hint.enable(true, { bufnr = 0 })
      else
        vim.lsp.inlay_hint.enable(false, { bufnr = 0 })
      end
    end
  end
  vim.notify("Inlay hints " .. (inlay_hints_enabled and "enabled" or "disabled"))
end

-- Keymap for toggling inlay hints
vim.keymap.set('n', '<space>y', M.toggle_inlay_hints, { desc = "Toggle Inlay Hints" })

M.on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  local map = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true, buffer = bufnr, desc = desc })
  end

  map('n', 'gD', vim.lsp.buf.declaration, "Go to Declaration")
  map('n', 'gd', vim.lsp.buf.definition, "Go to Definition")
  map('n', 'K', vim.lsp.buf.hover, "Hover Documentation")
  map('n', 'gi', vim.lsp.buf.implementation, "Go to Implementation")
  map('n', '<C-k>', vim.lsp.buf.signature_help, "Signature Help")
  map('n', '<space>wa', vim.lsp.buf.add_workspace_folder, "Add Workspace Folder")
  map('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, "Remove Workspace Folder")
  map('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, "List Workspace Folders")
  map('n', '<space>D', vim.lsp.buf.type_definition, "Type Definition")
  map('n', '<space>rn', vim.lsp.buf.rename, "Rename")
  map('n', '<space>ca', vim.lsp.buf.code_action, "Code Action")
  map('n', 'gr', vim.lsp.buf.references, "Go to References")
  
  if client:supports_method("textDocument/formatting") then
    vim.api.nvim_clear_autocmds({ group = "LspFormat", buffer = bufnr })
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = "LspFormat",
      buffer = bufnr,
      callback = function()
        local view = vim.fn.winsaveview()
        vim.lsp.buf.format({ bufnr = bufnr, async = false, timeout_ms = 2000 })
        vim.fn.winrestview(view)
      end,
      desc = "Format file before saving (LSP)",
    })
  end

  if client.name == "rust_analyzer" then
    map('n', '<leader>rr', '<Cmd>RustRunnables<CR>', "Rust Runnables")
    map('n', '<leader>re', '<Cmd>RustExpandMacro<CR>', "Rust Expand Macro")
  end
end

M.capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Set highlight group for inlay hints to appear as gray virtual text
vim.api.nvim_set_hl(0, "LspInlayHint", { fg = "#666666", italic = true })

local lspconfig = require('lspconfig')

lspconfig.rust_analyzer.setup {
  on_attach = M.on_attach,
  capabilities = M.capabilities,
  settings = {
    ["rust-analyzer"] = {
      cargo = {
        allFeatures = true,
        loadOutDirsFromCheck = true,
        runBuildScripts = true,
      },
      procMacro = {
        enable = true,
      },
      checkOnSave = true,
      check = {
        command = "clippy",
      },
      inlayHints = {
        typeHints = { enable = inlay_hints_enabled },
        closureReturnTypeHints = { enable = inlay_hints_enabled and "with_block" or false },
        bindingModeHints = { enable = inlay_hints_enabled },
        chainingHints = { enable = inlay_hints_enabled },
        parameterHints = { enable = inlay_hints_enabled },
        maxLength = 35,
        renderColons = true,
      }
    }
  }
}

return M
