-- Applies the last chosen colorscheme and remembers new choices.
-- Pick one with <leader>th (lua/plugins/telescope.lua).
local M = {}

local default = "catppuccin-macchiato"
local state_file = vim.fn.stdpath("data") .. "/last_theme"

local function read_saved()
  local f = io.open(state_file, "r")
  if not f then
    return nil
  end
  local name = vim.trim(f:read("*a"))
  f:close()
  return name ~= "" and name or nil
end

function M.load()
  -- Lazy-loaded theme plugins are loaded by lazy.nvim on :colorscheme
  if not pcall(vim.cmd.colorscheme, read_saved() or default) then
    vim.cmd.colorscheme(default)
  end

  vim.api.nvim_create_autocmd("ColorScheme", {
    group = vim.api.nvim_create_augroup("insomnia_theme", { clear = true }),
    callback = function(ev)
      local f = io.open(state_file, "w")
      if f then
        f:write(ev.match)
        f:close()
      end
    end,
  })
end

return M
