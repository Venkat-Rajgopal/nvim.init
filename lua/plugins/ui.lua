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
        disabled_filetypes = { statusline = { "alpha" } },
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
        separator_style = "thin", -- "slant" draws blocks that clash with some themes
        show_buffer_icons = true,
        show_close_icon = false,

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
