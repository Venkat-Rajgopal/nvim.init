local parsers = {
  "rust",
  "python",
  "c",
  "lua",
  "vim",
  "vimdoc",
  "query",
  "markdown",
  "markdown_inline",
  "json",
  "toml",
}

return {
  {
    -- main branch: rewrite for Neovim 0.12, needs the tree-sitter CLI to build parsers
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false, -- main does not support lazy-loading
    build = ":TSUpdate",
    config = function()
      -- Build only parsers that are missing, and only if the tree-sitter CLI exists;
      -- otherwise every missing parser fails with "tree-sitter build … ENOENT"
      local installed = require("nvim-treesitter.config").get_installed("parsers")
      local missing = vim.tbl_filter(function(lang) return not vim.list_contains(installed, lang) end, parsers)

      if #missing > 0 then
        if vim.fn.executable("tree-sitter") == 1 then
          -- The Pi can run out of memory with a compiler per parser at once
          local max_jobs = require("insomnia.platform").is_pi and 2 or nil
          local task = require("nvim-treesitter").install(missing, { max_jobs = max_jobs })
          -- Headless (install.sh): finish first, exiting mid-build leaves broken temp files
          if #vim.api.nvim_list_uis() == 0 then
            task:pwait(30 * 60 * 1000)
          end
        else
          vim.notify(
            "tree-sitter CLI not found; can't build parsers: "
              .. table.concat(missing, ", ")
              .. "\nInstall it: brew install tree-sitter-cli | npm i -g tree-sitter-cli"
              .. " | cargo install --locked tree-sitter-cli",
            vim.log.levels.WARN
          )
        end
      end

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("insomnia_treesitter", { clear = true }),
        callback = function(ev)
          -- start() errors when no parser exists for this filetype
          if pcall(vim.treesitter.start, ev.buf) then
            vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
}
