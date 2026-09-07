-- llama.vim (ggml-org) — inline FIM ghost-text from the always-on llama.cpp server
-- on vm109's GPU (Qwen2.5-Coder-7B, port 8012). ~0.1-0.9s. This is the ONLY inline engine.
-- Accept full suggestion: <Tab>   |   accept one line: <S-Tab>   |   one word: <Alt+Right>
return {
  "ggml-org/llama.vim",
  event = "InsertEnter",
  init = function()
    -- Endpoint = vm109's GPU 7B by default. On the Mac, `llama-mode local` writes
    -- ~/.config/nvim/.llama_endpoint to point at its OWN local 7B when traveling offline.
    local function endpoint_fim()
      local f = vim.fn.expand("~/.config/nvim/.llama_endpoint")
      if vim.fn.filereadable(f) == 1 then
        local l = vim.fn.readfile(f)
        if l and l[1] and l[1] ~= "" then return (l[1]:gsub("%s+", "")) end
      end
      return "http://192.168.2.203:8012/infill"
    end
    vim.g.llama_config = {
      endpoint_fim = endpoint_fim(),
      auto_fim = true,
      n_prefix = 256,
      n_suffix = 64,
      n_predict = 64,
      show_info = 0,
      keymap_fim_accept_full = "<Tab>",   -- accept the whole suggestion
      keymap_fim_accept_line = "<S-Tab>", -- accept one line
      keymap_fim_accept_word = "<M-Right>", -- Alt+Right : accept one word at a time
    }
  end,
  config = function()
    -- ghost text should be subtle gray (like before), NOT orange/red.
    -- Link to Comment so it follows the Super+T theme; re-apply after each theme switch.
    local function gray()
      vim.api.nvim_set_hl(0, "llama_hl_fim_hint", { link = "Comment" })
    end
    gray()
    vim.api.nvim_create_autocmd("ColorScheme", { callback = gray })
  end,
}
