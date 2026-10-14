-- Native Package Management (vim.pack)
vim.pack.add({
  -- Utilities & Git
  { src = "https://github.com/stevearc/oil.nvim" },
  { src = "https://github.com/tpope/vim-fugitive" },
  { src = "https://github.com/lewis6991/gitsigns.nvim" },
  { src = "https://github.com/neovim/nvim-lspconfig" },

  -- Omarchy Theme Plugins
  { src = "https://github.com/bjarneo/aether.nvim", version = "v3" },
  { src = "https://github.com/folke/tokyonight.nvim" },
  { src = "https://github.com/catppuccin/nvim" },
  { src = "https://github.com/rose-pine/neovim" },
  { src = "https://github.com/ellisonleao/gruvbox.nvim" },
  { src = "https://github.com/rebelot/kanagawa.nvim" },
  { src = "https://github.com/neanias/everforest-nvim" },
  { src = "https://github.com/EdenEast/nightfox.nvim" },
  { src = "https://github.com/ficcdaf/ashen.nvim" },
  { src = "https://github.com/ribru17/bamboo.nvim" },
  { src = "https://github.com/tahayvr/matteblack.nvim" },
  { src = "https://github.com/OldJobobo/retro-82.nvim" },
  { src = "https://github.com/omacom-io/lumon.nvim" },
  { src = "https://github.com/kepano/flexoki-neovim" },

  -- Tier 1: Core IDE
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects" },
  { src = "https://github.com/nvim-telescope/telescope.nvim" },
  { src = "https://github.com/nvim-telescope/telescope-fzf-native.nvim" },
  { src = "https://github.com/hrsh7th/nvim-cmp" },
  { src = "https://github.com/hrsh7th/cmp-nvim-lsp" },
  { src = "https://github.com/hrsh7th/cmp-buffer" },
  { src = "https://github.com/hrsh7th/cmp-path" },
  { src = "https://github.com/hrsh7th/cmp-cmdline" },
  { src = "https://github.com/L3MON4D3/LuaSnip" },
  { src = "https://github.com/saadparwaiz1/cmp_luasnip" },
  { src = "https://github.com/stevearc/conform.nvim" },
  { src = "https://github.com/mfussenegger/nvim-lint" },
  { src = "https://github.com/folke/which-key.nvim" },
  { src = "https://github.com/nvim-lualine/lualine.nvim" },
  { src = "https://github.com/folke/trouble.nvim" },
  { src = "https://github.com/nvim-tree/nvim-web-devicons" },
  { src = "https://github.com/nvim-neo-tree/neo-tree.nvim", version = "v3.x" },
  { src = "https://github.com/mikavilpas/yazi.nvim" },
  { src = "https://github.com/MunifTanjim/nui.nvim" },
  { src = "https://github.com/mrcjkb/rustaceanvim" },
  { src = "https://github.com/mfussenegger/nvim-dap" },
  { src = "https://github.com/rcarriga/nvim-dap-ui" },
  { src = "https://github.com/nvim-neotest/nvim-nio" },

  -- Tier 2: Essential Editing
  { src = "https://github.com/kylechui/nvim-surround" },
  { src = "https://github.com/numToStr/Comment.nvim" },
  { src = "https://github.com/windwp/nvim-autopairs" },
  { src = "https://github.com/andymass/vim-matchup" },
  { src = "https://github.com/RRethy/vim-illuminate" },
  { src = "https://github.com/folke/todo-comments.nvim" },
  { src = "https://github.com/lukas-reineke/indent-blankline.nvim" },
  { src = "https://github.com/akinsho/bufferline.nvim" },
})

-- Plugin Setup
local ok_oil, oil = pcall(require, "oil")
if ok_oil then
  oil.setup()
end

local ok_gitsigns, gitsigns = pcall(require, "gitsigns")
if ok_gitsigns then
  gitsigns.setup()
end

local ok_devicons, devicons = pcall(require, "nvim-web-devicons")
if ok_devicons then
  devicons.setup()
end
