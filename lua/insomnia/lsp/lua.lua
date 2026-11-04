-- Configure lua_ls (Neovim API types come from lazydev.nvim)
vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      completion = { callSnippet = "Replace" },
    },
  },
})
vim.lsp.enable("lua_ls")
