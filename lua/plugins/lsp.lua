-- Step 1 only ports these from packer; lua/insomnia/lsp and lua/insomnia/completion
-- still require them right after lazy.setup(), so they must load eagerly for now.
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

      -- Additional lua configuration, makes nvim stuff amazing
      "folke/neodev.nvim",
    },
  },

  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    lazy = false,
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
  },

  -- Formatting and linting (not configured yet; replaced by conform/nvim-lint in step 4)
  { "nvimtools/none-ls.nvim", lazy = true, dependencies = { "nvim-lua/plenary.nvim" } },
}
