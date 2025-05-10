-- Markdown configuration
vim.g.vim_markdown_folding_disabled = 1
vim.g.vim_markdown_conceal = 0
vim.g.vim_markdown_conceal_code_blocks = 0
vim.g.vim_markdown_math = 1
vim.g.vim_markdown_frontmatter = 1
vim.g.vim_markdown_strikethrough = 1
vim.g.vim_markdown_autowrite = 1
vim.g.vim_markdown_edit_url_in = 'tab'
vim.g.vim_markdown_follow_anchor = 1

-- Markdown preview settings
vim.g.mkdp_auto_start = 0
vim.g.mkdp_auto_close = 1
vim.g.mkdp_refresh_slow = 0
vim.g.mkdp_browser = ''
vim.g.mkdp_preview_options = {
  maid = {
    sequence = { useMaxWidth = true }
  }
}

-- Custom Markdown keymaps
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    -- Local keybindings for markdown files
    vim.api.nvim_buf_set_keymap(0, "n", "<leader>mp", ":MarkdownPreview<CR>", { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(0, "n", "<leader>ms", ":MarkdownPreviewStop<CR>", { noremap = true, silent = true })
  end,
})
