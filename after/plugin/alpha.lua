local ok, alpha = pcall(require, "alpha")
if not ok then
  return
end

local dashboard = require("alpha.themes.dashboard")
local icon = vim.fn.nr2char -- Nerd Font glyphs by codepoint

dashboard.section.header.val = {
  [[                      )                  ]],
  [[                     ) \                 ]],
  [[                    / ) (                ]],
  [[                    \(_)/                ]],
  [[ ___                                  _       ]],
  [[|_ _|_ __  ___  ___  _ __ ___  _ __ (_) __ _ ]],
  [[ | || '_ \/ __|/ _ \| '_ ` _ \| '_ \| |/ _` |]],
  [[ | || | | \__ \ (_) | | | | | | | | | | (_| |]],
  [[|___|_| |_|___/\___/|_| |_| |_|_| |_|_|\__,_|]],
}

dashboard.section.buttons.val = {
  dashboard.button("f", icon(0xf15b) .. "  Find file", "<cmd>Telescope find_files<CR>"),
  dashboard.button("g", icon(0xf002) .. "  Live grep", "<cmd>Telescope live_grep<CR>"),
  dashboard.button("r", icon(0xf1da) .. "  Recent files", "<cmd>Telescope oldfiles<CR>"),
  dashboard.button("e", icon(0xf07b) .. "  File tree", "<cmd>NvimTreeToggle<CR>"),
  dashboard.button("c", icon(0xe615) .. "  Config", "<cmd>e ~/.config/nvim/init.lua<CR>"),
  dashboard.button("q", icon(0xf011) .. "  Quit", "<cmd>qa<CR>"),
}

-- Recent files, each with its filetype icon
local function recent_files(count)
  local devicons = require("nvim-web-devicons")
  local buttons = {}
  for _, path in ipairs(vim.v.oldfiles) do
    if #buttons >= count then
      break
    end
    if vim.fn.filereadable(path) == 1 and not path:find("/.git/", 1, true) then
      local name = vim.fn.fnamemodify(path, ":t")
      local file_icon = devicons.get_icon(name, vim.fn.fnamemodify(name, ":e"), { default = true })
      buttons[#buttons + 1] = dashboard.button(
        tostring(#buttons + 1),
        file_icon .. "  " .. vim.fn.fnamemodify(path, ":~:."),
        "<cmd>e " .. vim.fn.fnameescape(path) .. "<CR>"
      )
    end
  end
  return buttons
end

dashboard.config.layout = {
  { type = "padding", val = 2 },
  dashboard.section.header,
  { type = "padding", val = 2 },
  dashboard.section.buttons,
  { type = "padding", val = 1 },
  { type = "text", val = "Recent files", opts = { hl = "SpecialComment", position = "center" } },
  { type = "padding", val = 1 },
  { type = "group", val = function() return recent_files(5) end, opts = { spacing = 1 } },
}

alpha.setup(dashboard.config)
