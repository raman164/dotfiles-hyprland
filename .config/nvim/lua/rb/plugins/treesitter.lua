return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  dependencies = {
    "windwp/nvim-ts-autotag",
  },
  config = function()
    local ts = require("nvim-treesitter")

    ts.setup({
      install_dir = vim.fn.stdpath("data") .. "/site",
    })

    local desired = {
      "json", "javascript", "typescript", "tsx", "yaml", "html", "css",
      "prisma", "markdown", "markdown_inline", "svelte", "graphql",
      "bash", "lua", "vim", "dockerfile", "gitignore", "query",
      "vimdoc", "c", "cpp", "python",
    }
    -- Only call install for parsers whose .so isn't already on disk.
    -- ts.install otherwise re-checks revisions on every startup, which
    -- shows progress messages and slows things down.
    local parser_dir = vim.fn.stdpath("data") .. "/site/parser"
    local have = {}
    for _, f in ipairs(vim.fn.readdir(parser_dir) or {}) do
      local lang = f:match("^(.+)%.so$")
      if lang then have[lang] = true end
    end
    local missing = {}
    for _, lang in ipairs(desired) do
      if not have[lang] then table.insert(missing, lang) end
    end
    if #missing > 0 then
      ts.install(missing)
    end

    vim.api.nvim_create_autocmd("FileType", {
      callback = function(args)
        local buf = args.buf
        local lang = vim.treesitter.language.get_lang(vim.bo[buf].filetype)
        if lang and pcall(vim.treesitter.start, buf, lang) then
          if vim.bo[buf].filetype == "markdown" then
            vim.wo.foldmethod = "marker"
            vim.wo.foldlevel = 0
          else
            vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
            vim.wo.foldmethod = "expr"
          end
          vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })

    require("nvim-ts-autotag").setup()
  end,
}
