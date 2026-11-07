# Raspberry Pi setup

This config on a Raspberry Pi (tested for a Pi 3B with 1 GB of RAM). Everything else, such as shortcuts and commands, is in the main [README](README.md).

## Requirements

**64-bit** Raspberry Pi OS: Neovim has no 32-bit build. Check with `dpkg --print-architecture`, which should print `arm64`. On a 3B the 64-bit OS is an option in Raspberry Pi Imager.

## Install

```shell
sudo apt update && sudo apt install -y git
git clone https://github.com/Venkat-Rajgopal/nvim.init.git ~/.config/nvim
~/.config/nvim/install.sh
```

To only see what's missing, without changing anything:

```shell
~/.config/nvim/install.sh --check
```

The script installs only what's missing, so it's safe to run again:

| Step         | What it does                                                                                                          |
| ------------ | --------------------------------------------------------------------------------------------------------------------- |
| Check        | Stops on anything but a 64-bit apt system                                                                             |
| apt packages | `git`, `build-essential`, `curl`, `unzip`, `ripgrep`, `jq`, `python3`, `python3-venv`                                 |
| Neovim       | Official release in `/opt`, linked to `/usr/local/bin/nvim` (apt's version is too old)                                |
| Node.js      | Node 24 from NodeSource, if you don't have 22+ (apt's version is too old for `markdownlint`)                          |
| tree-sitter  | `tree-sitter-cli` from npm, or 0.25.10 on Bookworm (see [Troubleshooting](#troubleshooting))                          |
| Config       | If you cloned somewhere else, links that folder to `~/.config/nvim`. An existing config is moved to `nvim.bak.<date>` |
| Plugins      | Installs the versions in `lazy-lock.json` and builds the parsers                                                      |

Then start `nvim`. Mason installs the language servers and tools on the first start, which you can watch with `:Mason`. If a server wasn't ready when you opened a file, restart `nvim`.

## What's different on a Pi

`lua/insomnia/platform.lua` detects the Pi from `/proc/device-tree/model`, and two things change:

| Setting      | Pi                          | Other machines |
| ------------ | --------------------------- | -------------- |
| Python types | `ty`                        | `pyright`      |
| Parser build | 2 at a time, to save memory | All at once    |

`ty` needs no setup. It picks the interpreter the same way `pyright` does here: `$VIRTUAL_ENV`, then `.venv` in the project root, then `python3`. It only checks open files, and it's still in beta, so its warnings can change between versions.

`ruff` works as usual, and `prettier`, `markdownlint` and `jsonls` still use Node. They only run when needed, so Node takes no memory the rest of the time.

Rust isn't set up by the script, as `rust-analyzer` is heavy for 1 GB. Until you add it with `rustup component add rust-analyzer`, `.rs` files have no language server.

## Check it works

```vim
:Mason                     " everything shows as installed
:LspInfo                   " in a .py file: ty and ruff
:checkhealth mason
```

To see memory use while you work:

```shell
free -h
ps -eo rss,cmd --sort=-rss | head -5   # rss is in KB
```

## Update

```shell
git -C ~/.config/nvim pull
~/.config/nvim/install.sh
```

Inside Neovim, `:Mason` then `U` updates the servers and tools.

The script leaves a recent enough Neovim alone. To upgrade to the latest release:

```shell
sudo rm /usr/local/bin/nvim && ~/.config/nvim/install.sh
```

## Troubleshooting

| Problem                                                                   | Fix                                                                                                                                        |
| ------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------ |
| `npm not found; Mason can't install: ...`                                 | Run `./install.sh`, then restart `nvim`                                                                                                    |
| `failed to install ...`                                                   | `:MasonLog` has the reason. `ty` needs `python3-venv`, which the script installs                                                           |
| `:checkhealth nvim-treesitter` says `tree-sitter-cli v0.26.1 is required` | Expected on Bookworm: newer builds need glibc 2.39, so the script uses 0.25.10. All the parsers here build with it. Trixie gets the latest |
| Everything is slow or swapping                                            | Close other files, or check memory as shown above                                                                                          |
