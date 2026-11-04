require("insomnia.options") -- vim.opt settings
require("insomnia.remap") -- <leader> mappings
require("insomnia.markdown") -- Markdown globals (must be set before vim-markdown loads)
require("insomnia.lazy") -- plugin setup
require("insomnia.theme").load() -- last chosen colorscheme
require("insomnia.lsp") -- LSP configuration
