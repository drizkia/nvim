require("illuminate").configure({
  delay = 200,
  large_file_cutoff = 2000,
  large_file_overrides = {
    providers = { "lsp" },
  },
  filetypes_denylist = {
    "dirbuf",
    "dirvish",
    "fugitive",
    "oil",
    "neo-tree",
    "TelescopePrompt",
  },
})
