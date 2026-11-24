-- Icons used across the UI, with a plain-text fallback for terminals without a Nerd Font
-- (a Raspberry Pi console, someone else's laptop, an old patched font that shows blanks).
--
-- :Icons nerd|ascii switches and remembers the choice in ~/.local/share/nvim/icons; restart
-- Neovim to apply it. NVIM_ICONS=ascii nvim does the same for one session. Default: nerd.
--
-- Glyphs are written as codepoints: editors and copy-paste tend to drop raw Nerd Font
-- characters from source files.
local M = {}

local icon = vim.fn.nr2char
local state_file = vim.fn.stdpath("data") .. "/icons"
M.modes = { "nerd", "ascii" }

local function read_saved()
  local f = io.open(state_file, "r")
  if not f then
    return nil
  end
  local mode = vim.trim(f:read("*a"))
  f:close()
  return mode
end

local function valid(mode) return mode == "nerd" or mode == "ascii" end

local env, saved = vim.env.NVIM_ICONS, read_saved()
M.mode = (valid(env) and env) or (valid(saved) and saved) or "nerd"
M.nerd = M.mode == "nerd"

local function pick(nerd, ascii) return M.nerd and nerd or ascii end

-- Sign column (lua/insomnia/lsp/handlers.lua)
M.diagnostics = {
  error = pick(icon(0xf057), "E"),
  warn = pick(icon(0xf071), "W"),
  hint = pick(icon(0xf0eb), "H"),
  info = pick(icon(0xf05a), "I"),
}

-- Statusline (lua/plugins/ui.lua)
M.lualine = {
  component = pick({ left = icon(0xe0b5), right = icon(0xe0b7) }, { left = "|", right = "|" }), -- thin rounded
  section = pick({ left = icon(0xe0b4), right = icon(0xe0b6) }, { left = "", right = "" }), -- rounded
}

-- Start screen keys and section titles (lua/plugins/dashboard.lua). Two cells wide.
M.dashboard = {
  find = pick(icon(0xf002) .. " ", ""),
  grep = pick(icon(0xf0f6) .. " ", ""),
  recent = pick(icon(0xf1da) .. " ", ""),
  tree = pick(icon(0xf07b) .. " ", ""),
  config = pick(icon(0xf013) .. " ", ""),
  lazy = pick(icon(0xf04b2) .. " ", ""),
  quit = pick(icon(0xf011) .. " ", ""),
  recent_title = pick(icon(0xf017) .. " ", ""),
  startup = not M.nerd and "" or nil, -- nil = snacks' default
}

-- Plugin options that only apply in ascii mode; in nerd mode the plugins keep their defaults.
M.ascii = {
  -- lazy.nvim's :Lazy window
  lazy = {
    cmd = "cmd ",
    config = "config ",
    event = "event ",
    favorite = "* ",
    ft = "ft ",
    init = "init ",
    import = "import ",
    keys = "keys ",
    lazy = "lazy ",
    loaded = "*",
    not_loaded = "o",
    plugin = "plugin ",
    runtime = "rtp ",
    require = "require ",
    source = "source ",
    start = "start ",
    task = "ok ",
    list = { "*", "-", "+", "-" },
  },
  -- which-key's key labels (<C-...>, <CR> etc.)
  which_key = {
    Up = "Up ",
    Down = "Down ",
    Left = "Left ",
    Right = "Right ",
    C = "C-",
    M = "M-",
    D = "D-",
    S = "S-",
    CR = "CR ",
    Esc = "Esc ",
    ScrollWheelDown = "ScrollDown ",
    ScrollWheelUp = "ScrollUp ",
    NL = "NL ",
    BS = "BS ",
    Space = "Space ",
    Tab = "Tab ",
  },
  -- nvim-tree's arrows and git markers (file and folder icons are switched off)
  tree = {
    default = "",
    symlink = "",
    bookmark = "*",
    modified = "+",
    hidden = "h",
    folder = { arrow_closed = "+", arrow_open = "-" },
    git = {
      unstaged = "M",
      staged = "S",
      unmerged = "U",
      renamed = "R",
      untracked = "?",
      deleted = "D",
      ignored = "!",
    },
  },
}

function M.set(mode)
  if not valid(mode) then
    vim.notify("Icons: use nerd or ascii", vim.log.levels.ERROR)
    return
  end
  local f = io.open(state_file, "w")
  if f then
    f:write(mode)
    f:close()
  end
  local note = valid(env) and " (NVIM_ICONS=" .. env .. " still wins for this shell)" or ""
  vim.notify("Icons set to " .. mode .. ". Restart Neovim to apply" .. note .. ".")
end

vim.api.nvim_create_user_command("Icons", function(cmd)
  if cmd.args ~= "" then
    return M.set(cmd.args)
  end
  vim.ui.select(M.modes, { prompt = "Icons (current: " .. M.mode .. ")" }, function(choice)
    if choice then
      M.set(choice)
    end
  end)
end, {
  nargs = "?",
  complete = function() return M.modes end,
  desc = "Nerd Font icons or plain text (remembered; restart to apply)",
})

return M
