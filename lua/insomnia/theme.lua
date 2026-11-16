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

-- Line numbers are lifted toward the normal text colour, separately from the
-- faded indent guides (lua/plugins/ui.lua).
-- 0 = theme default, 1 = same colour as the code text.
local LINENR_BOOST = 0.35

local function brighten_line_numbers()
  local text = vim.api.nvim_get_hl(0, { name = "Normal", link = false }).fg
  for _, name in ipairs({ "LineNr", "LineNrAbove", "LineNrBelow" }) do
    local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
    if hl.fg and text then
      local out = 0
      for _, s in ipairs({ 16, 8, 0 }) do
        local a, b = math.floor(hl.fg / 2 ^ s) % 256, math.floor(text / 2 ^ s) % 256
        out = out + math.floor(a + (b - a) * LINENR_BOOST + 0.5) * 2 ^ s
      end
      hl.fg = out
      vim.api.nvim_set_hl(0, name, hl)
    end
  end
end

function M.load()
  -- Lazy-loaded theme plugins are loaded by lazy.nvim on :colorscheme
  if not pcall(vim.cmd.colorscheme, read_saved() or default) then
    vim.cmd.colorscheme(default)
  end
  brighten_line_numbers()

  vim.api.nvim_create_autocmd("ColorScheme", {
    group = vim.api.nvim_create_augroup("insomnia_theme", { clear = true }),
    callback = function(ev)
      brighten_line_numbers()
      local f = io.open(state_file, "w")
      if f then
        f:write(ev.match)
        f:close()
      end
    end,
  })
end

return M
