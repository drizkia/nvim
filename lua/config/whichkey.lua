require("which-key").setup({
  preset = "modern",
  delay = 300,
  filter = function(mapping)
    return mapping.desc and mapping.desc ~= ""
  end,
  spec = {
    { "<leader>f", group = "Find" },
    { "<leader>g", group = "Git" },
    { "<leader>h", group = "Hunk" },
    { "<leader>x", group = "Trouble" },
    { "<leader>c", group = "Code" },
    { "<leader>b", group = "Buffer" },
    { "<leader>d", group = "Debug" },
    { "<leader>t", group = "Terminal" },
  },
})
