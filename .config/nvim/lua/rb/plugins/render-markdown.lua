return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    ft = { "markdown" },
    config = function()
      require("render-markdown").setup({
        completions = { lsp = { enabled = true } },
        heading = { backgrounds = {} },
        code = {
          style = "language",
          highlight = "Normal",
          highlight_inline = "Normal",
        },
      })

      local function recolor()
        local blue = { fg = "#1e66f5" }
        vim.api.nvim_set_hl(0, "RenderMarkdownH4", blue)
        vim.api.nvim_set_hl(0, "@markup.heading.4.markdown", blue)
        vim.api.nvim_set_hl(0, "rainbow4", blue)
      end
      recolor()
      vim.api.nvim_create_autocmd({ "ColorScheme", "FileType" }, {
        pattern = { "*", "markdown" },
        callback = recolor,
      })
    end,
  },
}
