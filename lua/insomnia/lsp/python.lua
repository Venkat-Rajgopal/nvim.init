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

-- Pyright: types, hover, go-to-definition
vim.lsp.config("pyright", {
  before_init = function(_, config)
    config.settings.python.pythonPath = get_python_path(config.root_dir)
  end,
  settings = {
    python = {
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

vim.lsp.enable({ "pyright", "ruff" })
