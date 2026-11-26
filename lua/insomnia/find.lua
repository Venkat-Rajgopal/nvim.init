-- File finding shared by <leader>ff (lua/plugins/telescope.lua) and the dashboard's projects.
local M = {}

-- What the finder never lists, even though it shows hidden and gitignored files. Names match at
-- any depth and may use globs (*.egg-info).
-- stylua: ignore
M.SKIP_DIRS = {
  -- version control
  ".git", ".svn", ".hg", ".jj",
  -- editors
  ".idea", ".vscode",
  -- dependencies and build output
  "node_modules", ".npm", "target", "dist", "build", "*.egg-info", ".next", ".terraform",
  -- Python
  ".venv", "venv", "__pycache__", ".pytest_cache", ".mypy_cache", ".ruff_cache", "*.ipynb_checkpoints",
  -- other caches
  ".cache", ".thumbs",
}

-- Files, not directories: OS clutter
M.SKIP_FILES = { ".DS_Store", "Thumbs.db" }

-- Telescope find_files in the current directory. Hidden (.github, .iac) and gitignored (local
-- notes, .env) files are included; everything in SKIP_DIRS and SKIP_FILES is not.
function M.files()
  local cmd = { "rg", "--files", "--hidden", "--no-ignore", "--color", "never" }
  for _, dir in ipairs(M.SKIP_DIRS) do
    vim.list_extend(cmd, { "--glob", "!**/" .. dir .. "/" })
  end
  for _, file in ipairs(M.SKIP_FILES) do
    vim.list_extend(cmd, { "--glob", "!**/" .. file })
  end
  require("telescope.builtin").find_files({ find_command = cmd })
end

-- Projects: git roots of recently opened files, most recent first.
function M.projects(limit)
  local dirs, seen = {}, {}
  for file in Snacks.dashboard.oldfiles() do
    local root = Snacks.git.get_root(file)
    if root and not seen[root] then
      seen[root] = true
      dirs[#dirs + 1] = root
      if #dirs >= limit then
        break
      end
    end
  end
  return dirs
end

-- Make `dir` the working directory (grep, finders and new terminals follow it) and show it in the
-- file tree, with the cursor in the tree. Already open, the tree switches to `dir`.
function M.open_project(dir)
  vim.cmd.cd(vim.fn.fnameescape(dir))
  require("nvim-tree.api").tree.open({ path = dir })
end

-- Telescope picker over recent projects; <CR> opens the project as above.
function M.pick_project()
  local actions, state = require("telescope.actions"), require("telescope.actions.state")
  require("telescope.pickers")
    .new({}, {
      prompt_title = "Projects",
      finder = require("telescope.finders").new_table({
        results = M.projects(30),
        entry_maker = function(dir)
          local shown = vim.fn.fnamemodify(dir, ":~")
          return { value = dir, display = shown, ordinal = shown }
        end,
      }),
      sorter = require("telescope.config").values.generic_sorter({}),
      attach_mappings = function(buf)
        actions.select_default:replace(function()
          local entry = state.get_selected_entry()
          actions.close(buf)
          if entry then
            M.open_project(entry.value)
          end
        end)
        return true
      end,
    })
    :find()
end

return M
