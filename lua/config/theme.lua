local M = {}

local THEME_FILE = vim.fn.expand("~/.local/state/omarchy/current/theme/neovim.lua")
local WATCH_DIR = vim.fn.expand("~/.local/state/omarchy/current")

M.transparent = true

function M.apply_transparency()
  if not M.transparent then
    return
  end

  local groups = {
    "Normal",
    "NormalFloat",
    "FloatBorder",
    "Pmenu",
    "Terminal",
    "EndOfBuffer",
    "FoldColumn",
    "Folded",
    "SignColumn",
    "LineNr",
    "CursorLineNr",
    "NormalNC",
    "WhichKeyFloat",
    "TelescopeBorder",
    "TelescopeNormal",
    "TelescopePromptBorder",
    "TelescopePromptTitle",
    "OilDir",
    "GitSignsAdd",
    "GitSignsChange",
    "GitSignsDelete",
  }

  for _, name in ipairs(groups) do
    local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
    if ok and hl then
      hl.bg = nil
      vim.api.nvim_set_hl(0, name, hl)
    end
  end
end

function M.load()
  if vim.fn.filereadable(THEME_FILE) == 0 then
    return
  end

  local ok_load, theme_specs = pcall(dofile, THEME_FILE)
  if not ok_load or type(theme_specs) ~= "table" then
    return
  end

  local target_colorscheme = nil

  for _, spec in ipairs(theme_specs) do
    local repo_or_name = spec.name or spec[1]

    -- If the theme configures aether with custom palette colors
    if repo_or_name and (repo_or_name == "aether" or repo_or_name == "bjarneo/aether.nvim") and spec.opts then
      local ok_aether, aether = pcall(require, "aether")
      if ok_aether then
        aether.setup(spec.opts)
      end
    end

    -- Check if other themes provide plugin options
    if repo_or_name and spec.opts and spec[1] ~= "LazyVim/LazyVim" then
      local mod_name = repo_or_name:match("([^/]+)$") or repo_or_name
      mod_name = mod_name:gsub("%.nvim$", ""):gsub("%.lua$", "")
      local ok_mod, mod = pcall(require, mod_name)
      if ok_mod and type(mod.setup) == "function" then
        pcall(mod.setup, spec.opts)
      end
    end

    -- Find target colorscheme name
    if spec[1] == "LazyVim/LazyVim" and spec.opts and spec.opts.colorscheme then
      target_colorscheme = spec.opts.colorscheme
    end
  end

  -- Fallback if no LazyVim spec wrapper is present
  if not target_colorscheme then
    for _, spec in ipairs(theme_specs) do
      if spec.opts and spec.opts.colorscheme then
        target_colorscheme = spec.opts.colorscheme
        break
      end
    end
  end

  if target_colorscheme then
    vim.o.background = "dark"

    vim.cmd("highlight clear")
    if vim.fn.exists("syntax_on") == 1 then
      vim.cmd("syntax reset")
    end

    local ok_cs = pcall(vim.cmd.colorscheme, target_colorscheme)
    if not ok_cs then
      pcall(vim.cmd.colorscheme, "default")
    end

    M.apply_transparency()
    vim.cmd("redraw!")
  end
end

function M.setup_watcher()
  local fs_event = vim.uv.new_fs_event()
  if not fs_event then
    return
  end

  -- Watch current theme state directory for theme swaps
  fs_event:start(WATCH_DIR, {}, function(err, filename, events)
    if not err then
      vim.schedule(function()
        -- Short defer to allow atomic directory swap to finish
        vim.defer_fn(function()
          M.load()
        end, 50)
      end)
    end
  end)
end

function M.setup(opts)
  if opts and opts.transparent ~= nil then
    M.transparent = opts.transparent
  end

  M.load()
  M.setup_watcher()
end

return M
