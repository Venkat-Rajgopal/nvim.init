local lspconfig = require('lspconfig')

-- Helper function to find the Python executable in a Poetry/uv environment
local function get_python_path(workspace)
  -- Try to find Poetry environment
  local poetry_python = io.popen("cd " .. workspace .. " && poetry env info -p 2>/dev/null"):read('*a')
  if poetry_python and poetry_python ~= "" then
    return poetry_python:gsub("%s+$", "") .. "/bin/python"
  end
  
  -- Try to find uv environment (assuming .venv is used)
  local uv_python = workspace .. "/.venv/bin/python"
  local uv_check = io.open(uv_python, "r")
  if uv_check ~= nil then
    io.close(uv_check)
    return uv_python
  end
  
  -- Default to system Python if no virtual environment is found
  return vim.fn.exepath("python3") or vim.fn.exepath("python") or "python"
end

-- Configure Pyright (Python LSP)
lspconfig.pyright.setup({
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
