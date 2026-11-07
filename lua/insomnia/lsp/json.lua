-- Configure jsonls (JSON validation; formatting is handled by conform in step 4)
vim.lsp.config("jsonls", {})

-- Without npm, Mason can't install it (lua/plugins/lsp.lua): don't try to start it
if vim.fn.executable("vscode-json-language-server") == 1 or vim.fn.executable("npm") == 1 then
  vim.lsp.enable("jsonls")
end
