return {
  "williamboman/mason.nvim",
  dependencies = {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    local mason = require("mason")
    local mason_tool_installer = require("mason-tool-installer")

    mason.setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
        border = "rounded",
      },
    })

    mason_tool_installer.setup({
      ensure_installed = {
        "lua-language-server",        -- luals
        "stylua",                     -- Lua Formatter
        "rust-analyzer",              -- rust
        "pyright",                    -- python lsp
        "black",                      -- python formatter
        "isort",                      -- python importer
        "eslint-lsp",                 -- TypeScript Linter / Formatter
        "typescript-language-server", -- TypeScript LSP
        "gopls"                       -- golang
      },
    })
  end,
}
