require("conform").setup({
  formatters_by_ft = {
    c = { "clang_format" },
    cpp = { "clang_format" },
    python = { "ruff_format", "ruff_organize_imports" },
    rust = { "rustfmt" },
    lua = { "stylua" },
    json = { "prettier" },
    jsonc = { "prettier" },
    yaml = { "prettier" },
    markdown = { "prettier" },
    bash = { "shfmt" },
    sh = { "shfmt" },
  },
  format_on_save = {
    timeout_ms = 500,
    lsp_format = "fallback",
  },
  formatters = {
    clang_format = {
      prepend_args = { "--style=Linux" },
    },
    stylua = {
      -- This forces StyLua to use 2 spaces, perfectly matching your autocmd
      prepend_args = { "--indent-type", "Spaces", "--indent-width", "2" },
    },
  },
})
