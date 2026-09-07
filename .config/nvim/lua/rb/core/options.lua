vim.cmd("let g:netrw_liststyle = 3")

local opt = vim.opt

opt.relativenumber = true
opt.number = true

-- tabs & indentation
opt.tabstop = 2 -- 2 spaces for tabs (prettier default)
opt.shiftwidth = 2 -- 2 spaces for indent width
opt.expandtab = true -- expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting new one

opt.wrap = false

-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- if you include mixed case in your search, assumes you want case-sensitive

opt.cursorline = true

-- folds (treesitter foldexpr is set per-buffer in plugins/treesitter.lua);
-- start every window with all folds open
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = true


-- turn on termguicolors for tokyonight colorscheme to work
-- (have to use iterm2 or any other true color terminal)
opt.termguicolors = true
opt.background = "dark" -- colorschemes that can be light or dark will be made dark
opt.signcolumn = "yes" -- show sign column so that text doesn't shift

-- backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- clipboard
opt.clipboard:append("unnamedplus") -- use system clipboard as default register

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

-- turn off swapfile
opt.swapfile = false

-- persistent undo
opt.undofile = true -- save undo history to file

-- shada: keep only 30 recent files (default 100) so Telescope oldfiles is fast
opt.shada = "!,'30,<50,s10,h,r/tmp/,r/private/"

-- remove the '~' marking on th eend of the buffer
-- opt.fillchars = {
--   eob = " ", -- remove the '~' marking on the end of the buffer
--   diff = "╱", -- use a different character for diff



-- auto-reload files when changed outside of vim
opt.autoread = true
opt.updatetime = 250 -- Faster CursorHold triggers (default is 4000ms)

-- Trigger autoread when files change on disk (more aggressive)
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  pattern = "*",
  callback = function()
    if vim.fn.mode() ~= "c" then
      vim.cmd("checktime")
    end
  end,
})

-- Additional timer-based check for truly live updates
local timer = vim.loop.new_timer()
timer:start(1000, 1000, vim.schedule_wrap(function()
  -- Check for file changes every 1 second
  if vim.fn.mode() ~= "c" and vim.fn.pumvisible() == 0 then
    vim.cmd("silent! checktime")
  end
end))

-- Notification when file changes (optional - comment out if annoying)
vim.api.nvim_create_autocmd("FileChangedShellPost", {
  pattern = "*",
  callback = function()
    -- Silent reload, no notification
    -- Uncomment below line if you want to see reload notifications:
    -- vim.notify("File changed on disk. Buffer reloaded!", vim.log.levels.INFO)
  end,
})
