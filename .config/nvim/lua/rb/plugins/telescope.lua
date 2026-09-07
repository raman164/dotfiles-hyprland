return {
    "nvim-telescope/telescope.nvim",
    branch = "master",
    dependencies = {
        "nvim-lua/plenary.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        "nvim-tree/nvim-web-devicons",
        "folke/todo-comments.nvim",
    },
    config = function()
        local telescope = require("telescope")
        local actions = require("telescope.actions")
        local transform_mod = require("telescope.actions.mt").transform_mod

        local trouble = require("trouble")
        local trouble_telescope = require("trouble.sources.telescope")

        -- or create your custom action
        local custom_actions = transform_mod({
            open_trouble_qflist = function(prompt_bufnr)
                trouble.toggle("quickfix")
            end,
        })

        telescope.setup({
            defaults = {
                path_display = { "smart" },
                mappings = {
                    i = {
                        ["<C-k>"] = actions.move_selection_previous, -- move to prev result
                        ["<C-j>"] = actions.move_selection_next, -- move to next result
                        ["<C-q>"] = actions.send_selected_to_qflist + custom_actions.open_trouble_qflist,
                        ["<C-t>"] = trouble_telescope.open,
                    },
                },
            },
            extensions = {
                fzf = {
                    fuzzy = true, -- false will only do exact matching
                    override_generic_sorter = true, -- override the generic sorter
                    override_file_sorter = true, -- override the file sorter
                    case_mode = "smart_case", -- or "ignore_case" or "respect_case"
                },
            },
        })

        telescope.load_extension("fzf")

        -- set keymaps
        local keymap = vim.keymap -- for conciseness

        keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
        keymap.set("n", "<leader>fr", function()
            require("telescope.builtin").oldfiles({ previewer = false })
        end, { desc = "Fuzzy find recent files" })
        keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
        keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
        keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })
        keymap.set("n", "<leader>fb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", { desc = "Find in current buffer" })
        keymap.set("n", "<leader>fd", function()
            require("telescope.builtin").find_files({
                cwd = vim.fn.expand("%:p:h"),
            })
        end, { desc = "Find files in current directory" })
        keymap.set("n", "<leader>fD", function()
            require("telescope.builtin").live_grep({
                cwd = vim.fn.expand("%:p:h"),
            })
        end, { desc = "Grep in current directory" })

        vim.api.nvim_create_autocmd("User", {
            pattern = "VeryLazy",
            once = true,
            callback = function()
                local function warmup()
                    pcall(function()
                        require("telescope.builtin").find_files({
                            find_command = { "true" },
                            attach_mappings = function(prompt_bufnr)
                                vim.schedule(function()
                                    require("telescope.actions").close(prompt_bufnr)
                                end)
                                return true
                            end,
                        })
                    end)
                end

                vim.defer_fn(function()
                    if vim.bo.filetype ~= "alpha" and vim.bo.buftype == "" then
                        warmup()
                    else
                        local id
                        id = vim.api.nvim_create_autocmd("BufEnter", {
                            callback = function(args)
                                if vim.bo[args.buf].filetype ~= "alpha" and vim.bo[args.buf].buftype == "" then
                                    pcall(vim.api.nvim_del_autocmd, id)
                                    warmup()
                                end
                            end,
                        })
                    end
                end, 300)
            end,
        })

    end,
}
