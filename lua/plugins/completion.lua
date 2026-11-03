return {
  {
    "saghen/blink.cmp",
    version = "1.*", -- release tags ship a prebuilt fuzzy matcher binary
    dependencies = { "rafamadriz/friendly-snippets" },
    event = { "InsertEnter", "CmdlineEnter" },
    opts = {
      -- Same keys as the old nvim-cmp setup
      keymap = {
        preset = "none",
        ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-e>"] = { "hide", "fallback" },
        ["<CR>"] = { "select_and_accept", "fallback" }, -- confirm, first item if none selected
        ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
        ["<C-b>"] = { "scroll_documentation_up", "fallback" },
        ["<C-f>"] = { "scroll_documentation_down", "fallback" },
      },
      completion = {
        list = { selection = { preselect = false, auto_insert = true } },
        menu = { border = "rounded" },
        documentation = { auto_show = true, window = { border = "rounded" } },
      },
      sources = {
        default = { "lazydev", "lsp", "path", "snippets", "buffer" },
        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            score_offset = 100, -- show lazydev items above lua_ls
          },
        },
      },
      cmdline = { enabled = true },
      fuzzy = { implementation = "prefer_rust_with_warning" },
    },
  },

  -- Neovim Lua API types for lua_ls (replaces neodev.nvim)
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
}
