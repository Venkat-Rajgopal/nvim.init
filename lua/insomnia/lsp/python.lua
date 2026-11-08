-- Python interpreter from uv: an active venv (`uv run`, `source .venv/bin/activate`),
-- else the project's .venv, else the system python3.
local function get_python_path(root)
  local venv = os.getenv("VIRTUAL_ENV")
  if venv and venv ~= "" then
    return venv .. "/bin/python"
  end

  local local_venv = (root or vim.fn.getcwd()) .. "/.venv/bin/python"
  if vim.uv.fs_stat(local_venv) then
    return local_venv
  end

  local system = vim.fn.exepath("python3")
  return system ~= "" and system or "python"
end

-- basedpyright: types, hover, go-to-definition, and "Add import" quick fixes
-- (plain pyright has no import code actions; that part of Pylance is closed source)
vim.lsp.config("basedpyright", {
  before_init = function(_, config) config.settings.python = { pythonPath = get_python_path(config.root_dir) } end,
  settings = {
    basedpyright = {
      analysis = {
        typeCheckingMode = "basic",
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "workspace",
      },
    },
  },
})

-- Ruff: linting, import sorting, quick fixes (hover is turned off in handlers.lua)
vim.lsp.config("ruff", {})

vim.lsp.enable("ruff")

if require("insomnia.platform").is_pi then
  -- ty replaces basedpyright on the Pi. It finds the interpreter by itself, in the same
  -- order as get_python_path, and only checks open files by default.
  vim.lsp.enable("ty")
else
  vim.lsp.enable("basedpyright")
end
