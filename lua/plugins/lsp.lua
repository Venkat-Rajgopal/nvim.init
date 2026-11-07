-- Servers are configured and enabled in lua/insomnia/lsp/.
-- Mason loads at startup so its bin dir is on PATH before any server starts.

local is_pi = require("insomnia.platform").is_pi

-- Prebuilt binaries: Mason only needs curl/unzip (and Python for ty)
local servers = { -- lspconfig names
  "ruff", -- Python lint
  "marksman", -- Markdown
  "lua_ls", -- Lua
}
local tools = { "stylua" } -- formatters and linters (lua/plugins/formatting.lua, lua/plugins/lint.lua)

-- Mason installs these with npm. Without it each one fails with its own error,
-- so skip them and warn once instead.
local npm_servers = { "jsonls" } -- JSON
local npm_tools = { "prettier", "markdownlint" }
local npm_packages = { "json-lsp", "prettier", "markdownlint" } -- Mason names

-- Python types: pyright needs Node and a lot of memory, so the Pi uses ty
if is_pi then
  table.insert(servers, "ty")
else
  table.insert(npm_servers, "pyright")
  table.insert(npm_packages, "pyright")
end

local have_npm = vim.fn.executable("npm") == 1
if have_npm then
  vim.list_extend(servers, npm_servers)
  vim.list_extend(tools, npm_tools)
end

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

      -- Like mason-lspconfig, install on real starts only: headless nvim exits mid-install
      if #vim.api.nvim_list_uis() == 0 then
        return
      end

      local registry = require("mason-registry")
      registry.refresh(function()
        for _, name in ipairs(tools) do
          local pkg = registry.get_package(name)
          if not pkg:is_installed() then
            pkg:install()
          end
        end

        if not have_npm then
          local missing = vim.tbl_filter(
            function(name) return not registry.get_package(name):is_installed() end,
            npm_packages
          )
          if #missing > 0 then
            vim.notify(
              "npm not found; Mason can't install: "
                .. table.concat(missing, ", ")
                .. "\nInstall Node.js 22+ (see Requirements in the README) and restart.",
              vim.log.levels.WARN
            )
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
      ensure_installed = servers,
      -- rust-analyzer comes from rustup instead (see lua/insomnia/lsp/rust.lua)
      -- Enabled explicitly in lua/insomnia/lsp/ instead
      automatic_enable = false,
    },
  },

  -- LSP progress messages
  { "j-hui/fidget.nvim", event = "LspAttach", opts = {} },
}
