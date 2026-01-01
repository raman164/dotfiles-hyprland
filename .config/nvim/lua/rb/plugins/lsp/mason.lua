return {
  "williamboman/mason.nvim",
  dependencies = {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    local mason = require("mason")
    local mason_tool_installer = require("mason-tool-installer")

    -- Enable mason and configure icons
    mason.setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
        border = "rounded",
        width = 0.8,
        height = 0.8,
      },
    })

    -- Install LSP servers, formatters, and linters
    -- Note: lua_ls uses system package (installed via pacman)
    mason_tool_installer.setup({
      ensure_installed = {
        -- LSP Servers (configured via vim.lsp.config in lspconfig.lua)
        "clangd",        -- C/C++
        "pyright",       -- Python
        "typescript-language-server", -- TypeScript/JavaScript (ts_ls)
        "html-lsp",      -- HTML
        "css-lsp",       -- CSS
        "json-lsp",      -- JSON
        "bash-language-server", -- Bash
        "gopls",         -- Go
        "rust-analyzer", -- Rust
        "yaml-language-server", -- YAML

        -- Formatters
        "prettier",      -- JS/TS/HTML/CSS/JSON
        "stylua",        -- Lua
        "isort",         -- Python import sorter
        "black",         -- Python formatter
        "clang-format",  -- C/C++

        -- Linters
        "ruff",          -- Python linter
        "eslint_d",      -- JavaScript/TypeScript linter
        "shellcheck",    -- Shell script linter
      },
      automatic_installation = true,
      run_on_start = true,
    })
  end,
}
