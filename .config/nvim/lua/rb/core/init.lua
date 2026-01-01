require("rb.core.options")
require("rb.core.keymaps")

-- For Pyright
-- require('lspconfig').pyright.setup({})

-- OR for pylsp
-- require('lspconfig').pylsp.setup({})

-- COMPLETELY reset diagnostic settings
vim.diagnostic.reset()

-- Then configure modern diagnostics
-- vim.diagnostic.config({
--   signs = true,  -- Let Neovim handle gutter signs
--   virtual_text = { prefix = "■" },  -- Customize if needed
--   underline = true,
--   update_in_insert = false,
-- })



vim.opt.foldmethod = "marker"  -- Use marker-based folding
vim.opt.foldlevel = 0     -- Start with folds closed



-- Toggle between relative and normal line numbers
vim.keymap.set('n', '<leader>n', function()
  if vim.wo.relativenumber then
    vim.wo.relativenumber = false
    vim.wo.number = true
    print("Normal line numbers")
  else
    vim.wo.relativenumber = true
    vim.wo.number = true
    print("Relative line numbers")
  end
end, { desc = "Toggle relative/normal line numbers" })
