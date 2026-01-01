# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a Neovim configuration using lazy.nvim as the plugin manager. The configuration is organized in a modular structure under `lua/rb/` with separate directories for core settings and plugins.

## Project Structure

```
~/.config/nvim/
├── init.lua                    # Entry point: loads core and lazy
├── lazy-lock.json              # Lock file for plugin versions
├── lua/rb/
│   ├── core/
│   │   ├── init.lua           # Loads options and keymaps
│   │   ├── options.lua        # Vim options (tabs, search, UI)
│   │   └── keymaps.lua        # Global keybindings
│   ├── lazy.lua               # Lazy.nvim bootstrap and setup
│   └── plugins/               # Plugin configurations (one file per plugin)
│       ├── init.lua           # Basic plugins (plenary, tmux-navigator)
│       ├── lsp/               # LSP-specific plugins
│       │   ├── mason.lua      # LSP/tool installer configuration
│       │   └── lspconfig.lua  # LSP server configurations
│       ├── formatting.lua     # conform.nvim config
│       ├── linting.lua        # nvim-lint config
│       ├── nvim-cmp.lua       # Autocompletion config
│       ├── telescope.lua      # Fuzzy finder config
│       └── [other plugins]    # Each plugin in its own file
├── after/queries/             # Treesitter query overrides
└── pack/nvim/start/           # Additional plugins installed via pack
```

## Architecture

### Plugin Management

- **Plugin Manager**: lazy.nvim (auto-bootstrapped in `lua/rb/lazy.lua`)
- **Plugin Organization**: Each plugin has its own file in `lua/rb/plugins/` or `lua/rb/plugins/lsp/`
- **Plugin Loading**: lazy.nvim imports from `rb.plugins` and `rb.plugins.lsp` directories
- **Lock File**: `lazy-lock.json` pins plugin versions for reproducibility

### Core Configuration Flow

1. `init.lua` loads `rb.core` (options + keymaps) and `rb.lazy` (plugin manager)
2. lazy.nvim automatically loads all files in `lua/rb/plugins/` and `lua/rb/plugins/lsp/`
3. Each plugin file returns a lazy.nvim plugin spec with configuration

### LSP Setup

The LSP configuration uses a three-layer architecture:

1. **mason.nvim** (`lua/rb/plugins/lsp/mason.lua`): Installs LSP servers, formatters, and linters
   - Configured servers: clangd, lua_ls, pyright, ts_ls, html, cssls, jsonls, bashls, gopls, rust_analyzer, yamlls
   - Configured tools: prettier, stylua, isort, black, clang-format, ruff, eslint_d, shellcheck

2. **mason-lspconfig.nvim**: Bridges mason and lspconfig, handles automatic installation

3. **nvim-lspconfig** (`lua/rb/plugins/lsp/lspconfig.lua`): Configures each LSP server
   - Sets up capabilities integration with nvim-cmp
   - Defines server-specific settings in `server_configs` table
   - Uses `LspAttach` autocmd to set keybindings when LSP attaches

### Formatting & Linting

- **Formatting**: conform.nvim with format-on-save enabled (1s timeout)
  - Python: isort + black
  - JS/TS/JSON/HTML/CSS: prettier
  - Lua: stylua
  - C/C++: clang-format

- **Linting**: nvim-lint with auto-linting on BufEnter, BufWritePost, InsertLeave
  - Python: ruff
  - JS/TS: eslint_d
  - C/C++: cpplint

### Completion

nvim-cmp with sources in priority order:
1. nvim_lsp (LSP completions)
2. luasnip (snippets)
3. copilot (GitHub Copilot)
4. buffer (text in current buffer)
5. path (file paths)

## Key Commands & Workflows

### Plugin Management

```vim
:Lazy              " Open lazy.nvim UI
:Mason             " Open Mason UI for LSP/tool management
```

Or use leader keymaps:
- `<leader>l` - Open Lazy
- `<leader>m` - Open Mason

### Python Development

Python uses pyright for LSP with type checking disabled (matching pyrightconfig.json). The configuration:
- Disables type checking (`typeCheckingMode = "off"`)
- Provides completions, go-to-definition, and refactoring
- Uses ruff for linting (fast Python linter)
- Uses black + isort for formatting

If Python LSP isn't working, check:
1. Pyright is installed: `:Mason` and verify pyright is installed
2. Ruff, black, isort are installed for linting/formatting
3. Check `:LspInfo` for active clients

### C/C++ Development

- LSP: clangd with background indexing and clang-tidy
- Formatter: clang-format
- Linter: cpplint
- Execute: `<leader>c` compiles with g++ and runs

### Running Code

Quick execution keybindings in normal mode:
- `<leader>p` - Run Python file with python3
- `<leader>c` - Compile and run C++ file
- `<leader>pm` - Run Python in vertical split terminal

### LSP Keybindings

Set when LSP attaches to buffer (see `lua/rb/plugins/lsp/lspconfig.lua:241`):
- `gd` - Go to definition
- `gD` - Go to declaration
- `gr` - Go to references
- `gi` - Go to implementation
- `K` - Hover documentation
- `<C-k>` - Signature help
- `<leader>rn` - Rename symbol
- `<leader>ca` - Code action
- `<leader>f` - Format buffer
- `<leader>D` - Type definition

### Fuzzy Finding (Telescope)

- `<leader>ff` - Find files in cwd
- `<leader>fr` - Find recent files
- `<leader>fs` - Live grep (search in files)
- `<leader>fc` - Find string under cursor
- `<leader>ft` - Find TODO comments

### Formatting & Linting

- `<leader>mp` - Format file or range (manual trigger)
- `:ConformInfo` - Show available formatters for current buffer
- `<leader>ll` - Trigger linting manually

## Adding New Plugins

1. Create new file in `lua/rb/plugins/[plugin-name].lua`
2. Return lazy.nvim plugin spec:
```lua
return {
  "author/plugin-name",
  dependencies = { "other/plugin" },  -- optional
  event = "BufReadPre",  -- lazy-load trigger (optional)
  config = function()
    -- Plugin setup code
  end,
}
```
3. Restart Neovim - lazy.nvim will auto-install the plugin

## Adding New LSP Servers

1. Add server name to `ensure_installed` in `lua/rb/plugins/lsp/mason.lua`
2. Add server-specific config to `server_configs` in `lua/rb/plugins/lsp/lspconfig.lua`
3. Add server name to `servers` list in `lspconfig.lua`
4. Restart Neovim or run `:Lazy reload nvim-lspconfig`

## Leader Key

Leader key is set to `<Space>` in `lua/rb/core/keymaps.lua`.

## Special Configurations

- Line numbers toggle: `<leader>n` toggles between relative and absolute line numbers
- Fold method: Uses marker-based folding (start with folds closed)
- Clipboard: Integrated with system clipboard
- Split windows: Open to right and below
- No swap files
- jk in insert mode exits to normal mode
- Alt+j/k moves lines up/down in normal and visual modes
- Ctrl+d duplicates current line
