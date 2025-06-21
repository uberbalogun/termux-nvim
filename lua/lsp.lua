-- ~/.config/nvim/lua/lsp.lua
require('lspconfig').rust_analyzer.setup {                   cmd = { "rustup", "run", "stable", "rust-analyzer" },      settings = {
    ["rust-analyzer"] = {                                        checkOnSave = {
        command = "clippy",
      },
    },
  },
}
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

-- Global mappings for LSP actions (can be moved to a keymappings.lua later)
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, { desc = "Open diagnostics float" })
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, { desc = "Open diagnostics in loclist" })


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

  if client.supports_method("textDocument/formatting") then
    vim.api.nvim_clear_autocmds({ group = "LspFormat", buffer = bufnr })
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = "LspFormat",
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format({ bufnr = bufnr, async = false, timeout_ms = 2000 })
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

return M
