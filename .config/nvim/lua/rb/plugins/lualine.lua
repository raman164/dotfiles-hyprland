return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local lualine = require("lualine")
    local lazy_status = require("lazy.status") -- to configure lazy pending updates count

    -- Follow the desktop theme (same marker colorscheme.lua reads).
    -- The dark branch below is the ORIGINAL table, byte for byte - the default
    -- theme is unchanged; only the paperlike branch is new.
    local function desktop_theme()
      local tf = vim.fn.expand("~/.config/nvim/current_theme")
      if vim.fn.filereadable(tf) == 1 then
        local l = vim.fn.readfile(tf)
        if l and l[1] then return vim.trim(l[1]) end
      end
      return "default"
    end

    local colors
    if desktop_theme() == "paperlike" then
      -- identical palette to the syntax highlights and the foot terminal
      colors = {
        blue = "#0055d4",
        green = "#007700",
        violet = "#a800a8",
        yellow = "#846600",
        red = "#cc0000",
        fg = "#2d2d2d",
        bg = "#e4e4e4",
        inactive_bg = "#eeeeee",
        semilightgray = "#7a7a7a",
      }
    else
      colors = {
        blue = "#65D1FF",
        green = "#3EFFDC",
        violet = "#FF61EF",
        yellow = "#FFDA7B",
        red = "#FF4A4A",
        fg = "#c3ccdc",
        bg = "#112638",
        inactive_bg = "#2c3043",
      }
    end

    local my_lualine_theme = {
      normal = {
        a = { bg = colors.blue, fg = colors.bg, gui = "bold" },
        b = { bg = colors.bg, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
      },
      insert = {
        a = { bg = colors.green, fg = colors.bg, gui = "bold" },
        b = { bg = colors.bg, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
      },
      visual = {
        a = { bg = colors.violet, fg = colors.bg, gui = "bold" },
        b = { bg = colors.bg, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
      },
      command = {
        a = { bg = colors.yellow, fg = colors.bg, gui = "bold" },
        b = { bg = colors.bg, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
      },
      replace = {
        a = { bg = colors.red, fg = colors.bg, gui = "bold" },
        b = { bg = colors.bg, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
      },
      inactive = {
        a = { bg = colors.inactive_bg, fg = colors.semilightgray, gui = "bold" },
        b = { bg = colors.inactive_bg, fg = colors.semilightgray },
        c = { bg = colors.inactive_bg, fg = colors.semilightgray },
      },
    }

    -- vm103-matched: its lualine runs theme="auto" over PaperColor. These are the
    -- exact resolved values, so the two machines' statuslines are identical.
    if desktop_theme() == "paperlike" then
      local paper = { bar = "#f5f5f5", txt = "#4d4d4c", lite = "#efefef",
                      teal = "#3e999f", blue = "#005f87", ins = "#4271ae",
                      orange = "#d75f00", pink = "#d7005f" }
      local bc = { b = { bg = paper.teal, fg = paper.lite },
                   c = { bg = paper.blue, fg = paper.lite } }
      my_lualine_theme = {
        normal   = { a = { bg = paper.bar,    fg = paper.txt,  gui = "bold" }, b = bc.b, c = bc.c },
        insert   = { a = { bg = paper.bar,    fg = paper.ins,  gui = "bold" }, b = bc.b, c = bc.c },
        visual   = { a = { bg = paper.orange, fg = paper.bar,  gui = "bold" }, b = bc.b, c = bc.c },
        replace  = { a = { bg = paper.pink,   fg = paper.bar,  gui = "bold" }, b = bc.b, c = bc.c },
        command  = { a = { bg = paper.bar,    fg = paper.txt,  gui = "bold" }, b = bc.b, c = bc.c },
        inactive = { a = { bg = paper.bar,    fg = paper.txt },
                     b = { bg = paper.bar,    fg = paper.txt },
                     c = { bg = paper.bar,    fg = paper.txt } },
      }
    end

    -- configure lualine with modified theme
    lualine.setup({
      options = {
        theme = my_lualine_theme,
      },
      sections = {
        lualine_x = {
          {
            lazy_status.updates,
            cond = lazy_status.has_updates,
            color = { fg = "#ff9e64" },
          },
          { "encoding" },
          { "fileformat" },
          { "filetype" },
        },
      },
    })
  end,
}
