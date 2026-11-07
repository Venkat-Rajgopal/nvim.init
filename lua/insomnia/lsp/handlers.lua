-- Diagnostics, borders, capabilities and LSP keymaps for every server.
local icon = vim.fn.nr2char -- Nerd Font glyphs by codepoint
local severity = vim.diagnostic.severity

vim.diagnostic.config({
  virtual_text = true,
  signs = {
    text = {
      [severity.ERROR] = icon(0xf057),
      [severity.WARN] = icon(0xf071),
      [severity.HINT] = icon(0xf0eb),
      [severity.INFO] = icon(0xf05a),
    },
  },
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  float = {
    focusable = false,
    style = "minimal",
    source = true,
    header = "",
    prefix = "",
  },
})

-- Rounded borders for hover, signature help, diagnostic floats (Neovim 0.11+)
vim.o.winborder = "rounded"

-- Completion capabilities from blink.cmp, applied to every server
vim.lsp.config("*", {
  capabilities = require("blink.cmp").get_lsp_capabilities(),
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("insomnia_lsp_attach", { clear = true }),
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)

    -- pyright (ty on the Pi) handles hover for Python; ruff only lints, formats and fixes
    if client and client.name == "ruff" then
      client.server_capabilities.hoverProvider = false
    end

    local function map(keys, fn, desc)
      vim.keymap.set("n", keys, fn, { buffer = ev.buf, silent = true, desc = "LSP: " .. desc })
    end

    map("gd", vim.lsp.buf.definition, "Go to definition")
    map("gD", vim.lsp.buf.declaration, "Go to declaration")
    map("gi", vim.lsp.buf.implementation, "Go to implementation")
    map("gr", vim.lsp.buf.references, "List references")
    map("K", vim.lsp.buf.hover, "Hover documentation")
    map("<C-k>", vim.lsp.buf.signature_help, "Signature help")
    map("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
    map("<leader>ca", vim.lsp.buf.code_action, "Code action")
    map("gl", vim.diagnostic.open_float, "Line diagnostics")
    map("[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, "Previous diagnostic")
    map("]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, "Next diagnostic")
    map("<leader>q", vim.diagnostic.setloclist, "Diagnostics to location list")
  end,
})
