local lspconfig = require('lspconfig')
local handlers = require('insomnia.lsp.handlers')

-- Configure Marksman (Markdown LSP)
lspconfig.marksman.setup({
  on_attach = handlers.on_attach,
  capabilities = handlers.capabilities,
  filetypes = { "markdown", "markdown.mdx" },
  root_dir = lspconfig.util.root_pattern(".git", ".marksman.toml"),
  single_file_support = true,
  settings = {
    -- Marksman doesn't require specific settings, but you can add them here if needed
  }
})
