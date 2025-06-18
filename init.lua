-- ~/.config/nvim/init.lua
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.notify("Bootstrapping lazy.nvim...", vim.log.levels.INFO)
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("options")

require("lazy").setup("plugins", {
  checker = { enabled = true, notify = true },
  change_detection = { enabled = true, notify = true },
})

--vim.notify("Neovim configuration with lazy.nvim loaded!", vim.log.levels.INFO, { title = "Nvim" })
