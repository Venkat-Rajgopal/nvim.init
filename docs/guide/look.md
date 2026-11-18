# Look and feel

## Themes

`<leader>th` opens a theme picker with live preview; `Enter` keeps it, `Esc` goes back. The choice is saved to `~/.local/share/nvim/last_theme` and restored on start. The default is `catppuccin-macchiato`; only it loads at startup. See the [theme list](/reference/themes).

- Switch from the command line: `:colorscheme tokyonight-moon` (also saved).
- Back to the default: delete `~/.local/share/nvim/last_theme`.
- Add a theme: add `{ "author/theme.nvim", lazy = true }` to `lua/plugins/colorscheme.lua`.

## Color schemes for iTerm

Neovim draws its own colours (`termguicolors`), so iTerm's colours only show in the shell and the thin padding around the editor. Give your iTerm profile the same colours as the theme you use most, and nothing changes colour when you open or quit Neovim.

| Theme | iTerm preset | Download |
| --- | --- | --- |
| `catppuccin-macchiato` (default) | `catppuccin-macchiato.itermcolors` | [catppuccin/iterm](https://github.com/catppuccin/iterm/tree/main/colors) |
| `catppuccin-mocha` / `-frappe` / `-latte` | `catppuccin-<flavour>.itermcolors` | [catppuccin/iterm](https://github.com/catppuccin/iterm/tree/main/colors) |
| `tokyonight-night` / `-storm` / `-moon` / `-day` | `tokyonight_<style>.itermcolors` | [tokyonight.nvim extras](https://github.com/folke/tokyonight.nvim/tree/main/extras/iterm) |
| `kanagawa-wave` / `-dragon` | `kanagawa.itermcolors`, `kanagawa_dragon.itermcolors` | [kanagawa.nvim extras](https://github.com/rebelot/kanagawa.nvim/tree/master/extras/iterm) |
| `rose-pine` / `-moon` / `-dawn` | `rose-pine[-moon\|-dawn].itermcolors` | [rose-pine/iterm](https://github.com/rose-pine/iterm) |
| `cyberdream` / `-muted` / `-light` | `cyberdream[-muted\|-light].itermcolors` | [cyberdream.nvim extras](https://github.com/scottmckendry/cyberdream.nvim/tree/main/extras/iterm2) |
| `nordic` | `nordic.itermcolors` | [nordic.nvim platforms](https://github.com/AlexvZyl/nordic.nvim/tree/main/platforms/iTerm2) |
| `everforest` | `Everforest Dark Med.itermcolors` | [iTerm2-Color-Schemes](https://github.com/mbadolato/iTerm2-Color-Schemes/tree/master/schemes) (community port) |

`kanagawa-lotus` has no iTerm preset.

To apply one:

1. Download your preferred flavour(s) from the link above (open the `.itermcolors` file, then **Download raw file**).
2. Launch iTerm and open settings (`⌘ ,`).
3. Select the **Profiles** tab and select your profile to edit.
4. Go to **Colors** → **Color Presets…** → **Import…**
5. Select the file(s) downloaded in step 1.
6. Click **Color Presets…** again and choose your flavour.
7. Enjoy! ✨

::: tip
Set **Minimum Contrast** (same Colors tab) to `0`. iTerm applies it to every app, so anything higher shifts the theme's dim colours: comments, indent guides and line numbers.
:::

## Dashboard

`nvim` with no file opens the snacks.nvim dashboard: pixel art, shortcuts (`f` find, `g` grep, `r` recent, `e` tree, `c` config, `L` Lazy, `q` quit) and your 5 most recent files (`1`–`5`).

### Changing the art

There are 12 pieces: `alien`, `bonsai`, `cactus`, `cat`, `coffee`, `fox`, `moon`, `mountains`, `mushroom`, `neovim`, `owl` (the default) and `rocket`.

- **Pick one:** `:DashboardArt` opens a picker, or `:DashboardArt <name>` (Tab completes the names). The dashboard redraws with the new art.
- **It is remembered:** like the theme, the choice is saved to `~/.local/share/nvim/dashboard_art` and shown on every launch. No config edit needed.
- **Change the default:** the art used before anything is picked is the `default` line at the top of `lua/plugins/dashboard.lua`. To go back to it, delete the saved file.

  An unknown saved name falls back to `moon`.

### Drawing your own

The templates are in `lua/insomnia/dashboard_art.lua`. Each character in `rows` is one pixel, coloured by its entry in `colors` (a space is empty); two pixel rows share a terminal line (`▀`), so pixels come out square. `accent` colours the title under the art. Add a new entry to `M.art` and it shows up in `:DashboardArt` straight away. The owl on this site is drawn from the same template.

## Statusline and file tree

The statusline (lualine) is one bar across all splits: mode, branch, diff counts, diagnostics, path, language servers, filetype and position. It follows the theme.

The file tree (`<leader>e`) colours names by git status and hides `.git`, `node_modules`, `__pycache__` and `.DS_Store`; press `U` in the tree to show them. `<leader>tt` switches focus between the tree and the editor.

## Completion

[blink.cmp](https://github.com/saghen/blink.cmp) shows a menu while you type and on the `:` line. Sources, in priority order: Neovim Lua API (in Lua files), language server, file paths, [friendly-snippets](https://github.com/rafamadriz/friendly-snippets), words from open buffers. Its keys are in the [keymaps reference](/reference/keymaps#completion-menu).
