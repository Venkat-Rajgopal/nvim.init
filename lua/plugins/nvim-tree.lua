return {
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = { "NvimTreeToggle", "NvimTreeFocus", "NvimTreeOpen", "NvimTreeFindFile" },
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<CR>", desc = "Toggle file tree" },
      {
        "<leader>tt",
        function()
          local view = require("nvim-tree.view")
          if view.is_visible() then
            if vim.fn.win_getid() == view.get_winnr() then
              vim.cmd("wincmd l") -- if in tree, go to editor
            else
              vim.cmd("NvimTreeFocus") -- if in editor, focus tree
            end
          else
            vim.cmd("NvimTreeToggle") -- open if not open
          end
        end,
        desc = "Toggle focus between NvimTree and editor",
      },
    },
    opts = {
      renderer = {
        icons = {
          show = {
            file = true,
            folder = true,
            folder_arrow = true,
            git = true,
          },
        },
      },
    },
  },
}
