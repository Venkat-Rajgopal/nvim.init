-- Snacks picks the terminal from the count, which would be wrong here: Ctrl-/ in terminal 2
-- has no count, and v:count goes stale in terminal mode. A count from normal mode still works.
local function toggle()
  if vim.bo.filetype == "snacks_terminal" and (vim.fn.mode() == "t" or vim.v.count == 0) then
    vim.cmd.hide()
  else
    Snacks.terminal()
  end
end

local function nav(key)
  return { "<C-" .. key .. ">", function() vim.cmd.wincmd(key) end, mode = "t", desc = "Move to window " .. key }
end

-- snacks identifies a terminal by cmd, cwd, env and count, not by layout, so the env
-- gives the split its own shell instead of reusing the float.
-- The move keys are for the split only: a float covers the windows they would jump to,
-- and shells and TUI apps need Ctrl-h/j/k/l for themselves.
local function split()
  Snacks.terminal(nil, {
    env = { NVIM_TERMINAL_LAYOUT = "split" },
    win = {
      position = "bottom",
      height = 0.3,
      keys = { nav_h = nav("h"), nav_j = nav("j"), nav_k = nav("k"), nav_l = nav("l") },
    },
  })
end

-- Without the binary, snacks leaves nvim stuck on an error prompt
local function lazygit()
  if vim.fn.executable("lazygit") == 0 then
    vim.notify("lazygit is not installed", vim.log.levels.WARN)
    return
  end
  Snacks.lazygit()
end

return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false, -- recommended by snacks; modules stay off unless configured
    opts = {
      terminal = {
        win = { position = "float" },
      },
    },
    keys = {
      { "<C-/>", toggle, mode = { "n", "t" }, desc = "Toggle terminal" },
      { "<C-_>", toggle, mode = { "n", "t" }, desc = "which_key_ignore" }, -- what many terminals send for Ctrl-/
      { "<leader>ts", split, desc = "Terminal in bottom split" },
      { "<leader>gg", lazygit, desc = "Lazygit" },
    },
  },
}
