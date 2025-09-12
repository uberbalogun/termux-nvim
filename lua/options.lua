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
opt.wrap = true
opt.foldmethod = 'expr'
opt.foldexpr = 'nvim_treesitter#foldexpr()'
opt.foldenable = true
vim.keymap.set('n', '<leader>f', function()
  if vim.opt.foldenable:get() then
    vim.opt.foldenable = false
    vim.notify('Folding disabled', vim.log.levels.INFO, {title = 'Options'})
  else
    vim.opt.foldenable = true
    vim.notify('Folding enabled', vim.log.levels.INFO, {title = 'Options'})
  end
end, { desc = 'Toggle folding' })

vim.keymap.set('n', '<leader>v', function()
  if vim.opt.wrap:get() then
    vim.opt.wrap = false
    vim.notify('Word wrap disabled', vim.log.levels.INFO, {title = 'Options'})
  else
    vim.opt.wrap = true
    vim.notify('Word wrap enabled', vim.log.levels.INFO, {title = 'Options'})
  end
end, { desc = 'Toggle word wrap' })

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
vim.opt.completeopt = { "menu", "menuone", "noselect" }

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

vim.keymap.set('n', '<Space>a', 'i', { noremap = true, silent = true, desc = "Enter Insert Mode" })
