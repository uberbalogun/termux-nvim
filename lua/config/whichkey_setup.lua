-- ~/.config/nvim/lua/config/whichkey_setup.lua
local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
  vim.notify("Plugin 'which-key.nvim' not found for setup.")
  return
end

which_key.setup()

local mappings = {
  ["<leader>"] = {
    e = { "<cmd>NvimTreeToggle<CR>", "Explorer" },
    f = { name = "File" },
    p = { name = "Package" },
    s = { name = "Search" },
    l = { name = "LSP" },
    u = { name = "UI" },
    g = { name = "Git" },
  },
}

which_key.register(mappings)
