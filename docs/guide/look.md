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

## Fonts

The font belongs to your terminal, not to Neovim: set it in the terminal's settings (iTerm: Settings → Profiles → Text → Font), and over SSH set it on the computer you connect from. Any **Nerd Fonts v3** font gives you the icons. Each font comes in three variants, and the variant sets how big icons are:

- **Nerd Font** (for example `JetBrainsMono Nerd Font`): icons are full size and spill into the space after them. This config leaves that space everywhere, so this is the one to pick.
- **Nerd Font Mono**: every icon is squeezed into one cell, so icons look small next to the text.
- **Nerd Font Propo**: for apps with proportional text, not terminals.

| Font | Feel | Ligatures | Cursive italics | macOS (`brew install --cask …`) | Linux archive |
| --- | --- | --- | --- | --- | --- |
| Meslo (default) | Classic, Menlo-like | No | No | `font-meslo-lg-nerd-font` | `Meslo` |
| JetBrains Mono | Tall letters, very legible | Yes | No | `font-jetbrains-mono-nerd-font` | `JetBrainsMono` |
| Fira Code | Popular, friendly | Yes | No | `font-fira-code-nerd-font` | `FiraCode` |
| Hack | Plain and sturdy, good at small sizes | No | No | `font-hack-nerd-font` | `Hack` |
| Iosevka Term | Narrow: more columns fit side by side | Yes | No | `font-iosevka-term-nerd-font` | `IosevkaTerm` |
| Caskaydia Cove | Cascadia Code (Windows Terminal) | Yes | Yes | `font-caskaydia-cove-nerd-font` | `CascadiaCode` |
| Victor Mono | Slim, handwritten italics | Yes | Yes | `font-victor-mono-nerd-font` | `VictorMono` |
| Maple Mono | Rounded, handwritten italics | Yes | Yes | `font-maple-mono-nf` | [Maple releases](https://github.com/subframe7536/maple-font/releases) (`MapleMono-NF`) |

See them side by side at [programmingfonts.org](https://www.programmingfonts.org/) or the [Nerd Fonts downloads](https://www.nerdfonts.com/font-downloads) page.

On Linux (including a Pi with a desktop), put the archive in `~/.local/share/fonts`:

```shell
font=JetBrainsMono   # "Linux archive" column above
mkdir -p ~/.local/share/fonts/$font
curl -fsSL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/$font.tar.xz \
  | tar -xJ -C ~/.local/share/fonts/$font
fc-cache -f
```

::: tip
Ligatures (`->` drawn as an arrow, `!=` as `≠`) are off in iTerm by default: Settings → Profiles → Text → **Use ligatures**. It makes iTerm draw a little slower.
:::

### No Nerd Font

On a terminal without a Nerd Font (the Pi's own console, someone else's computer, an old patched font), icons show as blank boxes or `?`. Switch them to plain text:

- **`:Icons ascii`**, then restart Neovim. It's remembered in `~/.local/share/nvim/icons`, like the theme. `:Icons nerd` switches back, and `:Icons` with no name opens a picker.
- **For one session:** `NVIM_ICONS=ascii nvim`. It wins over the saved choice, so you can use it on a shared machine without changing anything.

In ascii mode, the file tree, statusline, tabs, dashboard, Telescope and completion menu show no file icons. Diagnostics in the sign column read `E`, `W`, `H`, `I`, and which-key labels keys as `C-`, `CR`, `Space`. Common symbols that every font has (`│`, `●`, `✓`) stay. The icon set is in `lua/insomnia/icons.lua`.

## Dashboard

`nvim` with no file opens the snacks.nvim dashboard: pixel art, shortcuts (`f` find, `g` grep, `r` recent, `e` tree, `c` config, `L` Lazy, `q` quit) and your 5 most recent files (`1`–`5`).

To get back to it mid-session, press `<leader>bD`. It closes every buffer, asking about unsaved changes first just as `<leader>bd` does, and closes any splits. Then it opens the dashboard with the file tree beside it. If you cancel a save prompt, nothing else changes.

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
