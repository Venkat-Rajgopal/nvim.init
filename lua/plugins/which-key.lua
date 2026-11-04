return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    keys = {
      { "<leader>?", function() require("which-key").show({ global = false }) end, desc = "Buffer keymaps" },
    },
    opts = {
      preset = "modern",
      -- Group names; the keys inside come from each mapping's desc
      spec = {
        { "<leader>c", group = "code" },
        { "<leader>f", group = "find" },
        { "<leader>g", group = "git" },
        { "<leader>m", group = "markdown" },
        { "<leader>p", group = "project" },
        { "<leader>r", group = "refactor" },
        { "<leader>t", group = "toggle" },
        { "[", group = "previous" },
        { "]", group = "next" },
        { "g", group = "goto" },
      },
    },
  },
}
