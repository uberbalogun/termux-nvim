-- ~/.config/nvim/lua/config/dap_setup.lua
local status_ok, dap = pcall(require, "dap")
if not status_ok then
  vim.notify("Plugin 'nvim-dap' not found for setup.")
  return
end

local dap_ui_status_ok, dapui = pcall(require, "dapui")
if not dap_ui_status_ok then
  vim.notify("Plugin 'nvim-dap-ui' not found for setup.")
  return
end

local dap_vt_status_ok, dap_vt = pcall(require, "nvim-dap-virtual-text")
if not dap_vt_status_ok then
  vim.notify("Plugin 'nvim-dap-virtual-text' not found for setup.")
  return
end

dapui.setup()
dap_vt.setup()

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

vim.keymap.set("n", "<leader>dc", "<cmd>lua require('dap').continue()<CR>", { desc = "DAP: Continue" })
vim.keymap.set("n", "<leader>do", "<cmd>lua require('dap').step_over()<CR>", { desc = "DAP: Step Over" })
vim.keymap.set("n", "<leader>di", "<cmd>lua require('dap').step_into()<CR>", { desc = "DAP: Step Into" })
vim.keymap.set("n", "<leader>du", "<cmd>lua require('dap').step_out()<CR>", { desc = "DAP: Step Out" })
vim.keymap.set("n", "<leader>db", "<cmd>lua require('dap').toggle_breakpoint()<CR>", { desc = "DAP: Toggle Breakpoint" })
vim.keymap.set("n", "<leader>dB", "<cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>", { desc = "DAP: Set Conditional Breakpoint" })
vim.keymap.set("n", "<leader>dr", "<cmd>lua require('dap').repl.open()<CR>", { desc = "DAP: Open REPL" })
vim.keymap.set("n", "<leader>dl", "<cmd>lua require('dap').run_last()<CR>", { desc = "DAP: Run Last" })
