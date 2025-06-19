-- ~/.config/nvim/lua/cmp.lua
local cmp_status_ok, cmp = pcall(require, "nvim-cmp")
if not cmp_status_ok then
  vim.notify("Plugin 'nvim-cmp' not found for setup.")
  return
end

local luasnip_status_ok, luasnip = pcall(require, "luasnip")
if not luasnip_status_ok then
  vim.notify("Plugin 'luasnip' not found. Snippet functionality will be limited.")
end

local lspkind_status_ok, lspkind = pcall(require, "lspkind")
if not lspkind_status_ok then
  vim.notify("Plugin 'lspkind-nvim' not found. Completion items will not have icons.")
end

local has_words_before = function()
  if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

cmp.setup({
  enabled = function()
    local success, result = pcall(function()
      local context = require 'cmp.config.context'
      if vim.api.nvim_get_mode().mode == 'c' then
          return true
      else
          return not context.in_treesitter_capture("comment")
             and not context.in_syntax_group("Comment")
      end
    end)
    if not success then
      vim.notify("Error in nvim-cmp enabled function: " .. tostring(result), vim.log.levels.ERROR)
      return true -- Default to enabled, or false if preferred to disable cmp on error
    end
    return result
  end,
  snippet = {
    expand = function(args)
      if luasnip then
        local success, err = pcall(luasnip.lsp_expand, args.body)
        if not success then
          vim.notify("Error in nvim-cmp snippet expansion: " .. tostring(err), vim.log.levels.ERROR)
          -- Fallback to feedkeys if luasnip fails, or handle error differently
          vim.fn.feedkeys(args.body, 'i')
        end
      else
        vim.fn.feedkeys(args.body, 'i') 
      end
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), 
    ["<Tab>"] = cmp.mapping(function(fallback)
      local success, err = pcall(function()
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip and luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        elseif has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end)
      if not success then
        vim.notify("Error in nvim-cmp <Tab> mapping: " .. tostring(err), vim.log.levels.ERROR)
        fallback() -- Ensure fallback is called if an error occurs
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip and luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer', keyword_length = 3 },
    { name = 'path' },
  }),
  formatting = {
    fields = {'abbr', 'kind', 'menu'},
    format = lspkind_status_ok and lspkind.cmp_format({
      mode = 'symbol_text', 
      maxwidth = 50,
      ellipsis_char = '...',
      symbol_map = { 
        Text = "", Method = "", Function = "", Constructor = "",
        Field = "", Variable = "", Class = "ﴯ", Interface = "",
        Module = "", Property = "ﰠ", Unit = "", Value = "",
        Enum = "", Keyword = "", Snippet = "", Color = "",
        File = "", Reference = "", Folder = "", EnumMember = "",
        Constant = "", Struct = "", Event = "", Operator = "",
        TypeParameter = ""
      }
    }) or function(entry, vim_item) 
      vim_item.kind = string.format('%s', vim_item.kind) 
      return vim_item
    end,
  },
  experimental = {
    ghost_text = { hl_group = 'Comment' } 
  },
  window = {
     completion = cmp.config.window.bordered(),
     documentation = cmp.config.window.bordered(),
  },
  confirm_opts = {
    behavior = cmp.ConfirmBehavior.Replace,
    select = false,
  },
})

cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = { { name = 'buffer' } }
})

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({ { name = 'path' } }, { { name = 'cmdline', keyword_length = 3 } })
})

if luasnip_status_ok then
  -- Consider adding friendly-snippets or other snippet packs here
  require("luasnip.loaders.from_vscode").lazy_load()
end
