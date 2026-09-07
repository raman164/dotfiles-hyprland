return {
    "zbirenbaum/copilot.lua",
    enabled = false, -- OFF: fully on Tabby now (Copilot Free is gone) → stops the startup auth nag
    cmd = "Copilot",
    event = "VeryLazy",
    config = function()
        require("copilot").setup({
            suggestion = {
                enabled = true,
                auto_trigger = true,
                hide_during_completion = false,
                debounce = 75,
                keymap = {
                    accept = "<Tab>",
                    accept_word = "<M-Right>",
                    accept_line = "<M-l>",
                    next = "<M-]>",
                    prev = "<M-[>",
                    dismiss = "<C-]>",
                },
            },
            panel = { enabled = false },
            filetypes = {
                markdown = true,
                yaml = true,
                gitcommit = true,
                gitrebase = true,
                ["*"] = true,
            },
        })
    end,
}
