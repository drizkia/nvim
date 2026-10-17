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

-- A session file fires SessionLoadPre before it opens any buffer and
-- SessionLoadPost after it finishes -- whoever sources it: our session.lua,
-- :restart (which restores the session itself), ZR, or a plain :source.
-- Any term:// buffer opened in between must not steal the mode via
-- 'startinsert', so bracket the whole restore with this flag. The BufEnter
-- guard below honours it. Without this, :restart/ZR drop you into insert
-- mode on a file buffer.
vim.api.nvim_create_autocmd("SessionLoadPre", {
  group = augroup,
  callback = function()
    vim.g.session_restoring = true
    -- Failsafe: if a session file errors before its 'doautoall SessionLoadPost'
    -- line, the source aborts and SessionLoadPost never fires, which would
    -- leave this flag stuck (terminals stop auto-startinsert until restart).
    -- Deferred callbacks can't run during a synchronous :source, so this only
    -- fires after the restore has finished -- clearing a genuinely stuck flag.
    vim.defer_fn(function()
      if vim.g.session_restoring then
        vim.g.session_restoring = nil
      end
    end, 1000)
  end,
  desc = "Mark the start of a session restore",
})
vim.api.nvim_create_autocmd("SessionLoadPost", {
  group = augroup,
  callback = function()
    vim.g.session_restoring = nil
  end,
  desc = "Mark the end of a session restore",
})

-- Entering a terminal window starts Terminal-mode, so typing just works.
vim.api.nvim_create_autocmd("BufEnter", {
  group = augroup,
  pattern = "term://*",
  callback = function()
    -- Don't hijack the mode while a session is being sourced: the pending
    -- 'startinsert' would land on whichever window the restore finishes on.
    if vim.g.session_restoring then return end
    vim.cmd("startinsert")
  end,
  desc = "Entering a terminal starts Terminal-mode",
})
