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
Requires standard neo-vim installed. In Mac you can do;

```shell
brew install neo-vim
```
Aditionally, `live_grep` requires `ripgrep` to be installed. `brew install ripgrep`. 
  
## Installation instructions
Clone this repo in `.config/` dir and clone it as `nvim` dir. For the first time you, invoke `:PackerSync` to sync all packages. 

:rocket: That's it. Good to go.

## Key strokes

`<leader>` is `Space`.

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
| `<leader>e` | Toggle file tree | `after/plugin/nvimtree-config.lua` |
| `<leader>tt` | Switch focus between file tree and editor | `after/plugin/nvimtree-config.lua` |
| `<leader>gs` | Git status (fugitive) | `after/plugin/fugitive.lua` |
| `<leader>pf` | Telescope: find files | `after/plugin/telescope.lua` |
| `Ctrl-p` | Telescope: git files | `after/plugin/telescope.lua` |
| `<leader>ps` | Telescope: live grep (needs `ripgrep`) | `after/plugin/telescope.lua` |
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

