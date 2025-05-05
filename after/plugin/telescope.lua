local telescope = require("telescope")
local builtin = require('telescope.builtin')

telescope.setup({
  defaults = {
    file_ignore_patterns = { "node_modules", ".git" },
    -- you could customize layout, prompts, icons, etc. here
  },
})

-- keymaps
vim.keymap.set('n', '<leader>pf', builtin.find_files, { desc = 'Find files' })
vim.keymap.set('n', '<C-p>', builtin.git_files, { desc = 'Git files' })
vim.keymap.set('n', '<leader>ps', function()
	require('telescope.builtin').live_grep()
	-- builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)

