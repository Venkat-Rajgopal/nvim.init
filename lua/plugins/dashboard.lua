-- Start screen: snacks.nvim dashboard with pixel art from lua/insomnia/dashboard_art.lua.
-- :DashboardArt <name> (or no name, for a picker) switches the art and remembers it, like the
-- theme picker. The choice is saved to ~/.local/share/nvim/dashboard_art; `default` is used until
-- something is picked (names: see lua/insomnia/dashboard_art.lua).
local I = require("insomnia.icons").dashboard
local nerd = require("insomnia.icons").nerd
local default = "owl"
local state_file = vim.fn.stdpath("data") .. "/dashboard_art"

local function read_saved()
  local f = io.open(state_file, "r")
  if not f then
    return nil
  end
  local name = vim.trim(f:read("*a"))
  f:close()
  return name ~= "" and name or nil
end

local art = read_saved() or default

local function set_art(name)
  if not require("insomnia.dashboard_art").art[name] then
    vim.notify("No dashboard art named " .. name, vim.log.levels.ERROR)
    return
  end
  art = name
  local f = io.open(state_file, "w")
  if f then
    f:write(name)
    f:close()
  end
  Snacks.dashboard.open()
end

-- <leader>bD: close every buffer, then show the dashboard with the file tree beside it.
local function fresh_start()
  Snacks.bufdelete.all() -- asks about unsaved changes, like <leader>bd
  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[b].buflisted and vim.bo[b].modified then
      return -- a save prompt was cancelled: leave things as they are
    end
  end
  -- Work from an editor window, not the tree, and drop any splits
  for _, w in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local ft = vim.bo[vim.api.nvim_win_get_buf(w)].filetype
    if ft ~= "NvimTree" and vim.api.nvim_win_get_config(w).relative == "" then
      vim.api.nvim_set_current_win(w)
      break
    end
  end
  if vim.bo.filetype == "NvimTree" then
    vim.cmd("enew")
  end
  vim.cmd("silent! only")
  -- Open the dashboard in this window (not as a full-screen float, which would hide the tree)
  -- and drop the empty buffer bufdelete left behind, so the bufferline is clear
  local empty = vim.api.nvim_get_current_buf()
  Snacks.dashboard({ win = vim.api.nvim_get_current_win() })
  if vim.api.nvim_buf_is_valid(empty) and vim.api.nvim_buf_get_name(empty) == "" and not vim.bo[empty].modified then
    pcall(vim.api.nvim_buf_delete, empty, {})
  end
  vim.cmd("NvimTreeOpen")
  vim.cmd("wincmd p") -- keep focus on the dashboard so its keys work
end

-- Recent files and projects, each in a rounded box. Snacks has no borders, so every line of a box
-- is a dashboard item made of text pieces: `│ ` icon text … key ` │`, padded to the dashboard width.
local W = 60 -- snacks' default dashboard width
local B = "FloatBorder"

local function trunc_left(s, n)
  if n <= 0 then
    return ""
  elseif vim.fn.strwidth(s) <= n then
    return s
  end
  return "…" .. vim.fn.strcharpart(s, vim.fn.strchars(s) - (n - 1))
end

local function border(left, title, right)
  local fill = W - vim.fn.strwidth(left .. title .. right)
  return { text = { { left, hl = B }, { title, hl = "SnacksDashboardTitle" }, { ("─"):rep(fill) .. right, hl = B } } }
end

