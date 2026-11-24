return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "Telescope",
    keys = {
      { "<C-p>", function() require("telescope.builtin").git_files() end, desc = "Git files" },
      { "<leader>ff", function() require("telescope.builtin").find_files() end, desc = "Find files" },
      { "<leader>fg", function() require("telescope.builtin").live_grep() end, desc = "Grep in project" },
      { "<leader>fw", function() require("telescope.builtin").grep_string() end, desc = "Grep word under cursor" },
      { "<leader>fb", function() require("telescope.builtin").buffers() end, desc = "Open buffers" },
      { "<leader>fr", function() require("telescope.builtin").oldfiles() end, desc = "Recent files" },
      { "<leader>fh", function() require("telescope.builtin").help_tags() end, desc = "Help pages" },
      { "<leader>fk", function() require("telescope.builtin").keymaps() end, desc = "Keymaps" },
      { "<leader>fd", function() require("telescope.builtin").diagnostics() end, desc = "Diagnostics" },
      { "<leader>fs", function() require("telescope.builtin").lsp_document_symbols() end, desc = "Symbols in file" },
      {
        "<leader>th",
        function() require("telescope.builtin").colorscheme({ enable_preview = true, ignore_builtins = true }) end,
        desc = "Theme picker",
      },
    },
    opts = {
      defaults = {
        file_ignore_patterns = { "node_modules", ".git" },
        -- you could customize layout, prompts, icons, etc. here
      },
      -- File icons are a per-picker option; off without a Nerd Font (lua/insomnia/icons.lua)
      pickers = not require("insomnia.icons").nerd and vim.iter({
        "find_files", "git_files", "live_grep", "grep_string", "buffers", "oldfiles", "diagnostics",
      }):fold({}, function(acc, name)
        acc[name] = { disable_devicons = true }
        return acc
      end) or nil,
    },
  },
}
