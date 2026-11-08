-- Formatter binaries come from Mason (see mason.nvim in lua/plugins/lsp.lua),
-- except rustfmt, which comes from rustup.

-- Files never formatted on save
local function skip_on_save(bufnr)
  -- lazy.nvim writes one plugin per line on purpose (small git diffs)
  if vim.api.nvim_buf_get_name(bufnr):match("lazy%-lock%.json$") then
    return true
  end
  -- prettier would realign every table; format Markdown on demand with <leader>cf
  return vim.bo[bufnr].filetype == "markdown"
end

return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    cmd = "ConformInfo",
    keys = {
      {
        "<leader>cf",
        function() require("conform").format({ async = true, lsp_format = "fallback" }) end,
        mode = { "n", "v" },
        desc = "Format buffer / selection",
      },
    },
    opts = {
      formatters_by_ft = {
        python = { "ruff_fix", "ruff_organize_imports", "ruff_format" }, -- fix lint (drops unused imports), sort, format
        lua = { "stylua" },
        rust = { "rustfmt" },
        json = { "jq" }, -- always expands; prettier keeps short objects on one line
        jsonc = { "prettier" }, -- jq can't parse comments
        yaml = { "prettier" },
        markdown = { "prettier" },
      },
      formatters = {
        jq = { args = { "--indent", "2", "." } }, -- 2 spaces regardless of shiftwidth
      },
      format_on_save = function(bufnr)
        if skip_on_save(bufnr) then
          return
        end
        return { timeout_ms = 500, lsp_format = "fallback" }
      end,
    },
  },
}
