# Neovim Configuration

My personal Neovim dotfiles — a fast, keyboard-driven setup for daily development
(C/C++, Python, Rust, Lua, shell, and the rest), with session persistence,
LSP, formatting, linting and debugging wired in out of the box.

Built on Neovim's **native package manager** (`vim.pack`), so there is no
`lazy.nvim` / `packer` bootstrap step — clone and run.

```
~/.config/nvim
├── init.lua            # entrypoint: sets the leader key, loads every module
├── lua/config/*.lua    # one file per concern (see "Layout" below)
├── nvim-pack-lock.json # pinned plugin revisions (reproducible installs)
└── LICENSE             # MIT
```

---

## Table of Contents

- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [External Tools](#external-tools)
- [Layout](#layout)
- [Keymaps](#keymaps)
  - [General](#general)
  - [Files & Search (Telescope)](#files--search-telescope)
  - [Buffers](#buffers)
  - [Git](#git)
  - [LSP](#lsp)
  - [Treesitter Textobjects](#treesitter-textobjects)
  - [Code / Format / Comment](#code--format--comment)
  - [Terminal](#terminal)
  - [Debug (DAP)](#debug-dap)
  - [Trouble & Todos](#trouble--todos)
  - [Sessions](#sessions)
- [LSP Servers](#lsp-servers)
- [Formatting & Linting](#formatting--linting)
- [Debugging](#debugging)
- [Sessions](#sessions)
- [Theme](#theme)
- [Notes & Design Decisions](#notes--design-decisions)
- [License](#license)

---

## Features

- **Native package management** — `vim.pack` with a committed lock file; no plugin bootstrap code.
- **LSP** — `clangd`, `pyright`, `lua_ls`, `bashls` enabled via the 0.12 `vim.lsp` API, with
  diagnostics (signs, virtual text, underline, floating window).
- **Treesitter** — highlighting, folding and textobjects for 25+ languages.
- **Completion** — `nvim-cmp` with LSP, buffer, path and snippet sources (`LuaSnip`).
- **Formatting** — `conform.nvim`, format-on-save with LSP fallback.
- **Linting** — `nvim-lint` (shellcheck, ruff) on write, enter and insert-leave.
- **Debugging** — `nvim-dap` + `nvim-dap-ui` with `lldb-dap` (C/C++/Rust) and `debugpy` (Python).
- **File tree** — `neo-tree` (left, width 30) and `oil.nvim` for quick parent-directory jumps.
- **Search & navigation** — `telescope.nvim` with `fzf-native` fuzzy finding and live grep.
- **Git** — `gitsigns.nvim` for hunk-level staging, plus `fugitive` for commits, logs and pushes.
- **Status line** — `lualine` (branch, diff, diagnostics, mode, filetype, location).
- **Session persistence** — sessions are saved per project directory and restored on startup.
- **Omarchy-aware theming** — follows the system theme and swaps live when it changes;
  transparent by default.

---

## Requirements

| Requirement | Notes |
| --- | --- |
| **Neovim >= 0.12** | Required: the config uses `vim.pack`, `vim.lsp.config` and `vim.lsp.enable`, all new in 0.12. |
| `git` | Needed for plugin installation and the Git integration. |
| A C toolchain / `make` | Optional, for the `<leader>cm` build workflow. |

Optional but recommended: `ripgrep`, `fzf`, `clangd`, `pyright`, `lua-language-server`,
`bash-language-server`, `stylua`, `clang-format`, `ruff`, `rustfmt`, `prettier`, `shfmt`,
`shellcheck`, `debugpy`, `lldb-dap`.

Everything degrades gracefully — a missing plugin or tool is simply skipped
(the setup calls are wrapped in `pcall`).

---

## Installation

```bash
git clone https://github.com/drizkia/nvim.git ~/.config/nvim
nvim
```

The first launch downloads every plugin listed in `lua/config/plugins.lua` and installs the
Treesitter parsers. Plugin revisions are pinned by `nvim-pack-lock.json`, so a fresh clone
reproduces the exact same setup.

If you already have an existing `~/.config/nvim`, back it up first:

```bash
mv ~/.config/nvim ~/.config/nvim.bak
git clone https://github.com/drizkia/nvim.git ~/.config/nvim
```

Plugins are installed into Neovim's package directory
(`~/.local/share/nvim/site/pack/core/opt` by default).

To update the plugins to their latest tagged versions:

```vim
:lua vim.pack.update()
```

Add `force = true` to move past the pinned lock file revisions:

```vim
:lua vim.pack.update(nil, { force = true })
```

---

## External Tools

The config shells out to these when the relevant feature is used. Install only what you need.

| Tool | Used by |
| --- | --- |
| `ripgrep` | `grepprg`, Telescope live grep |
| `fzf` | Telescope `fzf-native` extension (optional, enables fuzzy sorting) |
| `clangd` | C/C++ LSP |
| `pyright` | Python LSP |
| `lua-language-server` | Lua LSP |
| `bash-language-server` | Shell LSP |
| `stylua` | Lua formatter |
| `clang-format` | C/C++ formatter |
| `ruff` | Python formatter + linter |
| `rustfmt` | Rust formatter |
| `prettier` | JSON/YAML/Markdown formatter |
| `shfmt` | Shell formatter |
| `shellcheck` | Shell linter |
| `debugpy-adapter` | Python debugging (`pip install debugpy`) |
| `lldb-dap` | C/C++/Rust debugging |
| `perl` | Kernel `checkpatch.pl` (the `<leader>cp` mapping) |

---

## Layout

Every concern lives in its own file under `lua/config/`, loaded explicitly from `init.lua`.

| File | Purpose |
| --- | --- |
| `init.lua` | Entrypoint. Sets `mapleader` to `<Space>`, requires each module in order. |
| `options.lua` | Core editor options: numbers, wrapping, tabs, folds, lists, `grepprg`, etc. |
| `autocmds.lua` | Per-filetype indentation, session-restore guards, terminal auto-insert. |
| `plugins.lua` | The `vim.pack.add` plugin list plus setups for oil, gitsigns and devicons. |
| `keymaps.lua` | Global keymaps (buffers, windows, git, build, terminal, quit guard). |
| `lsp.lua` | `vim.lsp` server configs, diagnostics config, LSP keymaps. |
| `treesitter.lua` | Parser installation and per-filetype Treesitter activation. |
| `textobjects.lua` | Treesitter textobject / movement / swap keymaps. |
| `completion.lua` | `nvim-cmp` setup: sources, mappings, icon formatting, cmdline completion. |
| `conform.lua` | `conform.nvim` formatters per filetype and format-on-save. |
| `lint.lua` | `nvim-lint` linters per filetype and lint triggers. |
| `dap.lua` | `nvim-dap` adapters, configurations and keymaps. |
| `telescope.lua` | Telescope setup, fzf extension and find-picker keymaps. |
| `neotree.lua` | Neo-tree configuration and keymaps. |
| `yazi.lua` | `<leader>-` mapping to open Yazi. |
| `bufferline.lua` | Bufferline options and buffer navigation keymaps. |
| `lualine.lua` | Status line layout. |
| `trouble.lua` | Trouble configuration and keymaps. |
| `whichkey.lua` | Which-key group labels. |
| `session.lua` | Session save / load / delete and the autocmds that drive them. |
| `comment.lua` | `Comment.nvim` configuration. |
| `autopairs.lua` | `nvim-autopairs` rules and fast-wrap. |
| `surround.lua` | `nvim-surround` configuration. |
| `matchup.lua` | `vim-matchup` parenthesis highlighting. |
| `illuminate.lua` | `vim-illuminate` incremental word highlight. |
| `todocomments.lua` | `todo-comments` keywords, signs and navigation. |
| `indent-blankline.lua` | `indent-blankline.nvim` scope highlighting. |
| `theme.lua` | Omarchy theme detection, colorscheme loading and transparency. |

---

## Keymaps

The leader key is `<Space>`.

### General

| Key | Action |
| --- | --- |
| `<Space>` | Disabled in normal/visual mode (leader only) |
| `-` | Open the parent directory with Oil |
| `<leader>w` | Save file |
| `<leader>q` | Quit (refuses if other buffers are still open) |
| `<leader>Q` | Force quit all (`:quitall`) |
| `<leader>cf` | Format the current buffer (Conform) |
| `<Esc>` | Clear search highlights (normal mode) |
| `<C-d>` / `<C-u>` | Scroll down / up and keep the cursor centred |
| `n` / `N` | Next / previous search result, centred |
| `<` / `>` | Indent and keep the selection (visual mode) |
| `<C-Up>` / `<C-Down>` | Resize the window height by 2 |
| `<C-Left>` / `<C-Right>` | Resize the window width by 2 |
| `<A-h>` `<A-j>` `<A-k>` `<A-l>` | Move between windows (also works in terminal mode) |

### Files & Search (Telescope)

| Key | Action |
| --- | --- |
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>fb` | Buffers |
| `<leader>fr` | Recent files |
| `<leader>fc` | Commands |
| `<leader>fk` | Keymaps |
| `<leader>fh` | Help tags |
| `<leader>fs` | LSP document symbols |
| `<leader>fS` | LSP workspace symbols |
| `<leader>fd` | Diagnostics |
| `<leader>ft` | Treesitter symbols |
| `<leader>fl` | Git commits (log) |
| `<leader>fw` | Git branches |

Inside the picker: `<C-j>` / `<C-k>` to move, `<C-q>` to send to the quickfix list, `<Esc>` to close.

### Buffers

| Key | Action |
| --- | --- |
| `<leader>bd` | Delete buffer |
| `<leader>bn` | Next buffer |
| `<leader>bp` | Previous buffer |
| `<leader>bo` | Close all other buffers |
| `<leader>bc` | Pick a buffer to close |
| `<leader>b1` … `<leader>b9` | Go to buffer 1–9 |
| `<leader>e` | Toggle the file explorer (Neo-tree) |
| `<leader>E` | Focus the file explorer |
| `<leader>-` | Open Yazi |

### Git

| Key | Action |
| --- | --- |
| `<leader>gs` | `:Git` status |
| `<leader>gd` | `:Gdiff` |
| `<leader>gc` | `:Git commit` |
| `<leader>gp` | `:Git push` |
| `<leader>gl` | `:Git log` |
| `<leader>gb` | `:Git blame` |
| `]c` / `[c` | Next / previous hunk (gitsigns) |
| `<leader>hs` | Stage hunk |
| `<leader>hr` | Reset hunk |
| `<leader>hp` | Preview hunk |
| `<leader>hb` | Blame line |
| `<leader>hd` | Diff this |

### LSP

| Key | Action |
| --- | --- |
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `K` | Hover documentation |
| `<C-k>` | Signature help |
| `gl` | Line diagnostics (floating window) |
| `<leader>ca` | Code action |

> Note: `<leader>d` is reserved for the Debug group, so the diagnostics float lives on `gl`
> next to `gd` / `gD`.

### Treesitter Textobjects

| Key | Select |
| --- | --- |
| `af` / `if` | Function outer / inner |
| `ac` / `ic` | Class outer / inner |
| `aa` / `ia` | Parameter outer / inner |
| `al` / `il` | Loop outer / inner |
| `ai` / `ii` | Conditional outer / inner |
| `ab` / `ib` | Block outer / inner |

| Key | Move |
| --- | --- |
| `]m` / `[m` | Next / previous function start |
| `]M` / `[M` | Next / previous function end |
| `]]` / `[[` | Next / previous class start |
| `][` / `[]` | Next / previous class end |
| `<leader>a` / `<leader>A` | Swap parameter with next / previous |

### Code / Format / Comment

| Key | Action |
| --- | --- |
| `<leader>cm` | Build with `make -j<n>` and open the quickfix list on errors |
| `<leader>co` | Toggle the quickfix window |
| `]q` / `[q` | Next / previous quickfix entry |
| `<leader>cp` | Run the kernel `checkpatch.pl` on the current file |
| `<leader>/` | Toggle a line comment |
| `<leader>cb` | Toggle a block comment |
| `<leader>ck` | Comment above |
| `<leader>cj` | Comment below |
| `<leader>ce` | Comment at end of line |

### Terminal

| Key | Action |
| --- | --- |
| `<leader>tt` / `<A-t>` | Toggle the terminal (reuses the same shell) |
| `<leader>th` | Open a new terminal |
| `<A-h>` `<A-j>` `<A-k>` `<A-l>` | Move between windows while in terminal mode |

### Debug (DAP)

| Key | Action |
| --- | --- |
| `<leader>db` | Toggle breakpoint |
| `<leader>dB` | Set a conditional breakpoint |
| `<leader>dc` | Continue |
| `<leader>do` | Step over |
| `<leader>di` | Step into |
| `<leader>dr` | Open the REPL |
| `<leader>dq` | Disconnect |
| `<leader>du` | Toggle the DAP UI |

### Trouble & Todos

| Key | Action |
| --- | --- |
| `<leader>xx` | Diagnostics (Trouble) |
| `<leader>xX` | Diagnostics for the current buffer |
| `<leader>xs` | Workspace symbols |
| `<leader>xr` | LSP definitions / references |
| `<leader>xL` | Location list |
| `<leader>xQ` | Quickfix list |
| `]t` / `[t` | Next / previous TODO comment |
| `<leader>xt` | TODOs (Trouble) |
| `<leader>xT` | TODO / FIX / FIXME (Trouble) |

### Sessions

| Key | Action |
| --- | --- |
| `<leader>SS` | Save the session now |
| `<leader>SL` | Load the session for this directory |
| `<leader>SD` | Delete the saved session for this directory |

---

## LSP Servers

Enabled through the Neovim 0.12 API (`vim.lsp.enable`):

| Server | Language |
| --- | --- |
| `clangd` | C, C++ (background index, clang-tidy, detailed completions) |
| `pyright` | Python |
| `lua_ls` | Lua |
| `bashls` | Shell |

`clangd` is started with `--background-index`, `--clang-tidy`,
`--header-insertion=never`, `--completion-style=detailed`,
`--function-arg-placeholders` and `--fallback-style=llvm`.

A `rust-analyzer` / `rustaceanvim` configuration is included in `lua/config/lsp.lua` but
commented out — enable it by uncommenting the block and adding `rust_analyzer` to
`vim.lsp.enable`.

Diagnostics are rendered as signs, virtual text (source shown only when there are multiple
sources), underlines, and a floating window via `gl`.

---

## Formatting & Linting

`conform.nvim` handles formatting, with format-on-save and a 500 ms timeout; the LSP
formatter is used as a fallback when no external formatter is configured for the filetype.

| Filetype | Formatter |
| --- | --- |
| `c`, `cpp` | `clang_format` (`--style=Linux`) |
| `python` | `ruff_format` + `ruff_organize_imports` |
| `rust` | `rustfmt` |
| `lua` | `stylua` (forced to 2 spaces) |
| `json`, `jsonc`, `yaml`, `markdown` | `prettier` |
| `bash`, `sh` | `shfmt` |

`nvim-lint` runs `shellcheck` for shell, `bash` and `ruff` for Python on write, buffer
enter and insert-leave.

Indentation is set per filetype: tabs (width 8) for C/C++ and shell, 4 spaces for Python and
Rust, 2 spaces for Lua, JSON, YAML, TOML and Markdown.

---

## Debugging

`nvim-dap` is configured with two adapters:

- **lldb-dap** for C, C++ and Rust — the configuration prompts for the executable path and
  uses the workspace folder as the working directory.
- **debugpy-adapter** for Python — uses the file being edited and, when a virtualenv is
  active, the interpreter from `$VIRTUAL_ENV`.

`nvim-dap-ui` opens automatically when a debug session starts and closes when it ends.
Adapters are only registered when the corresponding executable is on your `PATH`.

---

## Sessions

Sessions are stored per working directory in
`~/.local/state/nvim/sessions/<cwd>-<hash>.vim`.

- On `VimLeavePre` the session is saved automatically (buffers, cursor position, folds,
  tab pages, window sizes and the terminal).
- On startup the session for the current directory is restored — but only when Neovim was
  started **without** a file argument, so `nvim somefile.txt` always opens that file.
- Directories under `/tmp`, `/proc`, `/sys`, `/dev` and `$XDG_RUNTIME_DIR` are skipped.

Manual control: `<leader>SS` (save), `<leader>SL` (load), `<leader>SD` (delete).
Deleting a session also stops it from being re-created on the next quit.

---

## Theme

`lua/config/theme.lua` integrates with [Omarchy](https://github.com/basecamp/omarchy):
it reads `~/.local/state/omarchy/current/theme/neovim.lua`, applies the colorscheme it
points at, and watches the theme directory so the colorscheme switches live when you
change the system theme.

If the file is missing (i.e. you are not on Omarchy), the config simply leaves the default
colorscheme alone — nothing breaks.

Transparency is enabled by default and applied to the editor, floats, menus, the status line
and the file tree. Toggle it by editing the top of `lua/config/theme.lua`:

```lua
M.transparent = true  -- set to false for an opaque background
```

Several themes are packaged as fallbacks and can be enabled at any time with
`:colorscheme <name>`: `aether`, `tokyonight`, `catppuccin`, `rose-pine`, `gruvbox`,
`kanagawa`, `everforest`, `nightfox`, `ashen`, `bamboo`, `matteblack`, `retro-82`, `lumon`
and `flexoki`.

---

## Notes & Design Decisions

- **`<leader>d` belongs to Debug.** That is why the diagnostics float is on `gl` and not on
  `<leader>d`.
- **Alt is used for window navigation** instead of `<C-w>h/j/k/l`, because `<C-w>` is
  forwarded to the shell in terminal mode (see `:h terminal-input`).
- **The quit guard** (`<leader>q`) refuses to close Neovim while other buffers are still
  open and tells you how many; `<leader>Q` forces it.
- **The terminal is reused.** Toggling it closes and reopens the same shell instead of
  spawning a new one, and a restored session shell is adopted rather than duplicated.
- **Sessions are hash-free.** `vim.fn.sha256()` is not deterministic across calls in this
  build, so a plain Lua checksum is used to name session files — otherwise a saved session
  would never be found again.
- **`nvim-surround`** keeps its default keymaps (`sa`, `sd`, `sr`, `si`, …).
- **`neo-tree` and `oil`** coexist: `<leader>e` toggles the tree, `-` jumps to the parent
  directory, `<leader>-` opens Yazi.

---

## License

[MIT](./LICENSE) — Copyright (c) 2026 Damar Rizki Ananda.
