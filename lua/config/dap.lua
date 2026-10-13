local ok_dap, dap = pcall(require, "dap")
if not ok_dap then
  return
end
local ok_dapui, dapui = pcall(require, "dapui")
local ok_nio, _ = pcall(require, "nio")

if ok_dapui then
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

local lldb_ok, lldb_ret = pcall(vim.fn.executable, "lldb-dap")
if lldb_ok and lldb_ret == 1 then
  dap.adapters.lldb = {
    type = "executable",
    command = "lldb-dap",
    name = "lldb",
  }
end

if vim.fn.executable("debugpy-adapter") == 1 then
  dap.adapters.python = {
    type = "executable",
    command = "debugpy-adapter",
  }
end

dap.configurations.c = {
  {
    name = "Launch",
    type = "lldb",
    request = "launch",
    program = function()
      return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
    end,
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
  },
}
dap.configurations.cpp = dap.configurations.c
dap.configurations.rust = dap.configurations.c

dap.configurations.python = {
  {
    type = "executable",
    request = "launch",
    name = "Debugpy (launch file)",
    program = "${file}",
    console = "integratedTerminal",
    pythonPath = function()
      local venv = vim.fn.getenv("VIRTUAL_ENV")
      if venv and venv ~= vim.NIL then
        return venv .. "/bin/python"
      end
      return vim.fn.exepath("python3") or "python3"
    end,
  },
}

vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "DAP Toggle Breakpoint" })
vim.keymap.set("n", "<leader>dB", function()
  dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, { desc = "DAP Breakpoint Condition" })
vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "DAP Continue" })
vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "DAP Step Over" })
vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "DAP Step Into" })
vim.keymap.set("n", "<leader>dr", dap.repl.open, { desc = "DAP REPL" })
vim.keymap.set("n", "<leader>dq", dap.disconnect, { desc = "DAP Disconnect" })
if ok_dapui then
  vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "DAP UI Toggle" })
end
