return {
  -- git commands (:Git)
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "G" },
    keys = {
      { "<leader>gs", vim.cmd.Git, desc = "Git status (fugitive)" },
    },
  },

  -- changed lines in the sign column, hunk actions
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      on_attach = function(bufnr)
        local gs = require("gitsigns")

        local function map(mode, keys, fn, desc) vim.keymap.set(mode, keys, fn, { buffer = bufnr, desc = desc }) end

        map("n", "]h", function() gs.nav_hunk("next") end, "Next git hunk")
        map("n", "[h", function() gs.nav_hunk("prev") end, "Previous git hunk")
        map("n", "<leader>gp", gs.preview_hunk, "Preview hunk")
        map("n", "<leader>gb", function() gs.blame_line({ full = true }) end, "Blame line")
        map("n", "<leader>gr", gs.reset_hunk, "Reset hunk")
        map("n", "<leader>gd", gs.diffthis, "Diff against index")
        map("n", "<leader>tb", gs.toggle_current_line_blame, "Toggle inline blame")
      end,
    },
  },
}
