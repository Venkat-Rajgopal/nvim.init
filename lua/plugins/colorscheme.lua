return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "macchiato", -- or "mocha",  "latte", "frappe", "macchiato"
        transparent_background = false,
        integrations = {
          treesitter = true,
          telescope = true,
          nvimtree = true,
          blink_cmp = true,
          gitsigns = true,
          which_key = true,
          fidget = true,
          mason = true,
          indent_blankline = { enabled = true },
          -- add more integrations as needed
        },
      })

      vim.cmd.colorscheme("catppuccin-macchiato")
    end,
  },
}
