-- Diagnostic configuration
vim.diagnostic.config({
  virtual_text = {
    prefix = "",
    source = "if_many",
  },
  float = {
    border = "rounded",
    source = "always",
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

local signs = { Error = "", Warn = "", Hint = "", Info = "" }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- LSP Keymaps (on attach)
-- Built-in equivalents are used where they exist:
--   gra = code action, grn = rename, grr = references, gri = implementation,
--   grt = type definition, ]d/[d = next/prev diagnostic
-- Note: <leader>d is reserved for the Debug (DAP) group, so the line
-- diagnostics float lives on "gl" alongside gd/gD.
local function on_attach(client, bufnr)
  local function opts(desc)
    return { buffer = bufnr, silent = true, desc = desc }
  end

  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts("LSP definition"))
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts("LSP declaration"))
  vim.keymap.set("n", "gl", vim.diagnostic.open_float, opts("Line diagnostics (float)"))
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts("LSP hover"))
  vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts("LSP signature help"))
  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts("Code action"))
end

-- C / C++ LSP (clangd)
vim.lsp.config.clangd = {
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--header-insertion=never",
    "--completion-style=detailed",
    "--function-arg-placeholders",
    "--fallback-style=llvm",
  },
  on_attach = on_attach,
}

-- Python LSP (pyright)
vim.lsp.config.pyright = {
  on_attach = on_attach,
}

-- Lua LSP (lua_ls)
vim.lsp.config.lua_ls = {
  on_attach = on_attach,
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      telemetry = { enable = false },
    },
  },
}

-- Rust LSP (rust-analyzer)
-- vim.lsp.config.rust_analyzer = {
--   on_attach = on_attach,
--   settings = {
--     ["rust-analyzer"] = {
--       cargo = {
--         allFeatures = true,
--         loadOutDirsFromCheck = true,
--       },
--       checkOnSave = {
--         allFeatures = true,
--         command = "clippy",
--       },
--       procMacro = {
--         enable = true,
--       },
--       inlayHints = {
--         chainingHints = true,
--         parameterHints = true,
--         typeHints = true,
--       },
--     },
--   },
-- }

-- Enable active servers globally
vim.g.rustaceanvim = {
  tools = {
    enable_clippy = true,
  },
  server = {
    on_attach = on_attach,
  },
}

vim.lsp.enable({ "clangd", "pyright", "lua_ls", "bashls" })
