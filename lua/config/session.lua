-- Session persistence
local M = {}
local session_dir = vim.fn.stdpath("state") .. "/sessions"
vim.opt.sessionoptions = { "buffers", "curdir", "folds", "help", "tabpages", "winsize", "terminal" }

local skip = { "/tmp/", "/proc/", "/sys/", "/dev/" }
if vim.env.XDG_RUNTIME_DIR then
  skip[#skip + 1] = vim.env.XDG_RUNTIME_DIR .. "/"
end

local function skipped()
  local cwd = vim.fn.getcwd()
  for _, p in ipairs(skip) do
    if cwd:sub(1, #p) == p then return true end
  end
  return false
end

local function session_file()
  local cwd = vim.fn.getcwd()
  -- Readable prefix + stable suffix. NOTE: vim.fn.sha256() is NOT
  -- deterministic in this build (a different hash on every call), so a plain
  -- Lua checksum is used instead -- otherwise the save path and the restore
  -- path would disagree and saved sessions would never be found again.
  local name = cwd:gsub("[^%w]", "_"):sub(1, 64)
  local h = 5381
  for i = 1, #cwd do
    h = (h * 33 + cwd:byte(i)) % 4294967296
  end
  return string.format("%s/%s-%08x.vim", session_dir, name, h)
end

local function trivial()
  local bufs = vim.fn.getbufinfo({ buflisted = 1 })
  if #bufs ~= 1 then return false end
  local b = bufs[1]
  return b.name == "" and not vim.bo[b.bufnr].modified
end

local did_restore = false

-- Set by M.delete(). Suppresses the auto-save on the next quit so a deleted
-- session isn't immediately recreated. It's module-local, so it naturally
-- resets on the next nvim start -- auto-save resumes for that fresh visit.
local forgot = false

function M.save()
  if forgot then return end
  if skipped() or trivial() then return end
  local file = session_file()
  if not did_restore and vim.fn.argc() > 0 and vim.fn.filereadable(file) == 1 then
    return
  end
  vim.fn.mkdir(session_dir, "p")
  local ok, err = pcall(vim.cmd, "mksession! " .. vim.fn.fnameescape(file))
  if not ok then
    vim.notify("Session save failed: " .. tostring(err), vim.log.levels.WARN)
  end
end

-- Explicit save (<leader>SS): overrides a prior delete and re-enables saving.
function M.save_explicit()
  forgot = false
  M.save()
end

function M.load(opts)
  opts = opts or {}
  if skipped() then
    if opts.notify then
      vim.notify("Not restoring a session in " .. vim.fn.getcwd(), vim.log.levels.INFO)
    end
    return false
  end
  local file = session_file()
  if vim.fn.filereadable(file) == 0 then
    if opts.notify then
      vim.notify("No saved session for " .. vim.fn.getcwd(), vim.log.levels.INFO)
    end
    return false
  end
  -- Sourcing the session fires BufEnter term://* for any restored terminal.
  -- The 'startinsert' in that autocmd would otherwise hijack the mode and
  -- apply it to whichever window the restore settles on (often a file
  -- buffer). Suppress it for the duration of the restore.
  vim.g.session_restoring = true
  local ok, err = pcall(vim.cmd, "silent! source " .. vim.fn.fnameescape(file))
  vim.g.session_restoring = nil
  if not ok then
    if opts.notify then
      vim.notify("Session restore failed: " .. tostring(err), vim.log.levels.WARN)
    end
    return false
  end
  did_restore = true
  return true
end

function M.delete()
  local file = session_file()
  if vim.fn.delete(file) == 0 then
    -- Stop the next quit from recreating it. Auto-save resumes on the next
    -- nvim start (this flag is per-process).
    forgot = true
    vim.notify("Deleted session for " .. vim.fn.getcwd() .. " (won't re-save on quit)", vim.log.levels.INFO)
  else
    vim.notify("No saved session for " .. vim.fn.getcwd(), vim.log.levels.INFO)
  end
end

vim.api.nvim_create_autocmd("VimLeavePre", {
  group = vim.api.nvim_create_augroup("SessionSave", { clear = true }),
  callback = M.save,
})

vim.api.nvim_create_autocmd("VimEnter", {
  group = vim.api.nvim_create_augroup("SessionRestore", { clear = true }),
  -- mksession restores terminals by re-opening the term://{cwd}//{pid}:{cmd}
  -- name. Per :h terminal-start, opening a term:// buffer from inside an
  -- autocmd requires ++nested -- without it the "terminal" is just a plain
  -- editable buffer that happens to be named term://, with no job attached.
  nested = true,
  callback = function()
    if vim.fn.argc() > 0 then return end
    M.load()
  end,
})

vim.keymap.set("n", "<leader>SS", M.save_explicit, { desc = "Save session" })
vim.keymap.set("n", "<leader>SL", function() M.load({ notify = true }) end, { desc = "Load session" })
vim.keymap.set("n", "<leader>SD", M.delete, { desc = "Delete session" })

return M
