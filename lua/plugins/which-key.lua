return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    keys = {
      { "<leader>?", function() require("which-key").show({ global = false }) end, desc = "Buffer keymaps" },
    },
    opts = {
      preset = "modern",
      -- Plain-text key labels and no mapping icons without a Nerd Font (lua/insomnia/icons.lua)
      icons = not require("insomnia.icons").nerd and {
        mappings = false,
        keys = require("insomnia.icons").ascii.which_key,
      } or nil,
      -- Group names; the keys inside come from each mapping's desc
      spec = {
        { "<leader>b", group = "buffer" },
        { "<leader>c", group = "code" },
        { "<leader>f", group = "find" },
        { "<leader>g", group = "git" },
        { "<leader>m", group = "markdown" },
        { "<leader>r", group = "refactor" },
        { "<leader>t", group = "toggle" },
        { "[", group = "previous" },
        { "]", group = "next" },
        { "g", group = "goto" },
      },
    },
  },
}
