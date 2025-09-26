-- ~/.config/nvim/lua/plugins/init.lua
return {
  {
    "akinsho/toggleterm.nvim",
    version = "*", -- Optional: ensures latest version
    cmd = { "ToggleTerm", "TermExec" }, -- Lazy-load on these commands
    keys = {
      { "<leader>t", "<cmd>ToggleTerm<cr>", desc = "Toggle Terminal" },
    },
    config = function()
      require("toggleterm").setup({
        size = 20, -- Fallback size for non-floating terminals
        open_mapping = [[<leader>t]], -- Optional: reinforces keybinding
        direction = "float",
        float_opts = {
          border = "curved", -- Options: "single", "double", "shadow", "curved"
          width = 80,
          height = 20,
        },
        shade_terminals = true, -- Optional: adds shading to terminal background
        start_in_insert = true, -- Start in insert mode
        close_on_exit = true, -- Close terminal when process exits
        shell = "fish", -- Set fish as the default shell
	})
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("config.gitsigns_setup")
    end,
  },
  {
    "mfussenegger/nvim-dap",
    event = "VeryLazy",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
    },
    config = function()
      require("config.dap_setup")
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    event = "VeryLazy",
    config = function()
      require("dapui").setup()
    end,
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    config = function()
      require("config.whichkey_setup")
    end,
  },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("colorscheme")
    end,
  },
  {
    "nvim-lua/plenary.nvim",
    lazy = true,
  },
  {
    "kyazdani42/nvim-web-devicons",
    lazy = true,
    config = function()
      local status_ok, devicons = pcall(require, "nvim-web-devicons")
      if status_ok then
        devicons.setup { default = true }
      else
        vim.notify("nvim-web-devicons not found for setup in its plugin spec.", vim.log.levels.WARN, { title = "Nvim Plugins" })
      end
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "kyazdani42/nvim-web-devicons" },
    config = function()
      require("config.lualine_config")
    end,
  },
  {
    "kyazdani42/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus", "NvimTreeFindFile", "NvimTreeClose" },
    dependencies = { "kyazdani42/nvim-web-devicons" },
    config = function()
      require("config.nvimtree_config")
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile", "VeryLazy" },
    config = function()
      require("treesitter")
    end,
  },
  {
    "hrsh7th/cmp-nvim-lsp",
    event = "BufReadPre",
    config = function()
      require("lsp")
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    lazy = false,
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "onsails/lspkind-nvim",
    },
    config = function()
      require("config.cmp_setup")
    end,
  },
  {
    "rafamadriz/friendly-snippets",
    lazy = false,
  },
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope")
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = "BufWritePre",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("formatting")
    end,
  },
  -- FittenCode AI completion
  {
    "luozhiya/fittencode.nvim",
    config = function()
      require("fittencode").setup({
        completion_mode = "source", -- Integrate with nvim-cmp
        use_default_keymaps = true, -- Use default keymaps
        keymaps = {
          inline = {
            ["<TAB>"] = "accept_all_suggestions",
            ["<C-Down>"] = "accept_line",
            ["<C-Right>"] = "accept_word",
            ["<C-Up>"] = "revoke_line",
            ["<C-Left>"] = "revoke_word",
            ["<A-\\>"] = "triggering_completion",
          },
          chat = {
            ["q"] = "close",
            ["[c"] = "goto_previous_conversation",
            ["]c"] = "goto_next_conversation",
            ["c"] = "copy_conversation",
            ["C"] = "copy_all_conversations",
            ["d"] = "delete_conversation",
            ["D"] = "delete_all_conversations",
          },
        },
        source_completion = {
          enable = true,
          engine = "cmp", -- Use nvim-cmp as the completion engine
          trigger_chars = {}, -- Default trigger characters
        },
        log = {
          level = vim.log.levels.WARN,
          max_size = 10, -- Max log file size in MB
        },
      })
      vim.opt.updatetime = 200 -- Improve performance as recommended
    end,
  },
  {
    "echasnovski/mini.icons",
    version = "*",
  },
}
