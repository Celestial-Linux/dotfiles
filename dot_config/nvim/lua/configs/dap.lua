local ok_dap, dap = pcall(require, "dap")
if not ok_dap then
  return
end

-- dap-ui setup and auto open/close
local ok_ui, dapui = pcall(require, "dapui")
if ok_ui then
  dapui.setup()
  dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
  end
  dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
  end
  dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
  end
end

-- Basic keymaps for DAP
local map = vim.keymap.set
map("n", "<F5>", function()
  dap.continue()
end, { desc = "DAP Continue" })
map("n", "<F10>", function()
  dap.step_over()
end, { desc = "DAP Step Over" })
map("n", "<F11>", function()
  dap.step_into()
end, { desc = "DAP Step Into" })
map("n", "<F12>", function()
  dap.step_out()
end, { desc = "DAP Step Out" })
map("n", "<leader>db", function()
  dap.toggle_breakpoint()
end, { desc = "DAP Toggle Breakpoint" })
map("n", "<leader>dB", function()
  dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, { desc = "DAP Conditional Breakpoint" })
map("n", "<leader>dr", function()
  dap.repl.open()
end, { desc = "DAP REPL" })
map("n", "<leader>du", function()
  if ok_ui then
    dapui.toggle()
  end
end, { desc = "DAP UI Toggle" })
