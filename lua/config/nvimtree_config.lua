-- ~/.config/nvim/lua/config/nvimtree_config.lua
local nvim_tree_status_ok, nvim_tree = pcall(require, "nvim-tree")
if not nvim_tree_status_ok then
  vim.notify("Plugin 'nvim-tree.lua' not found for UI setup.")
  return
end

nvim_tree.setup({
  auto_reload_on_write = true,
  disable_netrw = true,
  hijack_netrw = true,
  open_on_setup = false,
  open_on_tab = false,
  hijack_cursor = false,
  update_cwd = true,
  update_focused_file = {
    enable = true,
    update_cwd = true, 
    ignore_list = {},
  },
  diagnostics = {
    enable = true,
    show_on_dirs = true, 
    icons = {
      hint = "", info = "", warning = "", error = "",
    },
  },
  git = {
    enable = true,
    ignore = false, 
    timeout = 400,
  },
  view = {
    width = 35, 
    side = 'left',
    preserve_window_proportions = true,
    number = false,
    relativenumber = false,
    signcolumn = "yes",
    mappings = {
      custom_only = false,
      list = {
        { key = {"<CR>", "o", "<2-LeftMouse>"}, action = "edit" },
        { key = "<C-e>", action = "edit_in_place" }, 
        { key = "O", action = "edit_no_picker" }, 
        { key = "<C-v>", action = "vsplit" },
        { key = "<C-s>", action = "split" }, 
        { key = "<C-t>", action = "tabnew" },
        { key = "h", action = "parent_node" }, 
        { key = "l", action = "child_node" }, 
        { key = ".", action = "toggle_hidden_ignored" }, 
        { key = "R", action = "refresh" },
        { key = "a", action = "create" },
        { key = "d", action = "remove" },
        { key = "r", action = "rename" },
        { key = "c", action = "copy" },
        { key = "x", action = "move" },
        { key = "y", action = "copy_name" },
        { key = "Y", action = "copy_path" },
        { key = "gy", action = "copy_absolute_path" },
        { key = "[c", action = "prev_git_item" },
        { key = "]c", action = "next_git_item" },
        { key = "-", action = "dir_up" }, 
        { key = "q", action = "close" },
        { key = "?", action = "toggle_help" },
      },
    },
  },
  renderer = {
    group_empty = true,
    highlight_git = true,
    highlight_opened_files = "all", 
    root_folder_modifier = ":~", 
    indent_markers = {
      enable = true,
      icons = {
        corner = "└ ", edge = "│ ", item = "│ ", bottom = "─ ", none = "  ",
      },
    },
    icons = {
      webdev_colors = true, 
      git_placement = "before", 
      show = {
        file = true, folder = true, folder_arrow = true, git = true,
      },
      glyphs = {
        default = "", symlink = "",
        folder = {
          arrow_closed = "", arrow_open = "",
          default = "", open = "",
          empty = "", empty_open = "",
          symlink = "", symlink_open = "",
        },
        git = {
          unstaged = "M", staged = "A", unmerged = "U",
          renamed = "R", untracked = "?", deleted = "D", ignored = "I",
        },
      },
    },
  },
  filters = {
    dotfiles = false,
    custom = { ".DS_Store", ".git", "node_modules", ".cache", "target" }, 
    exclude = {},
  },
  trash = {
    cmd = "trash-put", 
    require_confirm = true,
  },
})

vim.notify('NvimTree configuration loaded', vim.log.levels.INFO, {title = 'Nvim Plugins'})

