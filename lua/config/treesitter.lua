local ok_ts, ts = pcall(require, "nvim-treesitter")
if ok_ts then
  local parsers = {
    "c",
    "cpp",
    "python",
    "rust",
    "lua",
    "vim",
    "vimdoc",
    "query",
    "markdown",
    "markdown_inline",
    "json",
    "yaml",
    "toml",
    "bash",
    "make",
    "cmake",
    "diff",
    "git_config",
    "git_rebase",
    "gitattributes",
    "gitcommit",
    "gitignore",
    "asm",
    "devicetree",
    "kconfig",
  }
  pcall(ts.install, parsers)
end

local augroup = vim.api.nvim_create_augroup("TSStart", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = {
    "c",
    "cpp",
    "python",
    "rust",
    "lua",
    "vim",
    "vimdoc",
    "markdown",
    "json",
    "jsonc",
    "yaml",
    "toml",
    "bash",
    "sh",
    "make",
    "cmake",
    "devicetree",
    "dts",
    "kconfig",
  },
  callback = function(args)
    local bufnr = args.buf
    pcall(vim.treesitter.start, bufnr)
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = { "c", "cpp" },
  callback = function()
    if vim.fn.exists("*nvim_treesitter#indentexpr") == 0 then
      vim.bo.indentexpr = ""
    end
  end,
})
