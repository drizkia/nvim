local augroup = vim.api.nvim_create_augroup("UserConfig", { clear = true })

-- C/C++ kernel style
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = { "c", "cpp" },
  callback = function()
    vim.opt_local.expandtab = false
    vim.opt_local.tabstop = 8
    vim.opt_local.shiftwidth = 8
    vim.opt_local.softtabstop = 8
    vim.opt_local.cindent = true
    vim.opt_local.cinoptions = ":0,l1,g0,(0,Ws,N-s,E-s"
  end,
})

-- Python Indentation (4 spaces)
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = "python",
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
  end,
})

-- Rust (4 spaces, expandtab)
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = "rust",
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
  end,
})

-- Shell (tabs for kernel style)
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = { "sh", "bash" },
  callback = function()
    vim.opt_local.expandtab = false
    vim.opt_local.tabstop = 8
    vim.opt_local.shiftwidth = 8
    vim.opt_local.softtabstop = 8
  end,
})

-- Lua Indentation (2 spaces)
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = "lua",
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
  end,
})

-- JSON/YAML/TOML/Markdown (2 spaces)
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = { "json", "jsonc", "yaml", "toml", "markdown" },
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
  end,
})

-- Entering a terminal window starts Terminal-mode, so typing just works.
vim.api.nvim_create_autocmd("BufEnter", {
  group = augroup,
  pattern = "term://*",
  callback = function()
    vim.cmd("startinsert")
  end,
  desc = "Entering a terminal starts Terminal-mode",
})
