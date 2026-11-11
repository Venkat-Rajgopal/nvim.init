# Raspberry Pi

Tested on a Pi 3B with 1 GB of RAM. It needs the **64-bit** Raspberry Pi OS (Neovim has no 32-bit build): `dpkg --print-architecture` should print `arm64`.

## Install

```shell
sudo apt update && sudo apt install -y git
git clone https://github.com/Venkat-Rajgopal/nvim.init.git ~/.config/nvim
~/.config/nvim/install.sh
```

The script installs only what's missing, so it's safe to run again:

| Step         | What it does                                                                                 |
| ------------ | -------------------------------------------------------------------------------------------- |
| Check        | Stops on anything but a 64-bit apt system                                                    |
| apt packages | `git`, `build-essential`, `curl`, `unzip`, `ripgrep`, `jq`, `python3`, `python3-venv`        |
| Neovim       | Official release in `/opt`, linked to `/usr/local/bin/nvim` (apt's is too old)               |
| Node.js      | Node 24 from NodeSource, if you don't have 22+                                               |
| tree-sitter  | `tree-sitter-cli` from npm, or 0.25.10 on Bookworm (see [Troubleshooting](#troubleshooting)) |
| Config       | Links the clone to `~/.config/nvim`. An existing config is moved to `nvim.bak.<date>`        |
| Plugins      | Installs the versions in `lazy-lock.json` and builds the parsers                             |

Then start `nvim`; Mason installs the servers on the first start.

## What's different on a Pi

`lua/insomnia/platform.lua` detects the Pi from `/proc/device-tree/model`:

| Setting      | Pi                          | Other machines |
| ------------ | --------------------------- | -------------- |
| Python types | `ty`                        | `basedpyright` |
| Parser build | 2 at a time, to save memory | All at once    |

`ty` finds the interpreter the same way (`$VIRTUAL_ENV`, then `.venv`, then `python3`) and only checks open files. Rust isn't set up, as `rust-analyzer` is heavy for 1 GB; add it with `rustup component add rust-analyzer`.

## Check and update

```vim
:Mason                     " everything installed
:LspInfo                   " in a .py file: ty and ruff
```

```shell
free -h                                  # memory while you work
git -C ~/.config/nvim pull && ~/.config/nvim/install.sh
```

## Troubleshooting

| Problem                                                        | Fix                                                                                     |
| -------------------------------------------------------------- | --------------------------------------------------------------------------------------- |
| `npm not found; Mason can't install: ...`                      | Run `./install.sh`, then restart `nvim`                                                 |
| `failed to install ...`                                        | `:MasonLog` has the reason. `ty` needs `python3-venv`                                   |
| `:checkhealth nvim-treesitter` wants `tree-sitter-cli v0.26.1` | Expected on Bookworm: newer builds need glibc 2.39. All parsers here build with 0.25.10 |
| Everything is slow or swapping                                 | Close other files, or check memory with `free -h`                                       |
