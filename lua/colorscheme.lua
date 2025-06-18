-- ~/.config/nvim/lua/colorscheme.lua
local status_ok, tokyonight = pcall(require, "tokyonight")
if not status_ok then
  vim.notify("Plugin 'tokyonight' not found for colorscheme setup.")
  return
end

tokyonight.setup({
  style = "storm", -- "storm", "night", "day"
  transparent = false, 
  terminal_colors = true,
  styles = {
    comments = { italic = true },
    keywords = { italic = true },
    sidebars = "dark", 
    floats = "dark", 
  },
})

vim.cmd [[colorscheme tokyonight]]
--vim.notify('Tokyonight colorscheme applied', vim.log.levels.INFO, {title = 'Nvim Plugins'})
