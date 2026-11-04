-- Servers are configured and enabled in lua/insomnia/lsp/.
-- Mason loads at startup so its bin dir is on PATH before any server starts.
return {
  { "neovim/nvim-lspconfig", lazy = false }, -- default configs for vim.lsp.config

  {
    "mason-org/mason.nvim",
    lazy = false,
    opts = {
      ui = {
        border = "rounded",
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)

      -- Formatters and linters (lua/plugins/formatting.lua, lua/plugins/lint.lua)
      local tools = { "stylua", "prettier", "markdownlint" }
      local registry = require("mason-registry")
      registry.refresh(function()
        for _, name in ipairs(tools) do
          local pkg = registry.get_package(name)
          if not pkg:is_installed() then
            pkg:install()
          end
        end
      end)
    end,
  },

  {
    "mason-org/mason-lspconfig.nvim",
    lazy = false,
    dependencies = { "mason-org/mason.nvim", "neovim/nvim-lspconfig" },
    opts = {
      ensure_installed = {
        "pyright", -- Python types
        "ruff", -- Python lint
        "marksman", -- Markdown
        "lua_ls", -- Lua
        "jsonls", -- JSON
      },
      -- rust-analyzer comes from rustup instead (see lua/insomnia/lsp/rust.lua)
      -- Enabled explicitly in lua/insomnia/lsp/ instead
      automatic_enable = false,
    },
  },

  -- LSP progress messages
  { "j-hui/fidget.nvim", event = "LspAttach", opts = {} },
}
