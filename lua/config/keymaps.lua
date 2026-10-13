-- General Keymaps
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory with Oil" })

-- Buffer navigation
vim.keymap.set("n", "<leader>bd", "<CMD>bdelete<CR>", { desc = "Delete buffer" })
vim.keymap.set("n", "<leader>bn", "<CMD>bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>bp", "<CMD>bprevious<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "<leader>bo", "<CMD>%bdelete|edit #<CR>", { desc = "Close other buffers" })

-- Window navigation
-- vim.keymap.set("n", "<C-w>h", "<C-w>h", { desc = "Move to left window" })
-- vim.keymap.set("n", "<C-w>j", "<C-w>j", { desc = "Move to bottom window" })
-- vim.keymap.set("n", "<C-w>k", "<C-w>k", { desc = "Move to top window" })
-- vim.keymap.set("n", "<C-w>l", "<C-w>l", { desc = "Move to right window" })

-- Window splits
-- vim.keymap.set("n", "<leader>wv", "<CMD>vsplit<CR>", { desc = "Vertical split" })
-- vim.keymap.set("n", "<leader>ws", "<CMD>split<CR>", { desc = "Horizontal split" })
-- vim.keymap.set("n", "<leader>wc", "<CMD>close<CR>", { desc = "Close window" })
-- vim.keymap.set("n", "<leader>wo", "<CMD>only<CR>", { desc = "Close other windows" })

-- Window resize
vim.keymap.set("n", "<C-Up>", "<CMD>resize +2<CR>", { desc = "Increase window height" })
vim.keymap.set("n", "<C-Down>", "<CMD>resize -2<CR>", { desc = "Decrease window height" })
vim.keymap.set("n", "<C-Left>", "<CMD>vertical resize -2<CR>", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-Right>", "<CMD>vertical resize +2<CR>", { desc = "Increase window width" })

-- Window navigation. <C-w> is forwarded to the shell in terminal-mode,
-- so Alt is used instead (see :h terminal-input).
for _, dir in ipairs({ "h", "j", "k", "l" }) do
  vim.keymap.set("n", "<A-" .. dir .. ">", "<C-w>" .. dir, { desc = "Move to window " .. dir })
  vim.keymap.set("t", "<A-" .. dir .. ">", "<C-\\><C-N><C-w>" .. dir, { silent = true, desc = "Move to window " .. dir })
end

-- Better indenting
vim.keymap.set("v", "<", "<gv", { desc = "Indent left and reselect" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right and reselect" })

-- Keep cursor centered
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result and center" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result and center" })

-- Clear search highlight
vim.keymap.set("n", "<ESC>", "<CMD>noh<CR>", { desc = "Clear search highlights" })

-- Save file
vim.keymap.set("n", "<leader>w", "<CMD>write<CR>", { desc = "Save file" })

-- Quit
vim.keymap.set("n", "<leader>q", "<CMD>quit<CR>", { desc = "Quit" })

-- Format
vim.keymap.set("n", "<leader>cf", "<CMD>Conform<CR>", { desc = "Format file" })

-- Gitsigns
local function gitsigns_map(lhs, cmd, desc)
  vim.keymap.set("n", lhs, "<CMD>Gitsigns " .. cmd .. "<CR>", { desc = desc, silent = true })
end
gitsigns_map("]c", "next_hunk", "Next hunk")
gitsigns_map("[c", "prev_hunk", "Previous hunk")
gitsigns_map("<leader>hs", "stage_hunk", "Stage hunk")
gitsigns_map("<leader>hr", "reset_hunk", "Reset hunk")
gitsigns_map("<leader>hp", "preview_hunk", "Preview hunk")
gitsigns_map("<leader>hb", "blame_line", "Blame line")
gitsigns_map("<leader>hd", "diffthis", "Diff this")

-- Fugitive
vim.keymap.set("n", "<leader>gs", ":Git<CR>", { desc = "Git status" })
vim.keymap.set("n", "<leader>gd", ":Gdiff<CR>", { desc = "Git diff" })
vim.keymap.set("n", "<leader>gc", ":Git commit<CR>", { desc = "Git commit" })
vim.keymap.set("n", "<leader>gp", ":Git push<CR>", { desc = "Git push" })
vim.keymap.set("n", "<leader>gl", ":Git log<CR>", { desc = "Git log" })
vim.keymap.set("n", "<leader>gb", ":Git blame<CR>", { desc = "Git blame" })

-- Build workflow
local function parallel_jobs()
  if vim.uv and vim.uv.available_parallelism then
    return vim.uv.available_parallelism()
  end
  return tonumber(vim.fn.system("nproc")) or 4
end

vim.keymap.set("n", "<leader>cm", function()
  vim.cmd("make -j" .. parallel_jobs())
  local qf = vim.fn.getqflist({ size = 0 })
  if qf.size > 0 then
    vim.cmd("copen")
  else
    vim.cmd("cclose")
    vim.notify("Build OK", vim.log.levels.INFO)
  end
end, { desc = "Build (make -j)" })

local function quickfix_open()
  for _, info in ipairs(vim.fn.getwininfo()) do
    if info.quickfix == 1 then
      return true
    end
  end
  return false
end

vim.keymap.set("n", "<leader>co", function()
  if quickfix_open() then
    vim.cmd("cclose")
  else
    vim.cmd("copen")
  end
end, { desc = "Toggle quickfix" })
vim.keymap.set("n", "]q", "<CMD>cnext<CR>", { desc = "Next quickfix entry" })
vim.keymap.set("n", "[q", "<CMD>cprev<CR>", { desc = "Previous quickfix entry" })

-- Kernel checkpatch on the current file
vim.keymap.set("n", "<leader>cp", function()
  local src = vim.api.nvim_buf_get_name(0)
  if src == "" then
    vim.notify("Buffer has no file", vim.log.levels.WARN)
    return
  end
  local cp = vim.fs.find("scripts/checkpatch.pl", { upward = true, path = vim.fs.dirname(src) })[1]
  if not cp then
    vim.notify("checkpatch.pl not found above " .. vim.fs.dirname(src), vim.log.levels.WARN)
    return
  end
  local out = vim.fn.system({ "perl", cp, "--no-tree", "--file", src })
  local lines = vim.split(out, "\n")
  vim.cmd("botright 12new")
  vim.bo.buftype = "nofile"
  vim.bo.bufhidden = "wipe"
  vim.bo.swapfile = false
  vim.bo.filetype = "checkpatch"
  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
  vim.bo.readonly = true
  vim.bo.modified = false
  vim.keymap.set("n", "q", "<CMD>close<CR>", { buffer = 0, silent = true })
end, { desc = "Run checkpatch on file" })

-- Terminal toggle. Opens focused (Terminal-mode) and reuses the shell.
local term_buf, term_win
local function toggle_terminal()
  if term_win and vim.api.nvim_win_is_valid(term_win) then
    if #vim.api.nvim_list_wins() == 1 then
      vim.notify("Cannot close the last window", vim.log.levels.WARN)
      return
    end
    vim.api.nvim_win_close(term_win, true)
    term_win = nil
    return
  end
  vim.cmd("botright 12split")
  term_win = vim.api.nvim_get_current_win()
  if term_buf and vim.api.nvim_buf_is_valid(term_buf) and vim.bo[term_buf].buftype == "terminal" then
    vim.api.nvim_win_set_buf(term_win, term_buf)
  else
    vim.cmd("terminal")
    term_buf = vim.api.nvim_get_current_buf()
  end
  vim.cmd("startinsert")
end

vim.keymap.set("n", "<A-t>", toggle_terminal, { desc = "Toggle terminal" })
vim.keymap.set("n", "<leader>tt", toggle_terminal, { desc = "Toggle terminal" })
vim.keymap.set("n", "<leader>th", "<CMD>botright 12split | terminal<CR>", { desc = "New terminal" })

-- Toggle the terminal from inside it (shell is kept for reuse).
vim.keymap.set("t", "<A-t>", function()
  vim.cmd("stopinsert")
  toggle_terminal()
end, { silent = true, desc = "Toggle terminal" })
