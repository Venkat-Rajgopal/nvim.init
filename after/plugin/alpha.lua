local ok, alpha = pcall(require, "alpha")
if not ok then
  return
end

local dashboard = require("alpha.themes.dashboard")

dashboard.section.header.val = {
  [[ ___                                  _       ]],
  [[|_ _|_ __  ___  ___  _ __ ___  _ __ (_) __ _ ]],
  [[ | || '_ \/ __|/ _ \| '_ ` _ \| '_ \| |/ _` |]],
  [[ | || | | \__ \ (_) | | | | | | | | | | (_| |]],
  [[|___|_| |_|___/\___/|_| |_| |_|_| |_|_|\__,_|]],
}

dashboard.section.buttons.val = {
  dashboard.button("f", "  Find file", "<cmd>Telescope find_files<CR>"),
  dashboard.button("g", "  Live grep", "<cmd>Telescope live_grep<CR>"),
  dashboard.button("r", "  Recent files", "<cmd>Telescope oldfiles<CR>"),
  dashboard.button("e", "  File tree", "<cmd>NvimTreeToggle<CR>"),
  dashboard.button("c", "  Config", "<cmd>e ~/.config/nvim/init.lua<CR>"),
  dashboard.button("q", "  Quit", "<cmd>qa<CR>"),
}

alpha.setup(dashboard.config)
