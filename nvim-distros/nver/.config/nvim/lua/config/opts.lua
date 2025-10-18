--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Disable netrw at the very start of init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Disable netrw at the very start of init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- views can only be fully collapsed with the global statusline
vim.opt.laststatus = 3

-- show numbers like a boss
vim.opt.number = true
vim.opt.relativenumber = true

-- Default tab settings
vim.opt.shiftwidth = 4

-- copied text available in systemclipboard
vim.opt.clipboard = "unnamedplus"

-- disable wrapping
vim.opt.wrap = false

-- Show the mode or don't show mode, since it's already in status line
vim.opt.showmode = true

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- space for the command line (0 for remove, 1 for normal height)
vim.opt.cmdheight = 0

-- Keep cursor centered when paging up/down
vim.keymap.set("n", "<C-f>", "<C-f>zz")
vim.keymap.set("n", "<C-b>", "<C-b>zz")

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Save undo history
vim.opt.undofile = true

-- Set the default border for all floating windows
vim.opt.winborder = 'rounded'
