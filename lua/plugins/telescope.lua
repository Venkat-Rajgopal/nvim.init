return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "Telescope",
    keys = {
      { "<leader>pf", function() require("telescope.builtin").find_files() end, desc = "Find files" },
      { "<C-p>", function() require("telescope.builtin").git_files() end, desc = "Git files" },
      { "<leader>ps", function() require("telescope.builtin").live_grep() end, desc = "Live grep" },
    },
    opts = {
      defaults = {
        file_ignore_patterns = { "node_modules", ".git" },
        -- you could customize layout, prompts, icons, etc. here
      },
    },
  },
}
