-- Default theme is catppuccin-macchiato. The others load only when picked with
-- <leader>th; the last choice is restored on startup (lua/insomnia/theme.lua).
return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {
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
    },
  },

  -- tokyonight, tokyonight-night / -storm / -moon / -day
  { "folke/tokyonight.nvim", lazy = true },

  -- kanagawa, kanagawa-wave / -dragon / -lotus
  { "rebelot/kanagawa.nvim", lazy = true },

  -- rose-pine, rose-pine-main / -moon / -dawn
  { "rose-pine/neovim", name = "rose-pine", lazy = true },

  -- cyberdream (high contrast)
  { "scottmckendry/cyberdream.nvim", lazy = true },

  -- everforest (warm, low contrast)
  { "sainnhe/everforest", lazy = true },

  -- nordic (darker, warmer Nord)
  { "AlexvZyl/nordic.nvim", lazy = true },
}
