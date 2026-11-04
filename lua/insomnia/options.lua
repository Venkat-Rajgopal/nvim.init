local opt = vim.opt

-- Line numbers
opt.number = true -- Enable line numbers
opt.relativenumber = true -- Enable relative line numbers

-- Indentation
opt.expandtab = true -- Spaces instead of tabs
opt.shiftwidth = 4
opt.tabstop = 4
opt.autoindent = true
opt.smartindent = true

-- Search
opt.ignorecase = true -- Case-insensitive...
opt.smartcase = true -- ...unless the pattern has a capital letter

-- UI
opt.termguicolors = true
opt.signcolumn = "yes" -- Always show, so text doesn't shift when diagnostics appear
opt.cursorline = true
opt.scrolloff = 8
opt.wrap = false
opt.mouse = "a"

-- Splits open to the right / below
opt.splitright = true
opt.splitbelow = true

-- Persistent undo across restarts
opt.undofile = true

-- Timing
opt.updatetime = 250 -- Faster CursorHold (diagnostics, highlights)
opt.timeoutlen = 400 -- Wait for mapped key sequences

-- Clipboard is left unset on purpose: use <leader>y (lua/insomnia/remap.lua)
