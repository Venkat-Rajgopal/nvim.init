-- Configure Marksman (Markdown LSP)
vim.lsp.config("marksman", {
  filetypes = { "markdown", "markdown.mdx" },
  root_markers = { ".git", ".marksman.toml" },
})
vim.lsp.enable("marksman")
