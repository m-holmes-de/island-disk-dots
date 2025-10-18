-- Window navigation is handled by vim-tmux-navigator plugin
-- See `:help wincmd` for a list of all window commands

-- Better buffer navigation
vim.keymap.set("n", "<S-l>", ":bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<S-h>", ":bprevious<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "<leader>jk", ":bdelete<CR>", { desc = "Delete buffer" })

-- Resize panes
-- Resize panes with arrow keys
vim.keymap.set('n', '<leader><Up>', ':resize +2<CR>', { silent = true })
vim.keymap.set('n', '<leader><Down>', ':resize -2<CR>', { silent = true })
vim.keymap.set('n', '<leader><Left>', ':vertical resize -2<CR>', { silent = true })
vim.keymap.set('n', '<leader><Right>', ':vertical resize +2<CR>', { silent = true })

-- Stay in indent mode
vim.keymap.set("v", "<", "<gv", { desc = "Indent right", noremap = true, silent = true })
vim.keymap.set("v", ">", ">gv", { desc = "Indent left", noremap = true, silent = true })

-- source on the fly
-- vim.keymap.set("n", "<space><space>x", "<cmd>source %<CR>")
vim.keymap.set("n", "<space>x", ":.lua<CR>")
vim.keymap.set("v", "<space>x", ":lua<CR>")

-- better yanking ;)
vim.keymap.set("v", "<leader>yp", ":'<,'>y+<CR>", { desc = "[Y]ank to [P]lus" })

-- use jk to exist insert mode
vim.keymap.set('i', 'jk', '<Esc>', { noremap = true })
