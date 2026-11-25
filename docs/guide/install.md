# Install

## Requirements

- Neovim **0.12+**, `git` and a C compiler
- `tree-sitter-cli`, to build parsers
- `ripgrep`, for grep in Telescope
- **Node.js 22+** with `npm`. Mason uses it for `jsonls`, `prettier` and `markdownlint`; without it they're skipped with one warning.
- A [Nerd Font](#fonts) in your terminal

## macOS

```shell
brew install neovim tree-sitter-cli ripgrep node
xcode-select --install   # C compiler, if you don't have one yet
git clone https://github.com/Venkat-Rajgopal/nvim.init.git ~/.config/nvim
nvim
```

## Linux (Debian, Ubuntu)

On `apt` systems (`x86_64` or `arm64`), `install.sh` installs whatever is missing, clones the config to `~/.config/nvim`, installs the plugins and builds the parsers:

```shell
sudo apt update && sudo apt install -y curl
curl -fsSL https://raw.githubusercontent.com/Venkat-Rajgopal/nvim.init/main/install.sh | bash
```

Run the same command again to update. If `~/.config/nvim` is already a clone of this repo, it's pulled; anything else there is moved to `nvim.bak.<date>`. Run from a clone somewhere else, `install.sh` links that clone instead.

`install.sh --check` only reports what's missing. The script leaves a recent enough Neovim alone; to upgrade to the latest release, run `sudo rm /usr/local/bin/nvim && ~/.config/nvim/install.sh`.

On a Raspberry Pi, see [Raspberry Pi](./raspberry-pi).

## First start

lazy.nvim installs itself and every plugin, the parsers are built, and Mason installs the language servers (watch with `:Mason`). If a server wasn't ready when you opened a file, restart `nvim`.

To install the plugins without opening the UI:

```shell
nvim --headless "+Lazy! sync" +qa
```

## Fonts

Icons in the file tree, statusline and dashboard need a **Nerd Fonts v3** font as your terminal font. Over SSH, that's the font of the terminal you connect from.

Older patched fonts, such as the `MesloLGS NF` that powerlevel10k installs, show blanks for some files (`.toml`, `.yaml`, `.css`). Replace it with the current build:

```shell
brew install --cask font-meslo-lg-nerd-font
```

Then pick **MesloLGS Nerd Font** in your terminal (iTerm: Settings → Profiles → Text → Font). Not the `Mono` variant: it shrinks icons to one cell. See [Fonts](/guide/look#fonts).

Meslo is only the default: any Nerd Font works. [Fonts](/guide/look#fonts) in the look guide compares a few. No Nerd Font at all? Run `:Icons ascii` and restart; see [No Nerd Font](/guide/look#no-nerd-font).
