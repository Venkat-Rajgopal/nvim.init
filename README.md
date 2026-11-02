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
Requires Neovim **0.12+**, `git`, a C compiler, `tree-sitter-cli` (nvim-treesitter's main branch uses it to build parsers) and `ripgrep` (for `live_grep`).

### macOS

```shell
brew install neovim tree-sitter-cli ripgrep
xcode-select --install         # C compiler, if you don't have one yet
```

### Linux (Debian, Ubuntu, Raspberry Pi OS)

The Neovim package in `apt` is too old, so use the official release build. It is available for `x86_64` and `arm64`. On a Raspberry Pi this needs the **64-bit** Raspberry Pi OS; on 32-bit you would have to build Neovim from source.

```shell
# Build tools and helpers (unzip/curl are also used by Mason)
sudo apt update
sudo apt install -y git build-essential curl unzip ripgrep

# Neovim: pick the archive for your CPU
ARCH=$(uname -m)                       # x86_64 or aarch64
[ "$ARCH" = "aarch64" ] && ARCH=arm64
curl -LO "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-${ARCH}.tar.gz"
sudo rm -rf /opt/nvim-linux-${ARCH}
sudo tar -C /opt -xzf nvim-linux-${ARCH}.tar.gz
sudo ln -sf /opt/nvim-linux-${ARCH}/bin/nvim /usr/local/bin/nvim
nvim --version                         # should print 0.12 or newer

# tree-sitter CLI (the apt version is too old). Either:
npm install -g tree-sitter-cli         # needs Node.js
# or
cargo install --locked tree-sitter-cli # needs Rust (rustup.rs); slow on a Pi
```

To upgrade Neovim later on Linux, run the same Neovim commands again.

### Fonts

Icons in the file tree, statusline and dashboard need a [Nerd Font](https://www.nerdfonts.com/) set as your terminal font. On Linux that is the font of the terminal you connect from; on a Pi over SSH, it's the font on your laptop's terminal.
  
## Installation instructions
Clone this repo as the `nvim` dir inside `~/.config/`:

```shell
git clone git@github.com:Venkat-Rajgopal/nvim.init.git ~/.config/nvim
# or over HTTPS, if the machine (e.g. a Pi) has no GitHub SSH key:
git clone https://github.com/Venkat-Rajgopal/nvim.init.git ~/.config/nvim
```

Start `nvim`. On first launch lazy.nvim installs itself and every plugin, and the treesitter parsers are built. To do the install without opening the UI:

```shell
nvim --headless "+Lazy! sync" +qa
```

:rocket: That's it. Good to go.

## Plugin management (lazy.nvim)

Plugins are managed by [lazy.nvim](https://github.com/folke/lazy.nvim).

| Path | What it is |
| --- | --- |
| `lua/insomnia/lazy.lua` | Bootstraps and sets up lazy.nvim |
| `lua/plugins/*.lua` | Plugin specs, one file per area (`ui`, `editor`, `telescope`, `lsp`, ...) |
| `lazy-lock.json` | Pinned plugin versions. Commit it. |

### Commands

| Command | Action |
| --- | --- |
| `:Lazy` | Open the lazy.nvim window |
| `:Lazy sync` | Install missing, update, and clean. Run this when unsure. |
| `:Lazy update` | Update plugins and rewrite `lazy-lock.json` |
| `:Lazy install` | Install missing plugins only |
| `:Lazy clean` | Remove plugins no longer in any spec |
| `:Lazy restore` | Reset all plugins to the versions in `lazy-lock.json` |
| `:Lazy check` | Check for updates without installing them |
| `:Lazy log` | Show recent commits of installed plugins |
| `:Lazy profile` | Show startup time per plugin |
| `:Lazy health` | Same as `:checkhealth lazy` |
| `:Lazy build <plugin>` | Re-run a plugin's build step (e.g. `markdown-preview.nvim`) |
| `:Lazy load <plugin>` | Load a lazy-loaded plugin now |
| `:Lazy reload <plugin>` | Reload a plugin after changing its config |

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

| Command | Action |
| --- | --- |
| `:TSInstall <lang>` | Install a parser |
| `:TSUpdate` | Update all parsers |
| `:TSUninstall <lang>` | Remove a parser |
| `:InspectTree` | Show the syntax tree of the current buffer |
| `:checkhealth nvim-treesitter` | Check the CLI, compiler, and installed parsers |

### Health checks

| Command | Checks |
| --- | --- |
| `:checkhealth lazy` | lazy.nvim setup |
| `:checkhealth nvim-treesitter` | Treesitter requirements and parsers |
| `:checkhealth vim.lsp` | Attached language servers |
| `:Mason` | Installed LSP servers and tools |

## Key strokes

`<leader>` is `Space`.

- [Plugin management (lazy.nvim)](#plugin-management-lazynvim)
- [Basics](#basics)
- [Move](#move)
- [Select, copy, paste, delete](#select-copy-paste-delete)
- [Search and replace](#search-and-replace)
- [Windows and buffers](#windows-and-buffers)
- [Custom shortcuts](#custom-shortcuts)
- [LSP shortcuts](#lsp-shortcuts)
- [Completion (nvim-cmp)](#completion-nvim-cmp)

### Basics

| Keys | Mode | Action |
| --- | --- | --- |
| `i` / `a` | normal | Insert before / after cursor |
| `I` / `A` | normal | Insert at line start / end |
| `o` / `O` | normal | New line below / above and insert |
| `Esc` or `Ctrl-[` | any | Back to normal mode |
| `:w` / `:q` / `:wq` / `:q!` | normal | Save / quit / save and quit / quit without saving |
| `u` / `Ctrl-r` | normal | Undo / redo |
| `.` | normal | Repeat last change |

### Move

| Keys | Action |
| --- | --- |
| `h` `j` `k` `l` | Left / down / up / right |
| `w` / `b` / `e` | Next word / previous word / end of word |
| `0` / `^` / `$` | Line start / first non-blank / line end |
| `gg` / `G` | File start / file end |
| `{number}G` | Go to line number |
| `%` | Jump to matching bracket |
| `Ctrl-d` / `Ctrl-u` | Half page down / up |
| `{` / `}` | Previous / next paragraph |
| `Ctrl-o` / `Ctrl-i` | Jump back / forward in jump list |

### Select, copy, paste, delete

| Keys | Mode | Action |
| --- | --- | --- |
| `v` | normal | Visual select (characters) |
| `V` | normal | Visual select (whole lines) |
| `Ctrl-v` | normal | Visual block select |
| `ggVG` | normal | Select whole file |
| `viw` / `vip` | normal | Select word / paragraph |
| `yy` / `y` | normal / visual | Copy (yank) line / selection |
| `yiw` | normal | Copy word |
| `p` / `P` | normal | Paste after / before cursor |
| `dd` / `d` | normal / visual | Cut line / selection |
| `x` | normal | Delete character |
| `cw` / `ciw` | normal | Change word |
| `>>` / `<<` | normal | Indent / unindent line |
| `<leader>y` | normal | Copy line to system clipboard |
| `<leader>y` | visual | Copy selection to system clipboard |

### Search and replace

| Keys | Action |
| --- | --- |
| `/text` | Search forward in file |
| `?text` | Search backward in file |
| `n` / `N` | Next / previous match |
| `*` / `#` | Search word under cursor forward / backward |
| `:noh` | Clear search highlight |
| `:%s/old/new/g` | Replace all in file |
| `:%s/old/new/gc` | Replace all in file, confirm each |

### Windows and buffers

| Keys | Action |
| --- | --- |
| `Tab` / `Shift-Tab` | Next / previous buffer (bufferline) |
| `:bd` | Close current buffer |
| `:vsp` / `:sp` | Split vertical / horizontal |
| `Ctrl-w h/j/k/l` | Move between splits |
| `Ctrl-w q` | Close split |

### Custom shortcuts

| Keys | Action | Defined in |
| --- | --- | --- |
| `<leader>pv` | Open netrw file explorer | `lua/insomnia/remap.lua` |
| `<leader>e` | Toggle file tree | `lua/plugins/nvim-tree.lua` |
| `<leader>tt` | Switch focus between file tree and editor | `lua/plugins/nvim-tree.lua` |
| `<leader>gs` | Git status (fugitive) | `lua/plugins/editor.lua` |
| `<leader>pf` | Telescope: find files | `lua/plugins/telescope.lua` |
| `Ctrl-p` | Telescope: git files | `lua/plugins/telescope.lua` |
| `<leader>ps` | Telescope: live grep (needs `ripgrep`) | `lua/plugins/telescope.lua` |
| `Tab` / `Shift-Tab` | Next / previous buffer (bufferline) | `lua/plugins/ui.lua` |
| `<leader>mp` | Markdown preview start (markdown files only) | `lua/insomnia/markdown.lua` |
| `<leader>ms` | Markdown preview stop (markdown files only) | `lua/insomnia/markdown.lua` |

Inside a Telescope prompt: `Ctrl-n` / `Ctrl-p` move down / up, `Enter` open, `Ctrl-x` open in horizontal split, `Ctrl-v` open in vertical split, `Esc` close.

### LSP shortcuts

Defined in `lua/insomnia/lsp/handlers.lua` and set when a server attaches to a buffer. Currently only `rust_analyzer` and `marksman` pass `on_attach`, so Python (`pyright`) gets Neovim's built-in LSP defaults instead (`grn` rename, `gra` code action, `grr` references, `gri` implementation, `K` hover).

| Keys | Action |
| --- | --- |
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gi` | Go to implementation |
| `gr` | List references |
| `K` | Hover documentation |
| `Ctrl-k` | Signature help |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code action |
| `<leader>f` | Show diagnostics float for current line |
| `gl` | Show diagnostics float (rounded border) |
| `[d` / `]d` | Previous / next diagnostic |
| `<leader>q` | Put diagnostics in location list |

### Completion (nvim-cmp)

| Keys | Action |
| --- | --- |
| `Tab` / `Shift-Tab` | Next / previous item, or expand and jump in snippets |
| `Enter` | Confirm selected item |
| `Ctrl-Space` | Open completion menu |
| `Ctrl-e` | Close completion menu |
| `Ctrl-b` / `Ctrl-f` | Scroll documentation up / down |

