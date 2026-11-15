-- Start screen: snacks.nvim dashboard with pixel art from lua/insomnia/dashboard_art.lua.
-- :DashboardArt <name> (or no name, for a picker) switches the art and remembers it, like the
-- theme picker. The choice is saved to ~/.local/share/nvim/dashboard_art; `default` is used until
-- something is picked (names: see lua/insomnia/dashboard_art.lua).
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
    opts = {
      dashboard = {
        enabled = true,
        preset = {
          -- stylua: ignore
          keys = {
            { icon = " ", key = "f", desc = "Find file", action = ":Telescope find_files" },
            { icon = " ", key = "g", desc = "Live grep", action = ":Telescope live_grep" },
            { icon = " ", key = "r", desc = "Recent files", action = ":Telescope oldfiles" },
            { icon = " ", key = "e", desc = "File tree", action = ":NvimTreeToggle" },
            { icon = " ", key = "c", desc = "Config", action = ":e ~/.config/nvim/init.lua" },
            { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy" },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
        sections = {
          header,
          { section = "keys", gap = 1, padding = 1 },
          { icon = " ", title = "Recent files", section = "recent_files", limit = 5, indent = 2, padding = 1 },
          { section = "startup" },
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
