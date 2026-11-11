# Languages and Python

The [language reference](/reference/languages) lists each server, formatter and linter. This page covers what isn't obvious from the list.

## Python uses uv

`basedpyright` picks the interpreter in this order:

1. `$VIRTUAL_ENV`: a venv you activated, or `uv run nvim`
2. `.venv/bin/python` in the project root, as `uv venv` and `uv sync` create
3. the system `python3`

For a new project: `uv init && uv sync`, then open nvim in that folder. After `uv sync`, run `:lsp restart`.

`ruff` lints, sorts imports and fixes on save (it also removes unused imports). `<leader>ca` offers quick fixes such as adding a missing import.

## Rust

`rust-analyzer` comes from rustup, not Mason: `rustup component add rust-analyzer`. Clippy runs on save.

## Formatting

Files are formatted on save, except Markdown (prettier would realign every table) and `lazy-lock.json`. Format those with `<leader>cf`. To save once without formatting: `:noautocmd w`.

## Add a language

1. Add its server to `servers` in `lua/plugins/lsp.lua` (`npm_servers` if Mason installs it with npm).
2. Create `lua/insomnia/lsp/<lang>.lua` with `vim.lsp.config(...)` and `vim.lsp.enable(...)`, and require it from `lua/insomnia/lsp/init.lua`.
3. For a formatter, add it to `formatters_by_ft` in `lua/plugins/formatting.lua`.
4. Add the parser to `lua/plugins/treesitter.lua`.
