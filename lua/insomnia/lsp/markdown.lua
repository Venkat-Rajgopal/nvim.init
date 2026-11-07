-- Configure Marksman (Markdown LSP)
vim.lsp.config("marksman", {
  -- .NET aborts without libicu (not on every Linux), and marksman doesn't need it
  cmd_env = { DOTNET_SYSTEM_GLOBALIZATION_INVARIANT = "1" },
  filetypes = { "markdown", "markdown.mdx" },
  root_markers = { ".git", ".marksman.toml" },
})
vim.lsp.enable("marksman")
