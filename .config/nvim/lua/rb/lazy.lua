local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({ { import = "rb.plugins" }, { import = "rb.plugins.lsp" } }, {
  checker = {
    -- Background plugin update check; off to avoid post-startup git fetches.
    -- Run :Lazy check manually when you want to see updates.
    enabled = false,
    notify = false,
  },
  change_detection = {
    notify = false,
  },
})
