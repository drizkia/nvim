local ok, lint = pcall(require, "lint")
if not ok then
  return
end

lint.linters_by_ft = {
  sh = { "shellcheck" },
  bash = { "shellcheck" },
  python = { "ruff" },
}

vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "InsertLeave" }, {
  group = vim.api.nvim_create_augroup("Lint", { clear = true }),
  callback = function()
    lint.try_lint()
  end,
})
