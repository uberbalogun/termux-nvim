-- ~/.config/nvim/lua/telescope.lua
local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
  vim.notify("Plugin 'telescope.nvim' not found for setup.")
  return
end

local actions_status_ok, actions = pcall(require, "telescope.actions")
if not actions_status_ok then
  vim.notify("Telescope actions not found. Some actions might not work.")
end

local builtin = require('telescope.builtin') 

telescope.setup({
  defaults = {
    prompt_prefix = "  ", 
    selection_caret = " ", 
    entry_prefix = "  ",
    initial_mode = "insert",
    selection_strategy = "reset",
    sorting_strategy = "ascending",
    layout_strategy = "horizontal",
    layout_config = {
      horizontal = { prompt_position = "top", preview_width = 0.55, results_width = 0.8 },
      vertical = { mirror = false },
      width = 0.87, height = 0.80, preview_cutoff = 120,
    },
    file_sorter = require("telescope.sorters").get_fuzzy_file,
    file_ignore_patterns = { "%.git/", "node_modules/", "target/", "%.lock", "%.o", "%.a", "%.out" },
    generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
    path_display = { "truncate" },
    winblend = 0,
    border = {},
    borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' }, 
    color_devicons = true,
    set_env = { ['COLORTERM'] = 'truecolor' },
    file_previewer = require("telescope.previewers").vim_buffer_cat.new,
    grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
    qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
    buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
    mappings = actions and { 
      i = {
        ["<C-n>"] = actions.move_selection_next, ["<C-p>"] = actions.move_selection_previous,
        ["<C-j>"] = actions.move_selection_next, ["<C-k>"] = actions.move_selection_previous,
        ["<C-c>"] = actions.close, ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
        ["<esc>"] = actions.close, ["<CR>"] = actions.select_default,
        ["<C-x>"] = actions.select_horizontal, ["<C-v>"] = actions.select_vertical,
        ["<C-t>"] = actions.select_tab,
        ["<Up>"] = actions.cycle_history_prev, ["<Down>"] = actions.cycle_history_next,
      },
      n = {
        ["<esc>"] = actions.close, ["<CR>"] = actions.select_default,
        ["<C-x>"] = actions.select_horizontal, ["<C-v>"] = actions.select_vertical,
        ["<C-t>"] = actions.select_tab,
        ["j"] = actions.move_selection_next, ["k"] = actions.move_selection_previous,
        ["q"] = actions.close, ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
      },
    } or {}, 
  },
  pickers = {
    find_files = {},
    buffers = { sort_mru = true, ignore_current_buffer = true, show_all_buffers = true,
      mappings = actions and { i = { ["<c-d>"] = actions.delete_buffer }, n = { ["dd"] = actions.delete_buffer } } or {},
    },
    help_tags = { theme = "ivy" },
    lsp_references = { show_line = false },
    diagnostics = { theme = "cursor" }
  },
  extensions = {
    ["ui-select"] = { require("telescope.themes").get_dropdown({}) }
  },
})

if builtin then 
  vim.keymap.set('n', '<leader>ff', function() builtin.find_files({ hidden = true, no_ignore = true }) end, { desc = "Find Files (hidden, no ignore)" })
  vim.keymap.set('n', '<leader>fr', builtin.oldfiles, { desc = "Find Recent Files" }) 
  vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = "Live Grep" })
  vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = "Find Buffers" })
  vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = "Help Tags" })
  vim.keymap.set('n', '<leader>fc', builtin.commands, { desc = "Commands" })
  vim.keymap.set('n', '<leader>fz', builtin.current_buffer_fuzzy_find, { desc = "Fuzzy Find in Buffer" })
  vim.keymap.set('n', '<leader>cm', builtin.colorscheme, { desc = "Colorscheme with preview" })
  vim.keymap.set('n', '<leader>fR', builtin.lsp_references, { desc = "LSP References" })
  vim.keymap.set('n', '<leader>fD', builtin.lsp_definitions, { desc = "LSP Definitions" })
  vim.keymap.set('n', '<leader>fI', builtin.lsp_implementations, { desc = "LSP Implementations" })
  vim.keymap.set('n', '<leader>fT', builtin.lsp_type_definitions, { desc = "LSP Type Definitions" })
  vim.keymap.set('n', '<leader>fs', builtin.lsp_document_symbols, { desc = "LSP Document Symbols" })
  vim.keymap.set('n', '<leader>fS', builtin.lsp_workspace_symbols, { desc = "LSP Workspace Symbols" })
  vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = "Workspace Diagnostics" }) 
end
vim.notify('Telescope configuration loaded', vim.log.levels.INFO, {title = 'Nvim Plugins'})

