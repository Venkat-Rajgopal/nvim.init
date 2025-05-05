require("nvim-tree").setup({
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
})

vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle file tree" })

vim.keymap.set("n", "<leader>tt", function()
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
end, { desc = "Toggle focus between NvimTree and editor" })


