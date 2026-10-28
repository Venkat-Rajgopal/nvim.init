local handlers = require('insomnia.lsp.handlers')

-- Configure Rust-Analyzer
vim.lsp.config('rust_analyzer', {
  on_attach = handlers.on_attach,
  capabilities = handlers.capabilities,
  settings = {
    ['rust-analyzer'] = {
      -- Enable experimental features
      cargo = {
        allFeatures = true,
        loadOutDirsFromCheck = true,
        runBuildScripts = true,
      },
      -- Enable clippy on save
      checkOnSave = {
        command = "clippy",
        allFeatures = true,
      },
      procMacro = {
        enable = true,
        ignored = {
          ["async-trait"] = { "async_trait" },
          ["tokio"] = { "main", "test" },
          ["async-recursion"] = { "async_recursion" },
        },
      },
      -- Add additional settings below as needed
    }
  },
})
vim.lsp.enable('rust_analyzer')
