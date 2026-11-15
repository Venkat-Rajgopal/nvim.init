local icon = vim.fn.nr2char -- Nerd Font glyphs by codepoint

-- Diff counts from gitsigns (already computed per buffer) instead of lualine running git
local function gitsigns_diff()
  local d = vim.b.gitsigns_status_dict
  if d then
    return { added = d.added, modified = d.changed, removed = d.removed }
  end
end

return {
  { "nvim-tree/nvim-web-devicons", lazy = true },

  -- statusline
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    opts = {
      options = {
        theme = "auto", -- follows the active colorscheme
        icons_enabled = true,
        component_separators = { left = icon(0xe0b5), right = icon(0xe0b7) }, -- thin rounded
        section_separators = { left = icon(0xe0b4), right = icon(0xe0b6) }, -- rounded
        globalstatus = true, -- one statusline across splits
        disabled_filetypes = { statusline = { "snacks_dashboard" } },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", { "diff", source = gitsigns_diff }, "diagnostics" },
        lualine_c = { { "filename", path = 1 } }, -- path relative to cwd
        lualine_x = { { "lsp_status", symbols = { spinner = {}, done = "" } }, "filetype" }, -- fidget shows progress
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
      extensions = { "nvim-tree", "lazy", "mason" },
    },
  },

  -- tab style navigation
  {
    "akinsho/bufferline.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    keys = {
      { "<Tab>", "<Cmd>BufferLineCycleNext<CR>", desc = "Next buffer" },
      { "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", desc = "Previous buffer" },
    },
    opts = {
      options = {
        mode = "buffers", -- or "tabs"
        diagnostics = "nvim_lsp",
        separator_style = { "", "" }, -- no separators: tabs read as solid blocks
        tab_size = 24, -- wider tabs make the bar look roomier
        show_buffer_icons = true,
        show_close_icon = false,
        -- extra space after the file icon so it stands out more
        get_element_icon = function(element)
          if element.directory then
            return nil
          end -- let bufferline draw its folder icon
          local name = vim.fn.fnamemodify(element.path, ":t")
          local icon, hl = require("nvim-web-devicons").get_icon(name, nil, { default = true })
          return icon .. " ", hl
        end,

        -- set up the sidebar explorer
        offsets = {
          {
            filetype = "NvimTree",
            text = "File Explorer",
            highlight = "Directory",
            separator = true, -- use a "true" to enable the default, or set your own character
          },
        },
      },
      -- Style look: darker bar, active tab blends into the editor below it.
      -- A function so bufferline re-derives the colours on every :colorscheme.
      highlights = function(defaults)
        local hl = vim.deepcopy(defaults.highlights)
        local normal = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
        if not normal.bg then
          return hl
        end -- transparent theme: keep defaults
        local shade = require("bufferline.colors").shade_color
        local editor = string.format("#%06x", normal.bg)
        local fill, inactive = shade(editor, -25), shade(editor, -12)
        for name, group in pairs(hl) do
          if name == "fill" or name:find("^offset") then
            group.bg = fill
          elseif name:find("selected") then
            group.bg = editor
          elseif group.bg then
            group.bg = inactive
          end
          if name:find("separator") then
            group.fg = fill
          end
        end
        return hl
      end,
    },
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      indent = {
        char = "│",
      },
      scope = {
        enabled = true,
      },
    },
  },
}
