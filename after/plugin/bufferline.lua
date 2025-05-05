require("bufferline").setup({
  options = {
    mode = "buffers", -- or "tabs"
    diagnostics = "nvim_lsp",
    separator_style = "slant", -- or "thick", "thin", etc.
    show_buffer_icons = true,
    show_close_icon = false,

    -- set up the sidebar explorer
    offsets = {
        {
            filetype = "NvimTree",
            text = "File Explorer",
            highlight = "Directory",
            separator = true -- use a "true" to enable the default, or set your own character
        }
    }
 },
})

vim.keymap.set("n", "<Tab>", "<Cmd>BufferLineCycleNext<CR>")
vim.keymap.set("n", "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>")

