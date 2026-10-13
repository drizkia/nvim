require("todo-comments").setup({
  signs = true,
  sign_priority = 8,
  keywords = {
    FIX = {
      icon = "🚧",
      color = "error",
      alt = { "FIXME", "BUG", "FIXIT", "ISSUE" },
    },
    TODO = { icon = "✅", color = "info" },
    HACK = { icon = "⚡", color = "warning" },
    WARN = { icon = "⚠", color = "warning", alt = { "WARNING", "XXX" } },
    PERF = { icon = "📈", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
    NOTE = { icon = "📝", color = "hint", alt = { "INFO" } },
    TEST = { icon = "🧪", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
  },
  colors = {
    error = { "DiagnosticError", "ErrorMsg", "#DC2626" },
    warning = { "DiagnosticWarn", "WarningMsg", "#FBBF24" },
    info = { "DiagnosticInfo", "#2563EB" },
    hint = { "DiagnosticHint", "#10B981" },
    default = { "Identifier", "#7C3AED" },
    test = { "Identifier", "#FF00FF" },
  },
})

vim.keymap.set("n", "]t", function()
  require("todo-comments").jump_next()
end, { desc = "Next todo comment" })

vim.keymap.set("n", "[t", function()
  require("todo-comments").jump_prev()
end, { desc = "Previous todo comment" })

vim.keymap.set("n", "<leader>xt", "<CMD>Trouble todo<CR>", { desc = "Todo (Trouble)" })
vim.keymap.set("n", "<leader>xT", '<CMD>Trouble todo filter = {tag = {TODO,FIX,FIXME}}<CR>',
  { desc = "Todo/Fix/Fixme (Trouble)" })
