-- ~/.config/nvim/lua/options.lua
local opt = vim.opt
local g = vim.g
local fn = vim.fn

opt.termguicolors = true
opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.wrap = false

opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.swapfile = false
opt.backup = false
opt.undofile = true
opt.history = 1000
opt.autoread = true
opt.confirm = true

opt.hlsearch = true
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true
opt.gdefault = true

opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true

opt.updatetime = 250
opt.timeoutlen = 500
opt.ttimeoutlen = 300
opt.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal"

opt.showmode = false
opt.cmdheight = 1
opt.pumheight = 10
opt.showtabline = 2
opt.splitright = true
opt.splitbelow = true
opt.laststatus = 3

g.mapleader = " "
g.maplocalleader = [[\]]

local undodir_path = fn.stdpath('data') .. '/undodir'
if fn.isdirectory(undodir_path) == 0 then
    fn.mkdir(undodir_path, 'p')
end
opt.undodir = undodir_path

local map = vim.keymap.set
map("n", "<Esc>", "<cmd>noh<CR><Esc>", { desc = "Clear search highlight and exit mode" })
map("n", "<leader>w", "<cmd>w<CR>", { silent = true, desc = "Save file" })
map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })
map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle NvimTree file explorer" })

-- Speculative test for space to insert mode
local function safe_insert_mode()
  local success, err = pcall(function()
    -- Attempt to enter insert mode
    vim.cmd('startinsert')
    -- Alternatively, vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('i', true, false, true), 'n', false)
  end)
  if not success then
    vim.notify("Error trying to enter insert mode via space: " .. tostring(err), vim.log.levels.ERROR)
  else
    vim.notify("Entered insert mode via space (speculative test mapping).", vim.log.levels.INFO)
  end
end

-- Only map if no other mapping for <Space> exists in normal mode
-- This is a simplified check; a more robust check would iterate vim.api.nvim_get_keymap('n')
local space_maps = vim.api.nvim_get_keymap('n')['<Space>']
if space_maps == nil then
  vim.keymap.set("n", "<Space>", safe_insert_mode, { noremap = true, silent = true, desc = "TEMP: Space to Insert Mode Test" })
  vim.notify("Temporarily mapped <Space> to enter insert mode for testing.", vim.log.levels.INFO)
else
  vim.notify("Skipping temporary <Space> to insert mode mapping as existing map(s) found for <Space> in normal mode.", vim.log.levels.WARN)
end

vim.notify("Neovim general options loaded.", vim.log.levels.INFO, { title = "Nvim Config" })

