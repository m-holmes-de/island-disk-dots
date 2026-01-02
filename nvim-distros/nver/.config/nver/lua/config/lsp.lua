vim.lsp.enable({ "luals", "pyright", "eslint-lsp", "typescript-language-server", "gopls", "vscode-html-language-server" })

-- Auto-Complete
-- vim.api.nvim_create_autocmd('LspAttach', {
--   callback = function(ev)
--     local client = vim.lsp.get_client_by_id(ev.data.client_id)
--     if client:supports_method('textDocument/completion') then
--       vim.opt.completeopt = { 'menu', 'menuone', 'noinsert', 'fuzzy', 'popup' }
--       vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
--       vim.keymap.set('i', '<C-Space>', function()
--           vim.lsp.completion.get()
--         end,
--         { desc = "Reopen Autocompletion" })
--     end
--   end,
-- })

-- Auto-Complete with blink-cmp (disable native auto-complete if using this)
local capabilities = require("blink.cmp").get_lsp_capabilities(original_capabilities)


-- Diagnostic Config
-- See :help vim.diagnostic.Opts
vim.diagnostic.config({
  severity_sort = true,
  float = { border = "rounded", source = "if_many" },
  underline = { severity = vim.diagnostic.severity.ERROR },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "󰅚 ",
      [vim.diagnostic.severity.WARN] = "󰀪 ",
      [vim.diagnostic.severity.INFO] = "󰋽 ",
      [vim.diagnostic.severity.HINT] = "󰌶 ",
    },
  },
  -- Use the default configuration
  virtual_lines = false,
  -- Alternatively, customize specific options
  virtual_text = {
    position = "eol",
    format = function(diagnostic)
      local diagnostic_message = {
        [vim.diagnostic.severity.ERROR] = diagnostic.message,
        [vim.diagnostic.severity.WARN] = diagnostic.message,
        [vim.diagnostic.severity.INFO] = diagnostic.message,
        [vim.diagnostic.severity.HINT] = diagnostic.message,
      }
      return diagnostic_message[diagnostic.severity]
    end,
  },
  -- virtual_lines = {
  --   -- Only show virtual line diagnostics for the current cursor line
  --   current_line = false,
  -- },
})
