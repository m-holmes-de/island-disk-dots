-- VSCode Neovim Init Configuration
-- This file is loaded by the VSCode Neovim extension

-- Set leader key to space
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Basic options
vim.opt.clipboard = "unnamedplus" -- Use system clipboard
vim.opt.ignorecase = true -- Case insensitive searching
vim.opt.smartcase = true -- Case sensitive if capital letter in search
vim.opt.hlsearch = true -- Highlight search results
vim.opt.incsearch = true -- Incremental search

-- Relative line numbers are handled by VSCode settings
-- but we can ensure compatibility
vim.opt.number = true
vim.opt.relativenumber = true

-- Better navigation
vim.opt.scrolloff = 8 -- Keep 8 lines visible above/below cursor

-- ============================================================================
-- Keymaps for VSCode Integration
-- ============================================================================

local function vscode_action(action)
    return function()
        require("vscode-neovim").action(action)
    end
end

local function vscode_call(command)
    return function()
        require("vscode-neovim").call(command)
    end
end

-- ============================================================================
-- General Editor Navigation
-- ============================================================================

-- Clear search highlighting
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })

-- Better window navigation (Ctrl+hjkl) - works with vim-tmux-navigator style
-- These integrate with your VSCode keybindings for Ctrl+h/l
vim.keymap.set("n", "<C-h>", vscode_action("workbench.action.navigateLeft"), { desc = "Navigate left" })
vim.keymap.set("n", "<C-l>", vscode_action("workbench.action.navigateRight"), { desc = "Navigate right" })
vim.keymap.set("n", "<C-j>", vscode_action("workbench.action.navigateDown"), { desc = "Navigate down" })
vim.keymap.set("n", "<C-k>", vscode_action("workbench.action.navigateUp"), { desc = "Navigate up" })

-- Navigate between tabs/editors
vim.keymap.set("n", "<C-S-h>", vscode_action("workbench.action.previousEditor"), { desc = "Previous tab" })
vim.keymap.set("n", "<C-S-l>", vscode_action("workbench.action.nextEditor"), { desc = "Next tab" })

-- ============================================================================
-- Leader Key Commands
-- ============================================================================

