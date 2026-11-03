-- Configure Rust-Analyzer
-- Use rustup's rust-analyzer (`rustup component add rust-analyzer`): it matches the
-- toolchain's proc-macro server and follows rust-toolchain.toml. Mason's or
-- Homebrew's copies go stale and fail with "Failed to run proc-macro server".
local cargo_home = vim.env.CARGO_HOME or (vim.env.HOME .. "/.cargo")

vim.lsp.config("rust_analyzer", {
  cmd = { cargo_home .. "/bin/rust-analyzer" },
  settings = {
    ["rust-analyzer"] = {
      cargo = {
        allFeatures = true,
        buildScripts = { enable = true },
      },
      -- Run clippy on save
      check = {
        command = "clippy",
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
    },
  },
})
vim.lsp.enable("rust_analyzer")