-- `parts` builds the row's text from the width it may use: a list of { str, hl }
local function row(icon, parts, key, action)
  local icon_w = vim.fn.strwidth(icon[1])
  local text = parts(W - 4 - icon_w - 2) -- 4 for the side borders, 2 for the key
  local line = { { "│ ", hl = B }, icon }
  local used = icon_w
  for _, p in ipairs(text) do
    line[#line + 1] = p
    used = used + vim.fn.strwidth(p[1])
  end
  line[#line + 1] = { (" "):rep(W - 4 - used - 1) }
  line[#line + 1] = { key, hl = "SnacksDashboardKey" }
  line[#line + 1] = { " │", hl = B }
  return { text = line, key = key, action = action }
end

local function box(title_icon, title, rows, empty)
  local items = { border("╭─ ", title_icon .. title .. " ", "╮") }
  for _, r in ipairs(rows) do
    items[#items + 1] = r
  end
  if #rows == 0 then
    local pad = W - 4 - vim.fn.strwidth(empty)
    items[#items + 1] =
      { text = { { "│ ", hl = B }, { empty .. (" "):rep(pad), hl = "SnacksDashboardDir" }, { " │", hl = B } } }
  end
  items[#items + 1] = border("╰", "", "╯")
  items.padding = 1
  return items
end

local function file_icon(file)
  if not nerd then
    return { "" }
  end
  local glyph, hl = Snacks.util.icon(file, "file")
  return { (glyph or " ") .. " ", hl = hl or "SnacksDashboardIcon" }
end

-- Keys 1-5
local function recent_box()
  local rows = {}
  for file in Snacks.dashboard.oldfiles() do
    local name = vim.fn.fnamemodify(file, ":t")
    local dir = vim.fn.fnamemodify(file, ":~:h") .. "/"
    rows[#rows + 1] = row(file_icon(file), function(width)
      name = trunc_left(name, width)
      return {
        { trunc_left(dir, width - vim.fn.strwidth(name)), hl = "SnacksDashboardDir" },
        { name, hl = "SnacksDashboardFile" },
      }
    end, tostring(#rows + 1), ":e " .. vim.fn.fnameescape(file))
    if #rows == 5 then
      break
    end
  end
  return box(I.recent_title, "Recent files", rows, "No recent files yet")
end

-- Keys 6-0. Opening one makes it the working directory and opens the file tree there.
local function projects_box()
  local find = require("insomnia.find")
  local rows = {}
  for i, dir in ipairs(find.projects(5)) do
    local name = vim.fn.fnamemodify(dir, ":t")
    local parent = vim.fn.fnamemodify(dir, ":~:h")
    rows[#rows + 1] = row({ I.project, hl = "SnacksDashboardIcon" }, function(width)
      name = trunc_left(name, width)
      local rest = width - vim.fn.strwidth(name) - 2
      return { { name, hl = "SnacksDashboardFile" }, { "  " .. trunc_left(parent, rest), hl = "SnacksDashboardDir" } }
    end, tostring((i + 5) % 10), function() find.open_project(dir) end)
  end
  return box(I.project, "Projects", rows, "Projects appear once you open files in a git repo")
end

-- Layout: on wide windows the art and keys stay on the left and the two boxes sit on the right,
-- level with the keys; the art, title and startup line are centred across both (see centre()).
-- Otherwise everything stacks in one column.
local function art_lines() return math.ceil(#(require("insomnia.dashboard_art").art[art] or { rows = {} }).rows / 2) end
-- Wide enough means two panes (2 * W + snacks' 4-column gap) plus room for centre() to shift the
-- widest centred line: it starts (4 + width) / 2 columns left of the panes. 187 columns is plenty.
local function side_by_side(self)
  local widest = 0
  for _, r in ipairs((require("insomnia.dashboard_art").art[art] or { rows = {} }).rows) do
    widest = math.max(widest, #r)
  end
  local footer = 0
  for _, t in ipairs(Snacks.dashboard.sections.startup({ icon = I.startup }).text) do
    footer = footer + vim.fn.strwidth(t[1])
  end
  return self._size.width >= 2 * W + 4 + 4 + math.max(widest, footer) + 2
end

-- A blank line between keys, unless the window is too short to show the whole dashboard with them.
-- Height with the blank lines: art + 21 side by side (title 4, keys 15, padding 1, startup 1),
-- art + 35 stacked (the boxes add 16, the keys' blank lines are 7 of the rest). Owl: 33 / 47.
local function keys_section(self)
  local roomy = self._size.height >= art_lines() + (side_by_side(self) and 21 or 35)
  return { section = "keys", gap = roomy and 1 or 0, padding = 1 }
end

local function boxes(self)
  local recent, projects = recent_box(), projects_box()
  if side_by_side(self) then
    recent[1].padding = { 0, art_lines() + 4 } -- blank lines above, so the box starts level with the keys
  end
  return { pane = side_by_side(self) and 2 or 1, recent, projects }
end

-- Side by side, the art, title and startup line are centred across both panes, not just the left
-- one: snacks centres a line wider than a pane on the left pane's centre, so prefixing each line
-- with a pane and a gap of spaces (W + 4) moves that centre to the middle of the two panes.
-- Rows to the right of the art are empty (the boxes start lower), so nothing collides.
local function centre(self, texts)
  if not side_by_side(self) then
    return texts
  end
  local pad = { (" "):rep(W + 4) }
  local out = { pad }
  for _, t in ipairs(texts) do
    out[#out + 1] = t
    if t[1] == "\n" then
      out[#out + 1] = pad
    end
  end
  return out
end

local function header(self)
  local A = require("insomnia.dashboard_art")
  vim.api.nvim_set_hl(0, "InsomniaTitle", { fg = (A.art[art] or A.art.moon).accent, bold = true })
  return {
    { text = centre(self, A.render(art)), align = "center", padding = 1 },
    { text = centre(self, { { "n e o v i m", hl = "InsomniaTitle" } }), align = "center", padding = 2 },
  }
end

local function startup(self)
  local item = Snacks.dashboard.sections.startup({ icon = I.startup })
  item.text = centre(self, item.text)
  return item
end

return {
  {
    "folke/snacks.nvim",
    keys = {
      { "<leader>bD", fresh_start, desc = "Close all buffers, show dashboard" },
    },
    opts = {
      dashboard = {
        enabled = true,
        -- No Nerd Font: drop the file icons of recent files too (nil keeps snacks' formatter)
        formats = not nerd and { icon = function() return { "", width = 0 } end } or nil,
        preset = {
          -- stylua: ignore
          keys = {
            { icon = I.find, key = "f", desc = "Find file", action = ":Telescope find_files" },
            { icon = I.grep, key = "g", desc = "Live grep", action = ":Telescope live_grep" },
            { icon = I.recent, key = "r", desc = "Recent files", action = ":Telescope oldfiles" },
            { icon = I.project, key = "p", desc = "Projects", action = function() require("insomnia.find").pick_project() end },
            { icon = I.tree, key = "e", desc = "File tree", action = ":NvimTreeToggle" },
            { icon = I.config, key = "c", desc = "Config", action = ":e ~/.config/nvim/init.lua" },
            { icon = I.lazy, key = "L", desc = "Lazy", action = ":Lazy" },
            { icon = I.quit, key = "q", desc = "Quit", action = ":qa" },
          },
        },
        sections = {
          header,
          keys_section,
          boxes,
          startup,
        },
      },
    },
    init = function()
      vim.api.nvim_create_user_command("DashboardArt", function(cmd)
        if cmd.args ~= "" then
          return set_art(cmd.args)
        end
        local names = vim.deepcopy(require("insomnia.dashboard_art").names)
        table.sort(names)
        vim.ui.select(names, { prompt = "Dashboard art (current: " .. art .. ")" }, function(choice)
          if choice then
            set_art(choice)
          end
        end)
      end, {
        nargs = "?",
        complete = function() return require("insomnia.dashboard_art").names end,
        desc = "Pick the dashboard art (remembered)",
      })
    end,
  },
}
