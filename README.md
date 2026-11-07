```
                                      █
                                     ██   █
                                   █ ███ ██
                                   ████████
                                  █████████
                                   ███████
                                     ███

███╗   ██╗  ██╗   ██╗  ██╗  ███╗   ███╗       ██╗  ███╗   ██╗  ██╗  ████████╗
████╗  ██║  ██║   ██║  ██║  ████╗ ████║       ██║  ████╗  ██║  ██║  ╚══██╔══╝
██╔██╗ ██║  ██║   ██║  ██║  ██╔████╔██║       ██║  ██╔██╗ ██║  ██║     ██║
██║╚██╗██║  ╚██╗ ██╔╝  ██║  ██║╚██╔╝██║       ██║  ██║╚██╗██║  ██║     ██║
██║ ╚████║   ╚████╔╝   ██║  ██║ ╚═╝ ██║  ██╗  ██║  ██║ ╚████║  ██║     ██║
╚═╝  ╚═══╝    ╚═══╝    ╚═╝  ╚═╝     ╚═╝  ╚═╝  ╚═╝  ╚═╝  ╚═══╝  ╚═╝     ╚═╝
```

# :fire: nvim.init

Custom Neo Vim Configurations

## Requirements

Requires Neovim **0.12+**, `git`, a C compiler, `tree-sitter-cli` (nvim-treesitter's main branch uses it to build parsers), `ripgrep` (for `live_grep`) and **Node.js 22+** with `npm` (Mason uses it to install `pyright`, `jsonls`, `prettier` and `markdownlint`; without it these are skipped with one warning on startup).

On a **Raspberry Pi**, follow [README-pi.md](README-pi.md) instead: `install.sh` sets everything up, and the Pi uses `ty` rather than `pyright`.

### macOS

```shell
brew install neovim tree-sitter-cli ripgrep node
xcode-select --install         # C compiler, if you don't have one yet
```

### Linux (Debian, Ubuntu)

On `apt` systems (`x86_64` or `arm64`), `install.sh` does the whole setup: it installs whatever is missing, puts the config in `~/.config/nvim`, installs the plugins and builds the parsers.

```shell
sudo apt update && sudo apt install -y git
git clone https://github.com/Venkat-Rajgopal/nvim.init.git ~/.config/nvim
~/.config/nvim/install.sh
```

To only see what's missing, without changing anything:

```shell
~/.config/nvim/install.sh --check
```

The script leaves a recent enough Neovim alone. To upgrade to the latest release later:

```shell
sudo rm /usr/local/bin/nvim && ~/.config/nvim/install.sh
```

### Fonts

Icons in the file tree, statusline and dashboard need a [Nerd Font](https://www.nerdfonts.com/) set as your terminal font. On Linux that is the font of the terminal you connect from; on a Pi over SSH, it's the font on your laptop's terminal.

## Installation instructions

On Linux, `install.sh` has already done this. On macOS, clone this repo as the `nvim` dir inside `~/.config/`:

```shell
git clone git@github.com:Venkat-Rajgopal/nvim.init.git ~/.config/nvim
# or over HTTPS, if the machine has no GitHub SSH key:
git clone https://github.com/Venkat-Rajgopal/nvim.init.git ~/.config/nvim
```

Start `nvim`. On first launch lazy.nvim installs itself and every plugin, and the treesitter parsers are built. To do the install without opening the UI:

```shell
nvim --headless "+Lazy! sync" +qa
```

:rocket: That's it. Good to go.

## Plugin management (lazy.nvim)

Plugins are managed by [lazy.nvim](https://github.com/folke/lazy.nvim).

| Path                        | What it is                                                                                                                        |
| --------------------------- | --------------------------------------------------------------------------------------------------------------------------------- |
| `install.sh`                | Sets up Debian, Ubuntu and Raspberry Pi OS                                                                                        |
| `init.lua`                  | Sets `<leader>` and loads `lua/insomnia`                                                                                          |
| `lua/insomnia/options.lua`  | Editor settings (`vim.opt`)                                                                                                       |
| `lua/insomnia/theme.lua`    | Restores the last chosen colorscheme                                                                                              |
| `lua/insomnia/remap.lua`    | Global keymaps                                                                                                                    |
| `lua/insomnia/platform.lua` | Detects the Raspberry Pi                                                                                                          |
| `lua/insomnia/lazy.lua`     | Bootstraps and sets up lazy.nvim                                                                                                  |
| `lua/insomnia/lsp/`         | Language server setup (Python, Rust, Markdown)                                                                                    |
| `lua/plugins/*.lua`         | Plugin specs, one file per area (`ui`, `editor`, `git`, `telescope`, `which-key`, `completion`, `lsp`, `formatting`, `lint`, ...) |
| `.stylua.toml`              | Lua formatting style for this config (2 spaces, 120 columns)                                                                      |
| `lazy-lock.json`            | Pinned plugin versions. Commit it.                                                                                                |

### Commands

| Command                 | Action                                                      |
| ----------------------- | ----------------------------------------------------------- |
| `:Lazy`                 | Open the lazy.nvim window                                   |
| `:Lazy sync`            | Install missing, update, and clean. Run this when unsure.   |
| `:Lazy update`          | Update plugins and rewrite `lazy-lock.json`                 |
| `:Lazy install`         | Install missing plugins only                                |
| `:Lazy clean`           | Remove plugins no longer in any spec                        |
| `:Lazy restore`         | Reset all plugins to the versions in `lazy-lock.json`       |
| `:Lazy check`           | Check for updates without installing them                   |
| `:Lazy log`             | Show recent commits of installed plugins                    |
| `:Lazy profile`         | Show startup time per plugin                                |
| `:Lazy health`          | Same as `:checkhealth lazy`                                 |
| `:Lazy build <plugin>`  | Re-run a plugin's build step (e.g. `markdown-preview.nvim`) |
| `:Lazy load <plugin>`   | Load a lazy-loaded plugin now                               |
| `:Lazy reload <plugin>` | Reload a plugin after changing its config                   |

Keys inside the `:Lazy` window: `I` install, `U` update, `S` sync, `X` clean, `C` check, `L` log, `R` restore, `P` profile, `D` debug, `?` help, `q` close. Press `Enter` on a plugin for its details.

### Workflow

- **Update:** `:Lazy update`, try things out, then commit `lazy-lock.json`.
- **Roll back a bad update:** `git checkout lazy-lock.json`, then `:Lazy restore`.
- **Add a plugin:** add a spec to a file in `lua/plugins/` and restart. It installs automatically.
- **Remove a plugin:** delete its spec, restart, then `:Lazy clean`.

A minimal spec, loaded only when needed:

```lua
-- lua/plugins/example.lua
return {
  {
    "author/plugin.nvim",
    event = "VeryLazy",            -- or: cmd = "Cmd", ft = "python", keys = { ... }
    keys = {
      { "<leader>x", "<cmd>Cmd<CR>", desc = "Do the thing" },
    },
    opts = {},                     -- passed to require("plugin").setup(opts)
  },
}
```

### Treesitter

Parsers are listed in `lua/plugins/treesitter.lua`.

| Command                        | Action                                         |
| ------------------------------ | ---------------------------------------------- |
| `:TSInstall <lang>`            | Install a parser                               |
| `:TSUpdate`                    | Update all parsers                             |
| `:TSUninstall <lang>`          | Remove a parser                                |
| `:InspectTree`                 | Show the syntax tree of the current buffer     |
| `:checkhealth nvim-treesitter` | Check the CLI, compiler, and installed parsers |

On startup, only missing parsers are built. If the `tree-sitter` CLI isn't installed, you get one warning listing the missing parsers instead of build errors; install the CLI (see [Requirements](#requirements)) and restart.

**Troubleshooting** `Error during tree-sitter build … ENOENT`: run `tree-sitter --version` and `:checkhealth nvim-treesitter`. If the CLI is fine, the parser download probably failed (network); retry with `:TSInstall! <lang>`.

### Health checks

| Command                        | Checks                                                 |
| ------------------------------ | ------------------------------------------------------ |
| `:checkhealth lazy`            | lazy.nvim setup                                        |
| `:checkhealth nvim-treesitter` | Treesitter requirements and parsers                    |
| `:checkhealth vim.lsp`         | Attached language servers                              |
| `:checkhealth blink.cmp`       | Completion setup and fuzzy matcher binary              |
| `:ConformInfo`                 | Formatters for the current file, and the formatter log |
| `:Mason`                       | Installed LSP servers and tools                        |

## Key strokes

`<leader>` is `Space`.

- [Plugin management (lazy.nvim)](#plugin-management-lazynvim)
- [Editor options](#editor-options)
- [Basics](#basics)
- [Move](#move)
- [Select, copy, paste, delete](#select-copy-paste-delete)
- [Search and replace](#search-and-replace)
- [Windows and buffers](#windows-and-buffers)
- [Custom shortcuts](#custom-shortcuts)
- [LSP shortcuts](#lsp-shortcuts)
- [Completion (blink.cmp)](#completion-blinkcmp)
- [Formatting and linting](#formatting-and-linting)
- [Themes](#themes)

### Editor options

Set in `lua/insomnia/options.lua`. The ones you'll notice:

| Option                      | Effect                                                                            |
| --------------------------- | --------------------------------------------------------------------------------- |
| `number` + `relativenumber` | Absolute number on the cursor line, relative elsewhere (use with `5j`, `3k`, ...) |
| `expandtab`, `shiftwidth=4` | Indent with 4 spaces                                                              |
| `ignorecase` + `smartcase`  | `/foo` matches any case, `/Foo` matches exactly                                   |
| `undofile`                  | Undo history survives closing the file                                            |
| `splitright` + `splitbelow` | `:vsp` opens right, `:sp` opens below                                             |
| `scrolloff=8`               | Keeps 8 lines visible above / below the cursor                                    |
| `wrap=false`                | Long lines don't wrap                                                             |
| `mouse=a`                   | Mouse works in all modes                                                          |
| clipboard not shared        | Use `<leader>y` to copy to the system clipboard                                   |

Check any option with `:set <name>?`, e.g. `:set shiftwidth?`.

### Basics

| Keys                        | Mode   | Action                                            |
| --------------------------- | ------ | ------------------------------------------------- |
| `i` / `a`                   | normal | Insert before / after cursor                      |
| `I` / `A`                   | normal | Insert at line start / end                        |
| `o` / `O`                   | normal | New line below / above and insert                 |
| `Esc` or `Ctrl-[`           | any    | Back to normal mode                               |
| `:w` / `:q` / `:wq` / `:q!` | normal | Save / quit / save and quit / quit without saving |
| `u` / `Ctrl-r`              | normal | Undo / redo                                       |
| `.`                         | normal | Repeat last change                                |

### Move

| Keys                | Action                                  |
| ------------------- | --------------------------------------- |
| `h` `j` `k` `l`     | Left / down / up / right                |
| `w` / `b` / `e`     | Next word / previous word / end of word |
| `0` / `^` / `$`     | Line start / first non-blank / line end |
| `gg` / `G`          | File start / file end                   |
| `{number}G`         | Go to line number                       |
| `%`                 | Jump to matching bracket                |
| `Ctrl-d` / `Ctrl-u` | Half page down / up                     |
| `{` / `}`           | Previous / next paragraph               |
| `Ctrl-o` / `Ctrl-i` | Jump back / forward in jump list        |

### Select, copy, paste, delete

| Keys          | Mode            | Action                             |
| ------------- | --------------- | ---------------------------------- |
| `v`           | normal          | Visual select (characters)         |
| `V`           | normal          | Visual select (whole lines)        |
| `Ctrl-v`      | normal          | Visual block select                |
| `ggVG`        | normal          | Select whole file                  |
| `viw` / `vip` | normal          | Select word / paragraph            |
| `yy` / `y`    | normal / visual | Copy (yank) line / selection       |
| `yiw`         | normal          | Copy word                          |
| `p` / `P`     | normal          | Paste after / before cursor        |
| `dd` / `d`    | normal / visual | Cut line / selection               |
| `x`           | normal          | Delete character                   |
| `cw` / `ciw`  | normal          | Change word                        |
| `>>` / `<<`   | normal          | Indent / unindent line             |
| `<leader>y`   | normal          | Copy line to system clipboard      |
| `<leader>y`   | visual          | Copy selection to system clipboard |

### Search and replace

| Keys             | Action                                      |
| ---------------- | ------------------------------------------- |
| `/text`          | Search forward in file                      |
| `?text`          | Search backward in file                     |
| `n` / `N`        | Next / previous match                       |
| `*` / `#`        | Search word under cursor forward / backward |
| `:noh`           | Clear search highlight                      |
| `:%s/old/new/g`  | Replace all in file                         |
| `:%s/old/new/gc` | Replace all in file, confirm each           |

### Windows and buffers

| Keys                | Action                              |
| ------------------- | ----------------------------------- |
| `Tab` / `Shift-Tab` | Next / previous buffer (bufferline) |
| `:bd`               | Close current buffer                |
| `:vsp` / `:sp`      | Split vertical / horizontal         |
| `Ctrl-w h/j/k/l`    | Move between splits                 |
| `Ctrl-w q`          | Close split                         |

### Custom shortcuts

Press `<leader>` (Space) and wait: [which-key](https://github.com/folke/which-key.nvim) pops up with every key that can follow, grouped (`c` code, `f` find, `g` git, `m` markdown, `p` project, `r` refactor, `t` toggle). It waits for you, so there is no time limit. The same works for `g`, `[`, `]`, `"` (registers) and `` ` `` (marks). `<leader>?` lists the mappings of the current buffer only.

Find (Telescope, `lua/plugins/telescope.lua`, grep needs `ripgrep`):

| Keys                        | Action                 |
| --------------------------- | ---------------------- |
| `<leader>ff` / `<leader>pf` | Find files             |
| `Ctrl-p`                    | Git files              |
| `<leader>fg` / `<leader>ps` | Grep in project        |
| `<leader>fw`                | Grep word under cursor |
| `<leader>fb`                | Open buffers           |
| `<leader>fr`                | Recent files           |
| `<leader>fs`                | Symbols in file (LSP)  |
| `<leader>fd`                | Diagnostics            |
| `<leader>fh`                | Help pages             |
| `<leader>fk`                | Keymaps                |

Inside a Telescope prompt: `Ctrl-n` / `Ctrl-p` move down / up, `Enter` open, `Ctrl-x` open in horizontal split, `Ctrl-v` open in vertical split, `Esc` close.

Git (`lua/plugins/git.lua`). Changed lines are marked in the sign column by gitsigns.

| Keys         | Action                                                               |
| ------------ | -------------------------------------------------------------------- |
| `]h` / `[h`  | Next / previous changed hunk                                         |
| `<leader>gp` | Preview hunk (what changed)                                          |
| `<leader>gr` | Reset hunk (undo the change)                                         |
| `<leader>gb` | Blame line                                                           |
| `<leader>tb` | Toggle inline blame on the current line                              |
| `<leader>gd` | Diff file against the index                                          |
| `<leader>gs` | Git status (fugitive): `s` stage, `u` unstage, `=` diff, `cc` commit |

Other:

| Keys                | Action                                         | Defined in                   |
| ------------------- | ---------------------------------------------- | ---------------------------- |
| `<leader>e`         | Toggle file tree                               | `lua/plugins/nvim-tree.lua`  |
| `<leader>tt`        | Switch focus between file tree and editor      | `lua/plugins/nvim-tree.lua`  |
| `<leader>pv`        | Open netrw file explorer                       | `lua/insomnia/remap.lua`     |
| `Tab` / `Shift-Tab` | Next / previous buffer (bufferline)            | `lua/plugins/ui.lua`         |
| `<leader>cf`        | Format buffer, or the selection in visual mode | `lua/plugins/formatting.lua` |
| `<leader>th`        | Theme picker (live preview, remembered)        | `lua/plugins/telescope.lua`  |
| `<leader>mp`        | Markdown preview start (markdown files only)   | `lua/insomnia/markdown.lua`  |
| `<leader>ms`        | Markdown preview stop (markdown files only)    | `lua/insomnia/markdown.lua`  |

### LSP shortcuts

Set in `lua/insomnia/lsp/handlers.lua` for every language server when it attaches to a buffer.

| Keys         | Action                                          |
| ------------ | ----------------------------------------------- |
| `gd`         | Go to definition                                |
| `gD`         | Go to declaration                               |
| `gi`         | Go to implementation                            |
| `gr`         | List references                                 |
| `K`          | Hover documentation                             |
| `Ctrl-k`     | Signature help                                  |
| `<leader>rn` | Rename symbol                                   |
| `<leader>ca` | Code action (e.g. ruff fixes, organize imports) |
| `gl`         | Show diagnostics for the current line           |
| `[d` / `]d`  | Previous / next diagnostic (opens the float)    |
| `<leader>q`  | Put diagnostics in location list                |
| `Ctrl-o`     | Jump back after `gd` / `gi`                     |

Neovim's built-in LSP keys also work: `grn` rename, `gra` code action, `grr` references, `gri` implementation, `gO` document symbols, `Ctrl-s` signature help in insert mode. Because `gr` is mapped too, Neovim waits briefly after `gr` to see if you meant one of these.

#### Language servers

Installed by Mason (`:Mason`) and enabled in `lua/insomnia/lsp/`.

| Language | Server                                                                                             | File               |
| -------- | -------------------------------------------------------------------------------------------------- | ------------------ |
| Python   | `pyright` (`ty` on the Pi: types, hover, navigation) + `ruff` (lint, import sorting, fixes)        | `lsp/python.lua`   |
| Rust     | `rust_analyzer` (clippy on save), **from rustup, not Mason**: `rustup component add rust-analyzer` | `lsp/rust.lua`     |
| Markdown | `marksman`                                                                                         | `lsp/markdown.lua` |
| Lua      | `lua_ls` (+ lazydev for Neovim API types)                                                          | `lsp/lua.lua`      |
| JSON     | `jsonls` (validation)                                                                              | `lsp/json.lua`     |

**Python uses uv only.** Pyright picks the interpreter in this order:

1. `$VIRTUAL_ENV`, i.e. a venv you activated (`source .venv/bin/activate`) or started nvim under (`uv run nvim`)
2. `.venv/bin/python` in the project root (what `uv venv` / `uv sync` create)
3. the system `python3`

So for a new project: `uv init && uv sync`, then open nvim in that folder.

To add a language: add its server to `servers` in `lua/plugins/lsp.lua` (or `npm_servers` if Mason installs it with npm), create `lua/insomnia/lsp/<lang>.lua` with `vim.lsp.config(...)` and `vim.lsp.enable(...)`, and require it from `lua/insomnia/lsp/init.lua`.

| Command                | Action                                                            |
| ---------------------- | ----------------------------------------------------------------- |
| `:checkhealth vim.lsp` | Servers attached to the buffer, and their settings                |
| `:lsp restart`         | Restart servers for the buffer (e.g. after `uv sync`)             |
| `:Mason`               | Install / update servers (`i` install, `u` update, `X` uninstall) |

### Completion (blink.cmp)

Configured in `lua/plugins/completion.lua` with [blink.cmp](https://github.com/saghen/blink.cmp). The menu opens while you type in insert mode and on the `:` command line.

| Keys                | Action                                                                    |
| ------------------- | ------------------------------------------------------------------------- |
| `Tab` / `Shift-Tab` | Next / previous item; inside a snippet, jump to the next / previous field |
| `Enter`             | Accept the selected item, or the first one if none is selected            |
| `Ctrl-Space`        | Open the menu, or toggle the documentation window                         |
| `Ctrl-e`            | Close the menu                                                            |
| `Ctrl-b` / `Ctrl-f` | Scroll documentation up / down                                            |

Sources, in priority order:

| Source     | Gives you                                                                                              |
| ---------- | ------------------------------------------------------------------------------------------------------ |
| `lazydev`  | Neovim Lua API (`vim.api`, `vim.uv`, ...), in Lua files only                                           |
| `lsp`      | Language server suggestions                                                                            |
| `path`     | File paths, after typing `./`, `../`, `~/` or `/`                                                      |
| `snippets` | [friendly-snippets](https://github.com/rafamadriz/friendly-snippets), e.g. `def`, `class`, `fn`, `for` |
| `buffer`   | Words from open buffers                                                                                |

To turn off `:` command-line completion, set `cmdline = { enabled = false }` in `lua/plugins/completion.lua`.

### Formatting and linting

Files are formatted when you save, by [conform.nvim](https://github.com/stevearc/conform.nvim) (`lua/plugins/formatting.lua`). `<leader>cf` formats on demand.

| Files       | Formatter                                                                     | Installed by                      |
| ----------- | ----------------------------------------------------------------------------- | --------------------------------- |
| Python      | `ruff` (sort imports, then format)                                            | Mason                             |
| Lua         | `stylua`, using `.stylua.toml` when the project has one                       | Mason                             |
| Rust        | `rustfmt`                                                                     | rustup                            |
| JSON        | `jq` (always expanded, 2 spaces)                                              | macOS built-in / `apt install jq` |
| JSONC, YAML | `prettier`                                                                    | Mason                             |
| Markdown    | `prettier`, **only with `<leader>cf`** (on save it would realign every table) | Mason                             |

Never formatted on save: `lazy-lock.json`. lazy.nvim keeps it one plugin per line so git diffs stay small.

Other file types fall back to the language server's formatter, if it has one.

Linting comes from the language servers (pyright, ruff, rust-analyzer, lua_ls, jsonls), plus [nvim-lint](https://github.com/mfussenegger/nvim-lint) running `markdownlint` on Markdown (`lua/plugins/lint.lua`, line-length rule MD013 off). Lint results show up as normal diagnostics, so `gl`, `[d` / `]d` work on them.

| Command        | Action                                                                                         |
| -------------- | ---------------------------------------------------------------------------------------------- |
| `<leader>cf`   | Format now                                                                                     |
| `:ConformInfo` | Which formatter runs for this file, and errors                                                 |
| `:noautocmd w` | Save once **without** formatting                                                               |
| `:Mason`       | Install / update `stylua`, `prettier`, `markdownlint` (installed automatically on first start) |

To add a formatter: install it (`:Mason` or your package manager) and add it to `formatters_by_ft` in `lua/plugins/formatting.lua`.

### Themes

Press `<leader>th` to pick a colorscheme. Moving through the list previews each one live; `Enter` keeps it, `Esc` goes back. The choice is saved to `~/.local/share/nvim/last_theme` and restored on the next start. The statusline (`theme = "auto"`) follows the active theme; the dashboard flame keeps its own colours.

| Theme                                                          | Variants                                    | Style                   |
| -------------------------------------------------------------- | ------------------------------------------- | ----------------------- |
| [catppuccin](https://github.com/catppuccin/nvim) (default)     | `-macchiato`, `-mocha`, `-frappe`, `-latte` | Soft pastel             |
| [tokyonight](https://github.com/folke/tokyonight.nvim)         | `-night`, `-storm`, `-moon`, `-day`         | Cool blues and purples  |
| [kanagawa](https://github.com/rebelot/kanagawa.nvim)           | `-wave`, `-dragon`, `-lotus`                | Muted, Hokusai-inspired |
| [rose-pine](https://github.com/rose-pine/neovim)               | `-main`, `-moon`, `-dawn`                   | Low contrast, warm      |
| [cyberdream](https://github.com/scottmckendry/cyberdream.nvim) | `-light`, `-muted`                          | High contrast, neon     |
| [everforest](https://github.com/sainnhe/everforest)            |                                             | Green, easy on the eyes |
| [nordic](https://github.com/AlexvZyl/nordic.nvim)              |                                             | Darker, warmer Nord     |

Light variants: `catppuccin-latte`, `tokyonight-day`, `kanagawa-lotus`, `rose-pine-dawn`, `cyberdream-light`.

Only catppuccin loads at startup. The others are loaded by lazy.nvim the first time you pick them, so they don't slow startup.

- **Switch from the command line:** `:colorscheme tokyonight-moon` (also saved).
- **Back to the default:** `:colorscheme catppuccin-macchiato`, or delete `~/.local/share/nvim/last_theme`.
- **Add a theme:** add `{ "author/theme.nvim", lazy = true }` to `lua/plugins/colorscheme.lua` and restart; it shows up in the picker.
