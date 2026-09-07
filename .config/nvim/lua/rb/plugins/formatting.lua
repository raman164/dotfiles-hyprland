return {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local conform = require("conform")

        conform.setup({
            formatters_by_ft = {
                javascript = { "prettier" },
                typescript = { "prettier" },
                javascriptreact = { "prettier" },
                typescriptreact = { "prettier" },
                svelte = { "prettier" },
                css = { "prettier" },
                html = { "prettier" },
                json = { "prettier" },
                yaml = { "prettier" },
                markdown = { "prettier" },
                graphql = { "prettier" },
                liquid = { "prettier" },
                lua = { "stylua" },
                python = { "isort", "black" },
                cpp = { "clang-format" },
                c = { "clang-format" },
            },
            format_on_save = {
                lsp_fallback = true,
                async = false,
                timeout_ms = 1000,
            },
        })

        vim.keymap.set({ "n", "v" }, "<leader>mp", function()
            conform.format({
                lsp_fallback = true,
                async = false,
                timeout_ms = 1000,
            })
        end, { desc = "Format file or range (in visual mode)" })

        -- Add command to check available formatters
        vim.api.nvim_create_user_command("ConformInfo", function()
            local ft = vim.bo.filetype
            local formatters = conform.list_formatters(0)
            if #formatters == 0 then
                vim.notify("No formatters available for filetype: " .. ft, vim.log.levels.WARN)
            else
                local names = vim.tbl_map(function(f) return f.name end, formatters)
                vim.notify("Available formatters for " .. ft .. ": " .. table.concat(names, ", "))
            end
        end, { desc = "Show available formatters for current buffer" })
    end,
}
