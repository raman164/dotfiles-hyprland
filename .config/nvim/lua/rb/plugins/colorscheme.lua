return {
    {
        -- vm103 uses catppuccin-latte for its light theme; installed here so the
        -- laptop's paperlike matches it exactly. priority > onedarkpro so it is
        -- loaded before the config below picks a colorscheme.
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1001,
        lazy = false,
    },
    {
        "olimorris/onedarkpro.nvim",
        priority = 1000,
        build = "make extras",
        config = function()
            require("onedarkpro").setup({
                colors = {
                    vaporwave = {
                        codeblock = "require('onedarkpro.helpers').lighten('bg', 2, 'vaporwave')",
                        statusline_bg = "require('onedarkpro.helpers').lighten('bg', 4, 'vaporwave')", -- gray
                        statuscolumn_border = "require('onedarkpro.helpers').lighten('bg', 4, 'vaporwave')", -- gray
                        ellipsis = "require('onedarkpro.helpers').lighten('bg', 4, 'vaporwave')", -- gray
                        picker_results = "require('onedarkpro.helpers').darken('bg', 4, 'vaporwave')",
                        picker_selection = "require('onedarkpro.helpers').darken('bg', 8, 'vaporwave')",
                        copilot = "require('onedarkpro.helpers').darken('gray', 8, 'vaporwave')",
                        breadcrumbs = "require('onedarkpro.helpers').darken('gray', 10, 'vaporwave')",
                        light_gray = "require('onedarkpro.helpers').darken('gray', 7, 'vaporwave')",
                    },
                    onedark = {
                        codeblock = "require('onedarkpro.helpers').lighten('bg', 2, 'onedark')",
                        statusline_bg = "#2e323b", -- gray
                        statuscolumn_border = "#4b5160", -- gray
                        ellipsis = "#808080", -- gray
                        picker_results = "require('onedarkpro.helpers').darken('bg', 4, 'onedark')",
                        picker_selection = "require('onedarkpro.helpers').darken('bg', 8, 'onedark')",
                        copilot = "require('onedarkpro.helpers').darken('gray', 8, 'onedark')",
                        breadcrumbs = "require('onedarkpro.helpers').darken('gray', 10, 'onedark')",
                        light_gray = "require('onedarkpro.helpers').darken('gray', 7, 'onedark')",
                    },
                    light = {
                        codeblock = "require('onedarkpro.helpers').darken('bg', 3, 'onelight')",
                        comment = "#bebebe", -- Revert back to original comment colors
                        statusline_bg = "#f0f0f0", -- gray
                        statuscolumn_border = "#e7e7e7", -- gray
                        ellipsis = "#808080", -- gray
                        git_add = "require('onedarkpro.helpers').get_preloaded_colors('onelight').green",
                        git_change = "require('onedarkpro.helpers').get_preloaded_colors('onelight').yellow",
                        git_delete = "require('onedarkpro.helpers').get_preloaded_colors('onelight').red",
                        picker_results = "require('onedarkpro.helpers').darken('bg', 5, 'onelight')",
                        picker_selection = "require('onedarkpro.helpers').darken('bg', 9, 'onelight')",
                        copilot = "require('onedarkpro.helpers').lighten('gray', 8, 'onelight')",
                        breadcrumbs = "require('onedarkpro.helpers').lighten('gray', 8, 'onelight')",
                        light_gray = "require('onedarkpro.helpers').lighten('gray', 10, 'onelight')",
                    },
                    rainbow = {
                        "${green}",
                        "${blue}",
                        "${purple}",
                        "${red}",
                        "${orange}",
                        "${yellow}",
                        "${cyan}",
                    },
                },
                highlights = {
                    -- [All your highlight groups remain unchanged]
                },
                caching = false,
                cache_path = vim.fn.expand(vim.fn.stdpath("cache") .. "/onedarkpro_dotfiles"),
                plugins = {
                    barbar = false,
                    lsp_saga = false,
                    marks = false,
                    polygot = false,
                    startify = false,
                    telescope = false,
                    trouble = false,
                    vim_ultest = false,
                    which_key = false,
                },
                styles = {
                    tags = "italic",
                    methods = "bold",
                    functions = "bold",
                    keywords = "italic",
                    comments = "italic",
                    parameters = "italic",
                    conditionals = "italic",
                    virtual_text = "italic",
                },
                options = {
                    cursorline = true,
                    transparency = true,
                    -- highlight_inactive_windows = true,
                },
            })
            -- Follow the desktop theme. ~/.config/nvim/current_theme is written by
            -- the `paperlike` / `paperlike-revert` scripts; absent = dark default.
            -- onedarkpro runs transparency=true, so nvim inherits the terminal bg;
            -- a dark palette on a light terminal is what looked washed out.
            local tf = vim.fn.expand("~/.config/nvim/current_theme")
            local desktop = "default"
            if vim.fn.filereadable(tf) == 1 then
                local lines = vim.fn.readfile(tf)
                if lines and lines[1] then desktop = vim.trim(lines[1]) end
            end
            if desktop == "paperlike" then
                vim.opt.background = "light"
                vim.cmd("colorscheme onelight")
                -- onelight targets a white #fafafa bg. On this theme's #eeeeee it is
                -- washed out (Type/PreProc 1.76:1; 8 of 18 groups under 3:1), so
                -- repaint with the palette the terminal uses - all >= 4.6:1.
                local P = {
                    fg = "#2d2d2d", comment = "#666666", red = "#e00000",
                    green = "#007c00", amber = "#d75f00", blue = "#0055d4",
                    magenta = "#a800a8", cyan = "#007070", gutter = "#7a7a7a", param = "#cf2b2b",
                }
                local function fix_light_hl()
                    local set = vim.api.nvim_set_hl
                    set(0, "Normal", { fg = P.fg })
                    set(0, "Comment", { fg = P.comment, italic = true })
                    set(0, "String", { fg = P.green })
                    set(0, "Character", { fg = P.green })
                    set(0, "Number", { fg = P.magenta })
                    set(0, "Float", { fg = P.magenta })
                    set(0, "Boolean", { fg = P.magenta })
                    set(0, "Constant", { fg = P.magenta })
                    set(0, "Identifier", { fg = P.fg })
                    set(0, "Function", { fg = P.blue, bold = true })
                    set(0, "Statement", { fg = P.red })
                    set(0, "Keyword", { fg = P.red })
                    set(0, "Conditional", { fg = P.red })
                    set(0, "Repeat", { fg = P.red })
                    set(0, "Operator", { fg = P.fg })
                    set(0, "PreProc", { fg = P.cyan })
                    set(0, "Include", { fg = P.cyan })
                    set(0, "Type", { fg = P.amber })
                    set(0, "StorageClass", { fg = P.amber })
                    set(0, "Special", { fg = P.magenta })
                    set(0, "LineNr", { fg = P.gutter })
                    -- markdown headings: onelight left H1 at 2.69:1. Distinct hue
                    -- per level, bold, 4.66-5.60:1.
                    -- onelight kept these: green #1da912 (2.69:1) on git/diff/
                    -- diagnostics, Question #bebebe (1.60:1), Search #eea825 (1.76:1).
                    for _, n in ipairs({ "GitSignsAdd", "diffAdded", "Added",
                                         "@diff.plus", "MoreMsg", "DiagnosticOk",
                                         "DiffAdd" }) do
                        set(0, n, { fg = P.green })
                    end
                    set(0, "Question",  { fg = P.green })
                    set(0, "Directory", { fg = P.blue, bold = true })
                    set(0, "Search",    { fg = P.fg, bg = "#f7d16a" })
                    set(0, "IncSearch", { fg = "#eeeeee", bg = P.red })
                    set(0, "DiagnosticError", { fg = P.red })
                    set(0, "DiagnosticWarn",  { fg = P.amber })
                    set(0, "DiagnosticInfo",  { fg = P.blue })
                    set(0, "DiagnosticHint",  { fg = P.cyan })
                    local heads = { P.red, P.blue, P.green, P.magenta, P.cyan, P.amber }
                    for i, col in ipairs(heads) do
                        set(0, "@markup.heading." .. i .. ".markdown", { fg = col, bold = true })
                        set(0, "markdownH" .. i, { fg = col, bold = true })
                        set(0, "RenderMarkdownH" .. i, { fg = col, bold = true })
                    end
                    set(0, "@markup.heading", { fg = P.red, bold = true })
                    set(0, "Title", { fg = P.red, bold = true })
                    set(0, "@markup.raw", { fg = P.cyan })
                    -- legacy alias treesitter still uses for markdown inline code
                    -- (`like this`) - onelight left it at #1da912 = 2.69:1
                    set(0, "@text.literal.markdown_inline", { fg = P.green })
                    set(0, "@markup.raw.markdown_inline", { fg = P.green })
                    set(0, "@markup.raw.block", { fg = P.cyan })
                    set(0, "@markup.link", { fg = P.blue, underline = true })
                    set(0, "@markup.link.label", { fg = P.blue })
                    set(0, "@markup.list", { fg = P.red })
                    set(0, "@markup.strong", { fg = P.fg, bold = true })
                    set(0, "@markup.italic", { fg = P.fg, italic = true })
                    -- markdown surface groups onelight still owned - the ones
                    -- actually visible in a notes buffer: bullets #ee9025 2.09:1,
                    -- list markers #eea825 1.76:1, quotes/backticks/folds #bebebe
                    -- 1.60:1, params #e05661 3.19:1.
                    set(0, "RenderMarkdownBullet", { fg = P.amber })
                    set(0, "RenderMarkdownDash", { fg = P.amber })
                    set(0, "@markup.list.markdown", { fg = P.red })
                    set(0, "@markup.list.checked", { fg = P.green })
                    set(0, "@markup.strong.markdown_inline", { fg = P.fg, bold = true })
                    set(0, "@text.strong.markdown_inline", { fg = P.fg, bold = true })
                    set(0, "@markup.italic.markdown_inline", { fg = P.fg, italic = true })
                    set(0, "@markup.quote.markdown", { fg = P.comment, italic = true })
                    set(0, "@markup.raw.delimiter", { fg = P.comment })
                    set(0, "@markup.raw.delimiter.markdown_inline", { fg = P.comment })
                    set(0, "@punctuation.special.markdown", { fg = P.amber })
                    set(0, "@markup.link.url", { fg = P.blue, underline = true })
                    set(0, "@text.uri.markdown_inline", { fg = P.blue, underline = true })
                    set(0, "@text.reference.markdown_inline", { fg = P.blue })
                    set(0, "@markup.heading.7.markdown", { fg = P.amber, bold = true })
                    set(0, "RenderMarkdownH7", { fg = P.amber, bold = true })
                    set(0, "RenderMarkdownTableRow", { fg = P.fg })
                    set(0, "RenderMarkdownTableHead", { fg = P.blue, bold = true })
                    set(0, "Folded", { fg = P.comment })
                    set(0, "FoldedNC", { fg = P.comment })
                    set(0, "SpecialComment", { fg = P.comment, italic = true })
                    -- these were rosy red #e05661; flattening them to fg turned
                    -- usbnet / -r / -a black. Keep them red, just brighter.
                    set(0, "@variable.parameter", { fg = P.param })
                    set(0, "@variable.parameter.c", { fg = P.param })
                    set(0, "@parameter", { fg = P.param })
                    set(0, "@variable.member", { fg = P.blue })
                    set(0, "@string.special.symbol", { fg = P.blue })
                    for from, to in pairs({
                        ["@comment"] = "Comment", ["@string"] = "String",
                        ["@number"] = "Number", ["@boolean"] = "Boolean",
                        ["@constant"] = "Constant", ["@function"] = "Function",
                        ["@function.call"] = "Function", ["@keyword"] = "Keyword",
                        ["@type"] = "Type", ["@variable"] = "Identifier",
                        ["@property"] = "Function", ["@field"] = "Function",
                        ["@operator"] = "Operator", ["@punctuation.bracket"] = "Normal",
                    }) do set(0, from, { link = to }) end
                end
                fix_light_hl()

                vim.api.nvim_create_autocmd("ColorScheme", {
                    pattern = "onelight", callback = fix_light_hl,
                })
            else
                vim.opt.background = "dark"
                vim.cmd("colorscheme vaporwave")
            end
        end,
    },
}
