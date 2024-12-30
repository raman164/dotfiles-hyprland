local map = vim.keymap.set
vim.g.mapleader = " "

-- Save current file
map("n", "<C-s>", "<cmd>w<cr>", { desc = "Save file", remap = true })

-- ESC pressing jk
map("i", "jk", "<ESC>", { desc = "jk to esc", noremap = true })

-- Quit Neovim
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit Buffer/Neovim", remap = true })

-- Increment/decrement
map("n", "+", "<C-a>", { desc = "Increment numbers", noremap = true })
map("n", "-", "<C-x>", { desc = "Decrement numbers", noremap = true })

-- Select all
map("n", "<C-a>", "gg<S-v>G", { desc = "Select all", noremap = true })

-- Indenting
map("v", "<", "<gv", { desc = "Indenting", silent = true, noremap = true })
map("v", ">", ">gv", { desc = "Indenting", silent = true, noremap = true })

-- New tab
map("n", "te", ":tabedit")

-- Split window
map("n", "<leader>sh", ":split<Return><C-w>w", { desc = "Split horizontal", noremap = true })
map("n", "<leader>sv", ":vsplit<Return><C-w>w", { desc = "Split vertical", noremap = true })

-- Navigate vim panes better
map("n", "<C-k>", "<C-w>k", { desc = "Navigate up" })
map("n", "<C-j>", "<C-w>j", { desc = "Navigate down" })
map("n", "<C-h>", "<C-w>h", { desc = "Navigate left" })
map("n", "<C-l>", "<C-w>l", { desc = "Navigate right" })

-- Change 2 split windows from vertical to horizontal or vice versa
map("n", "<leader>th", "<C-w>t<C-w>H", { desc = "Change window splits to horizontal", noremap = true})
map("n", "<leader>tk", "<C-w>t<C-w>K", { desc = "Change window splits to vertical", noremap = true})

-- Resize window
map("n", "<C-Up>", ":resize -3<CR>")
map("n", "<C-Down>", ":resize +3<CR>")
map("n", "<C-Left>", ":vertical resize -3<CR>")
map("n", "<C-Right>", ":vertical resize +3<CR>")

-- Move visually selected lines up or down in various modes
map("n", "<A-k>", ":m .-2<CR>==", { desc = "Move selected lines up or down", noremap = true})
map("n", "<A-j>", ":m .+1<CR>==", { desc = "Move selected lines up or down", noremap = true})
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selected lines up or down", noremap = true})
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selected lines up or down", noremap = true})

-- Copy line down
map("n", "<C-d>", ":t.p<CR>", { desc = "Move selected lines up or down", noremap = true})

-- C++ initialize
map("n", "<leader>cf", "i#include <iostream> <CR><CR> int main()<CR>{<CR><CR>return 0;<CR>}", { desc = "function", noremap = true})


-- Bufferline
map("n", "<S-l>", ":bnext<cr>", { desc = "Move to next tab", noremap = true })
map("n", "<S-h>", ":bprevious<cr>", { desc = "Move to previous tab", noremap = true })
map("n", "<leader>x", ":bd<cr>", { desc = "Close buffer", noremap = true })

-- Comments
-- map({"n", "v"}, "<leader>co", ":CommentToggle<cr>", { desc = "Comment line/block", noremap = true})

-- yank to clipboard
map({"n", "v"}, "<leader>y", [["+y]])

-- Telescope
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Telescope find files", noremap = true })
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Comment line", noremap = true })
map("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Comment line", noremap = true })
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Comment line", noremap = true })

-- run code in terminal with two ways
-- map("n", "<leader>cc", ":vsp | term g++ -Wall % && ./a.out<CR>")
-- map("n", "<leader>cm", ":w <CR> :!g++ % <CR> | :vsp |terminal ./a.out <CR>i")
-- map("n", "<leader>cm", ":w <CR> :!g++ % <CR> | :sp | resize -10 |terminal ./a.out <CR>i")
-- map("n", "<leader>pm", ":w <CR>:vsp | terminal python3 % <CR>i")
-- map("n", "<leader>pm", ":w <CR>:sp | resize -10 | terminal python3 % <CR>i")
map("n", "<leader>c", ":!g++ -Wall % && ./a.out<CR>")
map("n", "<leader>p", ":!python3 %<CR>")

-- clear search highlights
map("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- @g will run current file
vim.cmd [[
    augroup run_file
      autocmd BufEnter *.py let @g=":w\<CR>:vsp | terminal python3 %\<CR>i"  
      autocmd BufEnter *.cpp let @g=":w\<CR> :!g++ %\<CR> | :vsp |terminal ./a.out\<CR>i"  
    augroup end
]]
