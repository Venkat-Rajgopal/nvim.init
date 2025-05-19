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

  -- Try to find conda environment
  -- 1. Check for CONDA_PREFIX environment variable
  local conda_prefix = os.getenv("CONDA_PREFIX")
  if conda_prefix and #conda_prefix > 0 then
    local conda_python = conda_prefix .. "/bin/python"
    local conda_check = io.open(conda_python, "r")
    if conda_check ~= nil then
      io.close(conda_check)
      return conda_python
    end
  end
  -- 2. Check for environment.yml in workspace and try to infer env name
  local env_yml = workspace .. "/environment.yml"
  local env_yml_check = io.open(env_yml, "r")
  if env_yml_check ~= nil then
    io.close(env_yml_check)
    -- Try to guess the env name from the folder name
    local env_name = vim.fn.fnamemodify(workspace, ":t")
    -- Try to find the path to the environment in common conda locations
    local home = os.getenv("HOME")
    if home then
      local possible_path = home .. "/miniconda3/envs/" .. env_name .. "/bin/python"
      local conda_env_check = io.open(possible_path, "r")
      if conda_env_check ~= nil then
        io.close(conda_env_check)
        return possible_path
      end
      -- Try anaconda path too
      possible_path = home .. "/anaconda3/envs/" .. env_name .. "/bin/python"
      conda_env_check = io.open(possible_path, "r")
      if conda_env_check ~= nil then
        io.close(conda_env_check)
        return possible_path
      end
    end
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
