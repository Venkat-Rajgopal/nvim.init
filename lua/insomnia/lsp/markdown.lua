local handlers = require('insomnia.lsp.handlers')

-- Configure Marksman (Markdown LSP)
vim.lsp.config('marksman', {
  on_attach = handlers.on_attach,
  capabilities = handlers.capabilities,
  filetypes = { "markdown", "markdown.mdx" },
  root_markers = { ".git", ".marksman.toml" },
  settings = {
    -- Marksman doesn't require specific settings, but you can add them here if needed
  }
})
vim.lsp.enable('marksman')
