return {
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
            vim.cmd("colorscheme vaporwave")
        end,
    },
}
