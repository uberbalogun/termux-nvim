-- ~/.config/nvim/lua/treesitter.lua
-- nvim-treesitter (rewritten plugin, 2025+): a pure parser/query installer.
-- Highlighting, folding, and indentation are now Neovim core features
-- (see `:h treesitter-highlight`); this file installs parsers and enables
-- those features for our languages via a FileType autocommand.
local status_ok, ts = pcall(require, "nvim-treesitter")
if not status_ok then
  vim.notify("Plugin 'nvim-treesitter' not found for setup.")
  return
end

-- Install parsers for our languages (no-op if already installed).
-- Runs asynchronously, so this is safe to call at config time.
-- Guarded on the toolchain the rewrite needs (tree-sitter-cli, tar, curl,
-- C compiler) so a missing tool doesn't error on every startup.
if vim.fn.executable("tree-sitter") == 1 and vim.fn.executable("tar") == 1 then
  ts.install({
    "lua",
    "vim",
    "rust",
    "toml",
    "yaml",
    "json",
    "markdown",
    "bash", -- parser name; matches filetype "sh"
    "c",
  })
end

-- Enable treesitter features per filetype: highlighting and folds come from
-- Neovim core, indentation is provided by nvim-treesitter's queries.
-- (This mirrors the example in `:h nvim-treesitter`.)
local ts_filetypes = {
  "lua",
  "vim",
  "rust",
  "toml",
  "yaml",
  "json",
  "markdown",
  "sh",
  "bash",
  "c",
}

vim.api.nvim_create_autocmd("FileType", {
  pattern = ts_filetypes,
  callback = function()
    -- syntax highlighting (Neovim core)
    vim.treesitter.start()
    -- folding (Neovim core)
    vim.wo.foldmethod = "expr"
    vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    -- indentation (nvim-treesitter queries)
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
  desc = "Enable treesitter highlight/fold/indent",
})
