-- ~/.config/nvim/lua/formatting.lua
local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
  vim.notify("Plugin 'none-ls.nvim' not found for formatting setup.")
  return
end

local b = null_ls.builtins

local sources = {
  b.formatting.stylua.with({
    extra_args = { "--config-path", vim.fn.stdpath("config") .. "/stylua.toml" }, 
  }),
  require("none-ls-luacheck.diagnostics.luacheck").with({
    extra_args = {"--globals", "vim", "_G"},
  }),
  b.formatting.shfmt,
  require("none-ls-shellcheck.diagnostics"),
  b.formatting.prettier.with({ 
    filetypes = {"markdown", "json", "yaml", "html", "css", "javascript", "typescript"},
    prefer_local = "node_modules/.bin", 
  }),
}

local on_attach = function(client, bufnr)
  if client.supports_method("textDocument/formatting") then
    vim.api.nvim_clear_autocmds({ group = "NullLsFormat", buffer = bufnr })
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = "NullLsFormat",
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format({
          bufnr = bufnr,
          filter = function(c) return c.name == "null-ls" end,
          async = false, 
          timeout_ms = 5000, 
        })
      end,
      desc = "Format file with null-ls before saving",
    })
  end

  if client.supports_method("textDocument/rangeFormatting") then
    vim.keymap.set("x", "<leader>lf", function()
        vim.lsp.buf.format({ bufnr = bufnr, filter = function(c) return c.name == "null-ls" end })
    end, { buffer = bufnr, noremap = true, silent = true, desc = "Format selection (null-ls)" })
  end
end

null_ls.setup({
  debug = false, 
  sources = sources,
  on_attach = on_attach,
  root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".git", "nvim/.git", ".hg", ".svn"),
})
