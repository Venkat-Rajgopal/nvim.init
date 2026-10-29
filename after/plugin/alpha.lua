local ok, alpha = pcall(require, "alpha")
if not ok then
  return
end

local dashboard = require("alpha.themes.dashboard")
local icon = vim.fn.nr2char -- Nerd Font glyphs by codepoint

-- Flame template: r/o/y/w = red/orange/yellow/white-hot block, space = empty
local flame_template = {
  "          r          ",
  "         rr      r   ",
  "    r   rorr    rr   ",
  "   rr  roorr   ror   ",
  "   ror roooorr roor  ",
  "  roorroooyoorrooorr ",
  "  rooooooyyyoooooor  ",
  " rrooooyyyyyyyooooorr",
  " rooooyyyywyyyyooorr ",
  " rroooyyywwwyyyooorr ",
  "  rrooyyyywyyyyoorr  ",
  "    rrooyyyyyoorr    ",
  "      rrrrrrrrr      ",
}

local flame_colors = {
  r = { name = "AlphaFlameRed", fg = "#e8392b" },
  o = { name = "AlphaFlameOrange", fg = "#f7861c" },
  y = { name = "AlphaFlameYellow", fg = "#fcd12a" },
  w = { name = "AlphaFlameCore", fg = "#fff4c2" },
}

local function set_flame_highlights()
  for _, c in pairs(flame_colors) do
    vim.api.nvim_set_hl(0, c.name, { fg = c.fg })
  end
  vim.api.nvim_set_hl(0, "AlphaTitle", { fg = "#f7861c", bold = true })
end
set_flame_highlights()
vim.api.nvim_create_autocmd("ColorScheme", { callback = set_flame_highlights })

local block = "█"
local flame_lines, flame_hl = {}, {}
for i, row in ipairs(flame_template) do
  local line, hls = "", {}
  for ch in row:gmatch(".") do
    local color = flame_colors[ch]
    if color then
      hls[#hls + 1] = { color.name, #line, #line + #block }
      line = line .. block
    else
      line = line .. " "
    end
  end
  flame_lines[i], flame_hl[i] = line, hls
end

local flame = {
  type = "text",
  val = flame_lines,
  opts = { position = "center", hl = flame_hl },
}

dashboard.section.header.opts.hl = "AlphaTitle"
dashboard.section.header.val = {
  [[███╗   ██╗██╗   ██╗██╗███╗   ███╗   ██╗███╗   ██╗██╗████████╗]],
  [[████╗  ██║██║   ██║██║████╗ ████║   ██║████╗  ██║██║╚══██╔══╝]],
  [[██╔██╗ ██║██║   ██║██║██╔████╔██║   ██║██╔██╗ ██║██║   ██║   ]],
  [[██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║   ██║██║╚██╗██║██║   ██║   ]],
  [[██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║██╗██║██║ ╚████║██║   ██║   ]],
  [[╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝╚═╝╚═╝╚═╝  ╚═══╝╚═╝   ╚═╝   ]],
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
  flame,
  { type = "padding", val = 1 },
  dashboard.section.header,
  { type = "padding", val = 2 },
  dashboard.section.buttons,
  { type = "padding", val = 1 },
  { type = "text", val = "Recent files", opts = { hl = "SpecialComment", position = "center" } },
  { type = "padding", val = 1 },
  { type = "group", val = function() return recent_files(5) end, opts = { spacing = 1 } },
}

alpha.setup(dashboard.config)
