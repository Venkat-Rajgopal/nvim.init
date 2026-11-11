# Look and feel

## Themes

`<leader>th` opens a theme picker with live preview; `Enter` keeps it, `Esc` goes back. The choice is saved to `~/.local/share/nvim/last_theme` and restored on start. The default is `catppuccin-macchiato`; only it loads at startup. See the [theme list](/reference/themes).

- Switch from the command line: `:colorscheme tokyonight-moon` (also saved).
- Back to the default: delete `~/.local/share/nvim/last_theme`.
- Add a theme: add `{ "author/theme.nvim", lazy = true }` to `lua/plugins/colorscheme.lua`.

## Dashboard

`nvim` with no file opens the snacks.nvim dashboard: pixel art, shortcuts (`f` find, `g` grep, `r` recent, `e` tree, `c` config, `L` Lazy, `q` quit) and your 5 most recent files (`1`–`5`).

### Changing the art

There are 12 pieces: `alien`, `bonsai`, `cactus`, `cat`, `coffee`, `fox`, `moon`, `mountains`, `mushroom`, `neovim`, `owl` (the default) and `rocket`.

- **Try one for this session:** `:DashboardArt <name>` (Tab completes the names). It is forgotten when Neovim quits.
- **Keep one for every launch:** edit the `art` line at the top of `lua/plugins/dashboard.lua` and restart Neovim:

  ```lua
  local art = "fox" -- any name from the list above
  ```

  An unknown name falls back to `moon`.

### Drawing your own

The templates are in `lua/insomnia/dashboard_art.lua`. Each character in `rows` is one pixel, coloured by its entry in `colors` (a space is empty); two pixel rows share a terminal line (`▀`), so pixels come out square. `accent` colours the title under the art. Add a new entry to `M.art` and it shows up in `:DashboardArt` straight away. The owl on this site is drawn from the same template.

## Statusline and file tree

The statusline (lualine) is one bar across all splits: mode, branch, diff counts, diagnostics, path, language servers, filetype and position. It follows the theme.

The file tree (`<leader>e`) colours names by git status and hides `.git`, `node_modules`, `__pycache__` and `.DS_Store`; press `U` in the tree to show them. `<leader>tt` switches focus between the tree and the editor.

## Completion

[blink.cmp](https://github.com/saghen/blink.cmp) shows a menu while you type and on the `:` line. Sources, in priority order: Neovim Lua API (in Lua files), language server, file paths, [friendly-snippets](https://github.com/rafamadriz/friendly-snippets), words from open buffers. Its keys are in the [keymaps reference](/reference/keymaps#completion-menu).
