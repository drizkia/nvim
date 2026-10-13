require("Comment").setup({
  padding = true,
  sticky = true,
  ignore = nil,
  toggler = {
    line = "<leader>/",
    block = "<leader>cb",
  },
  opleader = {
    line = "<leader>/",
    block = "<leader>cb",
  },
  extra = {
    above = "<leader>ck",
    below = "<leader>cj",
    eol = "<leader>ce",
  },
  mappings = {
    basic = true,
    extra = true,
  },
  pre_hook = nil,
  post_hook = nil,
})
