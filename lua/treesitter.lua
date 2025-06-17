-- ~/.config/nvim/lua/treesitter.lua
local status_ok, treesitter = pcall(require, "nvim-treesitter.configs")
if not status_ok then
  vim.notify("Plugin 'nvim-treesitter' not found for setup.")
  return
end

treesitter.setup({
  ensure_installed = { 
    "lua", 
    "vim", 
    "rust", 
    "toml", 
    "yaml", 
    "json", 
    "markdown", 
    "markdown_inline", -- For fenced code blocks in markdown
    "bash",
    "c" 
  },
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true,
  },
})

-- Configure folding using Treesitter
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevelstart = 99 -- Start with all folds open
vim.opt.foldenable = true   -- Enable folding

vim.notify('Treesitter configuration (including folding) loaded', vim.log.levels.INFO, {title = 'Nvim Plugins'})

