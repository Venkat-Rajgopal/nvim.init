vim.opt.termguicolors = true

require("catppuccin").setup({
  flavour = "macchiato", -- or "mocha",  "latte", "frappe", "macchiato"
  transparent_background = false,
  integrations = {
    treesitter = true,
    telescope = true,
    nvimtree = true 
    -- add more integrations as needed
  },
})

vim.cmd.colorscheme("catppuccin-macchiato")

