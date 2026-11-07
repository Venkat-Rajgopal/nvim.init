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
  before_init = function(_, config) config.settings.python.pythonPath = get_python_path(config.root_dir) end,
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

vim.lsp.enable("ruff")

if require("insomnia.platform").is_pi then
  -- ty replaces pyright on the Pi. It finds the interpreter by itself, in the same
  -- order as get_python_path, and only checks open files by default.
  vim.lsp.enable("ty")
elseif vim.fn.executable("pyright-langserver") == 1 or vim.fn.executable("npm") == 1 then
  -- Without npm, Mason can't install it (lua/plugins/lsp.lua): don't try to start it
  vim.lsp.enable("pyright")
end
