-- Linters for files without a linting language server.
-- Python is linted by the ruff language server (lua/insomnia/lsp/python.lua).
return {
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufNewFile", "BufWritePost" },
    config = function()
      local lint = require("lint")

      lint.linters_by_ft = {
        markdown = { "markdownlint" },
      }

      -- MD013 (line length) is noise for prose and tables
      lint.linters.markdownlint.args = { "--stdin", "--disable", "MD013" }

      -- markdownlint may be missing: Mason is still installing it, or there's no npm
      -- (lua/plugins/lsp.lua warns about that once, this would error on every event)
      local function try_lint() lint.try_lint(nil, { ignore_errors = true }) end

      vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave" }, {
        group = vim.api.nvim_create_augroup("insomnia_lint", { clear = true }),
        callback = try_lint,
      })

      -- Lint the buffer that triggered loading
      try_lint()
    end,
  },
}
