-- vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- Yank current line to system clipboard
vim.keymap.set("n", "<leader>y", '"+yy', { desc = "Yank line to clipboard" })

-- Yank visual selection to system clipboard
vim.keymap.set("v", "<leader>y", '"+y', { desc = "Yank selection to clipboard" })

