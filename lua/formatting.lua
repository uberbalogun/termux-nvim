-- ~/.config/nvim/lua/formatting.lua
-- nvimtools/none-ls.nvim (the maintained fork of null-ls.nvim) keeps the
-- original `null-ls` module name and API unchanged.
local null_ls = require("null-ls")
local h = require("null-ls.helpers")
local methods = require("null-ls.methods")

local b = null_ls.builtins

local DIAGNOSTICS = methods.internal.DIAGNOSTICS
local FORMATTING = methods.internal.FORMATTING

-- The fork dropped several builtins (commit "DROPPING UNMAINTAINED BUILTINS #77").
-- Register them manually using the same definitions the fork used to ship.

local taplo = h.make_builtin({
  name = "taplo",
  meta = {
    url = "https://taplo.tamasfe.dev/",
    description = "A versatile, feature-rich TOML toolkit.",
  },
  method = FORMATTING,
  filetypes = { "toml" },
  can_run = function() return vim.fn.executable("taplo") == 1 end,
  generator_opts = {
    command = "taplo",
    args = { "format", "-" }, -- `-` reads TOML from stdin
    to_stdin = true,
  },
  factory = h.formatter_factory,
})

local luacheck = h.make_builtin({
  name = "luacheck",
  meta = {
    url = "https://github.com/lunarmodules/luacheck",
    description = "A tool for linting and static analysis of Lua code.",
  },
  method = DIAGNOSTICS,
  filetypes = { "lua" },
  can_run = function() return vim.fn.executable("luacheck") == 1 end,
  generator_opts = {
    command = "luacheck",
    to_stdin = true,
    from_stderr = true,
    args = {
      "--formatter",
      "plain",
      "--codes",
      "--ranges",
      "--filename",
      "$FILENAME",
      "-",
    },
    format = "line",
    on_output = h.diagnostics.from_pattern(
      [[:(%d+):(%d+)-(%d+): %((%a)(%d+)%) (.*)]],
      { "row", "col", "end_col", "severity", "code", "message" },
      {
        severities = {
          E = h.diagnostics.severities["error"],
          W = h.diagnostics.severities["warning"],
        },
        offsets = { end_col = 1 },
      }
    ),
  },
  factory = h.generator_factory,
})

local shellcheck = h.make_builtin({
  name = "shellcheck",
  meta = {
    url = "https://www.shellcheck.net/",
    description = "A shell script static analysis tool.",
  },
  method = DIAGNOSTICS,
  filetypes = { "sh" },
  can_run = function() return vim.fn.executable("shellcheck") == 1 end,
  generator_opts = {
    command = "shellcheck",
    args = { "--format", "json1", "--source-path=$DIRNAME", "--external-sources", "-" },
    to_stdin = true,
    format = "json",
    check_exit_code = function(code)
      return code <= 1
    end,
    on_output = function(params)
      local parser = h.diagnostics.from_json({
        attributes = { code = "code" },
        severities = {
          info = h.diagnostics.severities["information"],
          style = h.diagnostics.severities["hint"],
        },
      })

      return parser({ output = params.output.comments })
    end,
  },
  factory = h.generator_factory,
})

local stylua_config = vim.fn.stdpath("config") .. "/stylua.toml"

local sources = {
  b.formatting.stylua.with(
    vim.fn.filereadable(stylua_config) == 1
        and { extra_args = { "--config-path", stylua_config } }
      or {}
  ),
  luacheck.with({
    extra_args = { "--globals", "vim", "_G" },
  }),
  b.formatting.shfmt,
  shellcheck,
  b.formatting.prettier.with({
    filetypes = { "markdown", "json", "yaml", "html", "css", "javascript", "typescript" },
    prefer_local = "node_modules/.bin",
  }),
  taplo,
}

local on_attach = function(client, bufnr)
  if client.server_capabilities.documentFormattingProvider then
    -- create (or clear) the group first: nvim_clear_autocmds errors on a
    -- group that doesn't exist yet, so never pass a bare name to it
    local augroup = vim.api.nvim_create_augroup("NullLsFormat", { clear = true })
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = augroup,
      buffer = bufnr,
      callback = function()
        local view = vim.fn.winsaveview()
        vim.lsp.buf.format({
          bufnr = bufnr,
          filter = function(c) return c.name == "null-ls" end,
          async = false,
          timeout_ms = 5000,
        })
        vim.fn.winrestview(view)
      end,
      desc = "Format file with null-ls before saving",
    })
  end

  if client.server_capabilities.documentRangeFormattingProvider then
    vim.keymap.set("x", "<leader>lf", function()
      vim.lsp.buf.format({ bufnr = bufnr, filter = function(c) return c.name == "null-ls" end })
    end, { buffer = bufnr, noremap = true, silent = true, desc = "Format selection (null-ls)" })
  end
end

null_ls.setup({
  debug = false,
  sources = sources,
  on_attach = on_attach,
  root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".git", "nvim/.git", ".hg", ".svn"),
})
