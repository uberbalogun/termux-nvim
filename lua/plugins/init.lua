-- ~/.config/nvim/lua/plugins/init.lua
return {
  {
    "folke/tokyonight.nvim",
    lazy = false, priority = 1000,
    config = function() require("colorscheme") end,
  },
  { "nvim-lua/plenary.nvim", lazy = true },
  { 
    "kyazdani42/nvim-web-devicons", lazy = true,
    config = function() 
      local status_ok, devicons = pcall(require, "nvim-web-devicons")
      if status_ok then
        devicons.setup{ default = true }
      else
        vim.notify('nvim-web-devicons not found for setup in its plugin spec.', vim.log.levels.WARN, {title = 'Nvim Plugins'})
      end
    end,
  },
  {
    "nvim-lualine/lualine.nvim", event = "VeryLazy",
    dependencies = { "kyazdani42/nvim-web-devicons" },
    config = function() require("config.lualine_config") end,
  },
  {
    "kyazdani42/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus", "NvimTreeFindFile", "NvimTreeClose" },
    dependencies = { "kyazdani42/nvim-web-devicons" },
    config = function() require("config.nvimtree_config") end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate", event = { "BufReadPost", "BufNewFile", "VeryLazy" },
    config = function() require("treesitter") end,
  },
  {
    "neovim/nvim-lspconfig", event = "BufReadPre",
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
    config = function() require("lsp") end,
  },
  {
    "hrsh7th/nvim-cmp",
    lazy = false,
    dependencies = {
      "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer", "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline", "L3MON4D3/LuaSnip", "saadparwaiz1/cmp_luasnip",
      "onsails/lspkind-nvim",
    },
    config = function() require("config.cmp_setup") end,
  },
  {
    "rafamadriz/friendly-snippets",
    lazy = false,
  },
  {
    "nvim-telescope/telescope.nvim", cmd = "Telescope",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function() require("telescope") end,
  },
  {
    "nvimtools/none-ls.nvim", event = "BufWritePre",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "gbprod/none-ls-luacheck.nvim",
      "gbprod/none-ls-shellcheck.nvim",
      "nvimtools/none-ls-extras.nvim",
    },
    config = function() require("formatting") end,
  },
}
