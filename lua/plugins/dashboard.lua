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

local function header()
  local A = require("insomnia.dashboard_art")
  vim.api.nvim_set_hl(0, "InsomniaTitle", { fg = (A.art[art] or A.art.moon).accent, bold = true })
  return {
    { text = A.render(art), align = "center", padding = 1 },
    { text = { "n e o v i m", hl = "InsomniaTitle" }, align = "center", padding = 2 },
  }
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
            { icon = I.tree, key = "e", desc = "File tree", action = ":NvimTreeToggle" },
            { icon = I.config, key = "c", desc = "Config", action = ":e ~/.config/nvim/init.lua" },
            { icon = I.lazy, key = "L", desc = "Lazy", action = ":Lazy" },
            { icon = I.quit, key = "q", desc = "Quit", action = ":qa" },
          },
        },
        sections = {
          header,
          { section = "keys", gap = 1, padding = 1 },
          { icon = I.recent_title, title = "Recent files", section = "recent_files", limit = 5, indent = 2, padding = 1 },
          { section = "startup", icon = I.startup },
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
