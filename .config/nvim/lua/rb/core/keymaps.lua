vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- Typr keymaps
keymap.set("n", "<leader>tr", ":Typr<CR>", { desc = "Run Typr" })
keymap.set("n", "<leader>ts", ":TyprStats<CR>", { desc = "Run Typr Stats" })

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- increment
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement

-- same in visual mode: <C-a>/<C-x> alone are shadowed by the line-nav maps above,
-- so route the selection versions through the leader too.
-- (builtin g<C-a>/g<C-x> still work in visual for numbering a sequence 1,2,3...)
keymap.set("v", "<leader>+", "<C-a>", { desc = "Increment numbers in selection" })
keymap.set("v", "<leader>-", "<C-x>", { desc = "Decrement numbers in selection" })

-- macOS-style line navigation (Ctrl+A = start of line, Ctrl+E = end of line)
-- overrides default <C-a> (increment, still available via <leader>+) and <C-e> (scroll down)
keymap.set({ "n", "v" }, "<C-a>", "0", { desc = "Go to beginning of line" })
keymap.set({ "n", "v" }, "<C-e>", "$", { desc = "Go to end of line" })
keymap.set("i", "<C-a>", "<Home>", { desc = "Go to beginning of line" })
keymap.set("i", "<C-e>", "<End>", { desc = "Go to end of line" })

-- lazy and mason
keymap.set("n", "<leader>l", ":Lazy<CR>", { desc = ":lazy" })
keymap.set("n", "<leader>m", ":Mason<CR>", { desc = ":Mason" })

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

-- move the current split to a new position (also flips horizontal <-> vertical)
keymap.set("n", "<leader>sj", "<C-w>J", { desc = "Move split to bottom" })
keymap.set("n", "<leader>sk", "<C-w>K", { desc = "Move split to top" })
keymap.set("n", "<leader>sl", "<C-w>L", { desc = "Move split to right" })
keymap.set("n", "<leader>sH", "<C-w>H", { desc = "Move split to left" }) -- <leader>sh is taken by :split
keymap.set("n", "<leader>sw", "<C-w>x", { desc = "Swap split with next" })
keymap.set("n", "<leader>sr", "<C-w>r", { desc = "Rotate splits" })

-- toggle which side NEW splits open on (splitright/splitbelow)
keymap.set("n", "<leader>sd", function()
    vim.opt.splitright = not vim.opt.splitright:get()
    vim.opt.splitbelow = not vim.opt.splitbelow:get()
    local side = vim.opt.splitright:get() and "right/below" or "left/above"
    vim.notify("New splits open: " .. side)
end, { desc = "Toggle new-split direction" })

keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab

-- Move visually selected lines up or down in various modes
keymap.set("n", "<A-k>", ":m .-2<CR>==", { desc = "Move selected lines up or down", noremap = true })
keymap.set("n", "<A-j>", ":m .+1<CR>==", { desc = "Move selected lines up or down", noremap = true })
keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selected lines up or down", noremap = true })
keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selected lines up or down", noremap = true })

-- Copy line down (using <leader>d would conflict with diagnostics, so use <A-d>)
keymap.set("n", "<A-d>", ":t.<CR>", { desc = "Duplicate line down", noremap = true })

-- run code in terminal
keymap.set("n", "<leader>p", ":!python3 %<CR>")
keymap.set("n", "<leader>c", ":!g++ -Wall % && ./a.out<CR>")
keymap.set("n", "<leader>pm", ":w <CR>:vsp | terminal python3 % <CR>i")

-- quit = :q
keymap.set("n", "<leader>q", "<cmd>q<CR>")

-- ai keymap to run ai locally with hermes3 model
-- This works in both Normal and Visual mode
keymap.set({ "n", "v" }, "<leader>ai", ":Gen<CR>", { desc = "AI Generate" })
