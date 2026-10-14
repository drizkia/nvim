-- Optional: Disable default spacebar behavior in normal/visual mode
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Set leader key before anything else
vim.g.mapleader = " "

-- Load modular configuration
require("config.options")
require("config.autocmds")
require("config.plugins")
require("config.lsp")
require("config.keymaps")
require("config.completion")
require("config.treesitter")
require("config.textobjects")
require("config.telescope")
require("config.conform")
require("config.lint")
require("config.dap")
require("config.lualine")
require("config.trouble")
require("config.whichkey")
require("config.neotree")
require("config.yazi")
require("config.surround")
require("config.comment")
require("config.autopairs")
require("config.matchup")
require("config.illuminate")
require("config.todocomments")
require("config.indent-blankline")
require("config.bufferline")
require("config.theme").setup({ transparent = true })
