vim.keymap.set("n", "<leader>-", function()
  require("yazi").yazi()
end, { desc = "Yazi (file explorer)" })
