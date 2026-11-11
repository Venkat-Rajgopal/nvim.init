-- Start screen: snacks.nvim dashboard with pixel art from lua/insomnia/dashboard_art.lua.
-- :DashboardArt <name> tries other art for this session only.
-- To show different art on every launch, change this name (see lua/insomnia/dashboard_art.lua
-- for the list: alien, bonsai, cactus, cat, coffee, fox, moon, mountains, mushroom, neovim, owl, rocket).
local art = "owl"

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
        art = cmd.args
        Snacks.dashboard.open()
      end, {
        nargs = 1,
        complete = function() return require("insomnia.dashboard_art").names end,
        desc = "Show the dashboard with another piece of art",
      })
    end,
  },
}
