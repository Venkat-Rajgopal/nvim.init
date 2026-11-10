-- vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = "File explorer (netrw)" })

-- Yank current line to system clipboard
vim.keymap.set("n", "<leader>y", '"+yy', { desc = "Yank line to clipboard" })

-- Yank visual selection to system clipboard
vim.keymap.set("v", "<leader>y", '"+y', { desc = "Yank selection to clipboard" })

-- Move between split windows with Ctrl-h/j/k/l instead of Ctrl-w h/j/k/l
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to window below" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to window above" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })
