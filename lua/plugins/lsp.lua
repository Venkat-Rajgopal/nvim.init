-- Step 1 only ports these from packer; lua/insomnia/lsp still requires them
-- right after lazy.setup(), so they must load eagerly for now.
return {
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",

      -- Useful status updates for LSP
      "j-hui/fidget.nvim",
    },
  },

  -- Formatting and linting (not configured yet; replaced by conform/nvim-lint in step 4)
  { "nvimtools/none-ls.nvim", lazy = true, dependencies = { "nvim-lua/plenary.nvim" } },
}