-- File operations
vim.keymap.set("n", "<leader>ff", vscode_action("workbench.action.quickOpen"), { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", vscode_action("workbench.action.findInFiles"), { desc = "Find in files (grep)" })
vim.keymap.set("n", "<leader>fw", vscode_action("workbench.action.findInFiles"), { desc = "Find word" })
vim.keymap.set("n", "<leader>fr", vscode_action("workbench.action.openRecent"), { desc = "Recent files" })
vim.keymap.set("n", "<leader>fs", vscode_action("workbench.action.files.save"), { desc = "Save file" })
vim.keymap.set("n", "<leader>fa", vscode_action("workbench.action.files.saveAll"), { desc = "Save all" })

-- Explorer/File tree
vim.keymap.set("n", "<leader>e", vscode_action("workbench.action.toggleSidebarVisibility"), { desc = "Toggle explorer" })
vim.keymap.set("n", "<leader>o", vscode_action("workbench.view.explorer"), { desc = "Focus explorer" })

-- Buffer/Tab management
vim.keymap.set("n", "<leader>bd", vscode_action("workbench.action.closeActiveEditor"), { desc = "Close buffer" })
vim.keymap.set("n", "<leader>bD", vscode_action("workbench.action.closeOtherEditors"), { desc = "Close other buffers" })
vim.keymap.set("n", "<leader>bn", vscode_action("workbench.action.nextEditor"), { desc = "Next buffer" })
vim.keymap.set("n", "<leader>bp", vscode_action("workbench.action.previousEditor"), { desc = "Previous buffer" })
vim.keymap.set("n", "<leader>bb", vscode_action("workbench.action.showAllEditors"), { desc = "Show all buffers" })

-- Git operations
vim.keymap.set("n", "<leader>gg", vscode_action("workbench.view.scm"), { desc = "Git status" })
vim.keymap.set("n", "<leader>gc", vscode_action("git.commit"), { desc = "Git commit" })
vim.keymap.set("n", "<leader>gp", vscode_action("git.push"), { desc = "Git push" })
vim.keymap.set("n", "<leader>gP", vscode_action("git.pull"), { desc = "Git pull" })
vim.keymap.set("n", "<leader>gb", vscode_action("git.branch"), { desc = "Git branches" })
vim.keymap.set("n", "<leader>gd", vscode_action("git.openChange"), { desc = "Git diff" })

-- Code actions
vim.keymap.set("n", "<leader>ca", vscode_action("editor.action.quickFix"), { desc = "Code actions" })
vim.keymap.set("n", "<leader>cr", vscode_action("editor.action.rename"), { desc = "Rename" })
vim.keymap.set("n", "<leader>cf", vscode_action("editor.action.formatDocument"), { desc = "Format document" })
vim.keymap.set("v", "<leader>cf", vscode_action("editor.action.formatSelection"), { desc = "Format selection" })

-- LSP/Navigation
vim.keymap.set("n", "gd", vscode_action("editor.action.revealDefinition"), { desc = "Go to definition" })
vim.keymap.set("n", "gD", vscode_action("editor.action.revealDeclaration"), { desc = "Go to declaration" })
vim.keymap.set("n", "gi", vscode_action("editor.action.goToImplementation"), { desc = "Go to implementation" })
vim.keymap.set("n", "gr", vscode_action("editor.action.goToReferences"), { desc = "Go to references" })
vim.keymap.set("n", "gt", vscode_action("editor.action.goToTypeDefinition"), { desc = "Go to type definition" })
vim.keymap.set("n", "K", vscode_action("editor.action.showHover"), { desc = "Show hover" })
vim.keymap.set("n", "<leader>cs", vscode_action("workbench.action.gotoSymbol"), { desc = "Go to symbol" })
vim.keymap.set("n", "<leader>cS", vscode_action("workbench.action.showAllSymbols"), { desc = "Workspace symbols" })

-- Diagnostics/Problems
vim.keymap.set("n", "<leader>xx", vscode_action("workbench.actions.view.problems"), { desc = "Show problems" })
vim.keymap.set("n", "[d", vscode_action("editor.action.marker.prev"), { desc = "Previous diagnostic" })
vim.keymap.set("n", "]d", vscode_action("editor.action.marker.next"), { desc = "Next diagnostic" })

-- Search
vim.keymap.set("n", "<leader>ss", vscode_action("workbench.action.findInFiles"), { desc = "Search in files" })
vim.keymap.set("n", "<leader>sw", vscode_action("workbench.action.findInFiles"), { desc = "Search word" })

-- Terminal
vim.keymap.set("n", "<leader>tt", vscode_action("workbench.action.togglePanel"), { desc = "Toggle terminal" })
vim.keymap.set("n", "<leader>tn", vscode_action("workbench.action.terminal.new"), { desc = "New terminal" })
vim.keymap.set("n", "<leader>tf", vscode_action("workbench.action.terminal.focus"), { desc = "Focus terminal" })

-- Window/Panel management
vim.keymap.set("n", "<leader>w", vscode_action("workbench.action.closeWindow"), { desc = "Close window" })
vim.keymap.set("n", "<leader>q", vscode_action("workbench.action.closeActiveEditor"), { desc = "Close editor" })
vim.keymap.set("n", "<leader>Q", vscode_action("workbench.action.closeAllEditors"), { desc = "Close all editors" })

-- Split management
vim.keymap.set("n", "<leader>sv", vscode_action("workbench.action.splitEditor"), { desc = "Split vertically" })
vim.keymap.set("n", "<leader>sh", vscode_action("workbench.action.splitEditorDown"), { desc = "Split horizontally" })

-- Command palette
vim.keymap.set("n", "<leader>:", vscode_action("workbench.action.showCommands"), { desc = "Command palette" })
vim.keymap.set("n", "<leader>p", vscode_action("workbench.action.showCommands"), { desc = "Command palette" })

-- ============================================================================
-- Additional Useful Keymaps
-- ============================================================================

-- Better indenting in visual mode
vim.keymap.set("v", "<", "<gv", { desc = "Indent left" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right" })

-- Move lines up and down
vim.keymap.set("n", "<A-j>", vscode_action("editor.action.moveLinesDownAction"), { desc = "Move line down" })
vim.keymap.set("n", "<A-k>", vscode_action("editor.action.moveLinesUpAction"), { desc = "Move line up" })
vim.keymap.set("v", "<A-j>", vscode_action("editor.action.moveLinesDownAction"), { desc = "Move lines down" })
vim.keymap.set("v", "<A-k>", vscode_action("editor.action.moveLinesUpAction"), { desc = "Move lines up" })

-- Commenting (VSCode has built-in commenting)
vim.keymap.set("n", "<leader>/", vscode_action("editor.action.commentLine"), { desc = "Toggle comment" })
vim.keymap.set("v", "<leader>/", vscode_action("editor.action.commentLine"), { desc = "Toggle comment" })
vim.keymap.set("n", "gcc", vscode_action("editor.action.commentLine"), { desc = "Toggle comment" })
vim.keymap.set("v", "gc", vscode_action("editor.action.commentLine"), { desc = "Toggle comment" })

-- Better copy/paste
vim.keymap.set("v", "p", '"_dP', { desc = "Paste without yanking" })

-- Quick save
vim.keymap.set("n", "<C-s>", vscode_action("workbench.action.files.save"), { desc = "Save file" })

-- Folding
vim.keymap.set("n", "za", vscode_action("editor.toggleFold"), { desc = "Toggle fold" })
vim.keymap.set("n", "zM", vscode_action("editor.foldAll"), { desc = "Fold all" })
vim.keymap.set("n", "zR", vscode_action("editor.unfoldAll"), { desc = "Unfold all" })

-- Zen mode
vim.keymap.set("n", "<leader>z", vscode_action("workbench.action.toggleZenMode"), { desc = "Toggle Zen mode" })

-- ============================================================================
-- Better defaults for editing
-- ============================================================================

-- Keep cursor centered when scrolling
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result centered" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result centered" })

-- Better join lines
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines" })

-- ============================================================================
-- Text objects and motions
-- ============================================================================

-- Select all
vim.keymap.set("n", "<leader>sa", "ggVG", { desc = "Select all" })

-- Move to beginning/end of line
vim.keymap.set({"n", "v"}, "H", "^", { desc = "Go to beginning of line" })
vim.keymap.set({"n", "v"}, "L", "$", { desc = "Go to end of line" })

print("VSCode Neovim configuration loaded!")
