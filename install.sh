#!/usr/bin/env bash
# Set up this Neovim config on apt-based Linux: Debian, Ubuntu, 64-bit Raspberry Pi OS.
# Installs what's missing, puts the config in ~/.config/nvim and installs the plugins.
# Safe to run again: it also updates an existing checkout.
# Docs: https://venkat-rajgopal.github.io/nvim.init/guide/install
#
#   curl -fsSL https://raw.githubusercontent.com/Venkat-Rajgopal/nvim.init/main/install.sh | bash
#   ./install.sh           check, install, set up
#   ./install.sh --check   only report what's missing
set -euo pipefail

REPO_URL="https://github.com/Venkat-Rajgopal/nvim.init.git"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
# Empty when piped into bash: then there's no checkout to link, so clone one
SOURCE_DIR=""
if [ -f "${BASH_SOURCE[0]:-}" ]; then
  SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
fi

NVIM_MIN=0.12
NODE_MIN=22     # markdownlint needs 22; apt ships older
NODE_SETUP=24   # NodeSource release line to install
TREE_SITTER_MIN=0.25.10 # the newest that runs on Bookworm, see install_tree_sitter
APT_PACKAGES=(git build-essential curl unzip ripgrep jq python3 python3-venv)

SUDO=""
[ "$(id -u)" -eq 0 ] || SUDO="sudo"

log() { printf '\n==> %s\n' "$*"; }
die() { printf 'error: %s\n' "$*" >&2; exit 1; }
have() { command -v "$1" >/dev/null 2>&1; }
version_ge() { [ "$(printf '%s\n%s\n' "$2" "$1" | sort -V | head -n 1)" = "$2" ]; }

case "${1:-}" in
  "" | --check) ;;
  *) die "usage: $0 [--check]" ;;
esac

# Checks. Each one is true when the dependency is good enough.
nvim_version() { nvim --version | sed -n '1s/^NVIM v\([0-9.]*\).*/\1/p'; }
nvim_ok() { have nvim && version_ge "$(nvim_version)" "$NVIM_MIN"; }
node_ok() { have node && have npm && [ "$(node -p 'process.versions.node.split(".")[0]')" -ge "$NODE_MIN" ]; }
tree_sitter_version() { tree-sitter --version | sed -n 's/^tree-sitter \([0-9.]*\).*/\1/p'; }
tree_sitter_ok() { have tree-sitter && version_ge "$(tree_sitter_version 2>/dev/null)" "$TREE_SITTER_MIN"; }
apt_missing() {
  local pkg
  for pkg in "${APT_PACKAGES[@]}"; do
    dpkg-query -W -f='${Status}' "$pkg" 2>/dev/null | grep -q "ok installed" || printf '%s ' "$pkg"
  done
}

check_platform() {
  have apt-get || die "this script needs apt (Raspberry Pi OS, Debian, Ubuntu)"
  # dpkg, not uname: a 32-bit Raspberry Pi OS can run a 64-bit kernel
  case "$(dpkg --print-architecture)" in
    arm64) ARCH=arm64 ;;
    amd64) ARCH=x86_64 ;;
    *) die "$(dpkg --print-architecture) isn't supported: Neovim has no build for it, use the 64-bit OS" ;;
  esac
}

report() {
  local missing=0 pkgs
  pkgs="$(apt_missing)"

  log "Dependencies"
  if [ -z "$pkgs" ]; then printf '  ok       apt packages\n'; else printf '  missing  apt packages: %s\n' "$pkgs"; missing=1; fi
  if nvim_ok; then printf '  ok       neovim %s\n' "$(nvim_version)"; else printf '  missing  neovim %s+\n' "$NVIM_MIN"; missing=1; fi
  if node_ok; then printf '  ok       node %s, npm %s\n' "$(node --version)" "$(npm --version)"; else printf '  missing  node %s+ with npm\n' "$NODE_MIN"; missing=1; fi
  if tree_sitter_ok; then printf '  ok       tree-sitter %s\n' "$(tree_sitter_version)"; else printf '  missing  tree-sitter %s+\n' "$TREE_SITTER_MIN"; missing=1; fi
  return "$missing"
}

install_apt_packages() {
  local pkgs
  pkgs="$(apt_missing)"
  [ -n "$pkgs" ] || return 0
  log "Installing apt packages: $pkgs"
  $SUDO apt-get update
  # shellcheck disable=SC2086 # one word per package
  $SUDO apt-get install -y $pkgs
}

# The apt Neovim is too old, so use the official release build
install_neovim() {
  nvim_ok && return 0
  log "Installing Neovim"
  local name="nvim-linux-$ARCH" tmp
  tmp="$(mktemp -d)"
  curl -fL --progress-bar "https://github.com/neovim/neovim/releases/latest/download/$name.tar.gz" -o "$tmp/nvim.tar.gz"
  $SUDO rm -rf "/opt/$name"
  $SUDO tar -C /opt -xzf "$tmp/nvim.tar.gz"
  $SUDO ln -sf "/opt/$name/bin/nvim" /usr/local/bin/nvim
  rm -rf "$tmp"
}

install_node() {
  node_ok && return 0
  log "Installing Node.js $NODE_SETUP"
  curl -fsSL "https://deb.nodesource.com/setup_$NODE_SETUP.x" | $SUDO -E bash -
  $SUDO apt-get install -y nodejs
}

install_tree_sitter() {
  tree_sitter_ok && return 0
  log "Installing tree-sitter CLI"
  $SUDO npm install -g tree-sitter-cli
  # From 0.26 on it needs glibc 2.39, and Bookworm has 2.36
  tree-sitter --version >/dev/null 2>&1 || $SUDO npm install -g "tree-sitter-cli@$TREE_SITTER_MIN"
}

# A clone of this repo, whatever the remote's spelling (https or ssh, with or without .git)
is_this_repo() {
  local url
  url="$(git -C "$1" remote get-url origin 2>/dev/null)" || return 1
  url="$(printf '%s' "$url" | tr '[:upper:]' '[:lower:]' | sed 's#^.*github\.com[:/]##; s#/*$##; s#\.git$##')"
  [ "$url" = "venkat-rajgopal/nvim.init" ]
}

move_aside() {
  [ -e "$CONFIG_DIR" ] || [ -L "$CONFIG_DIR" ] || return 0
  local backup
  backup="$CONFIG_DIR.bak.$(date +%Y%m%d-%H%M%S)"
  mv "$CONFIG_DIR" "$backup"
  printf 'Moved the existing config to %s\n' "$backup"
}

# Run from a checkout elsewhere: link it. Already a clone: update it. Otherwise: clone.
# Anything else that's already at ~/.config/nvim is moved aside, never deleted.
install_config() {
  local target
  target="$(cd "$CONFIG_DIR" 2>/dev/null && pwd -P || true)"
  mkdir -p "$(dirname "$CONFIG_DIR")"

  if [ -n "$SOURCE_DIR" ] && [ "$target" != "$SOURCE_DIR" ] \
    && [ -f "$SOURCE_DIR/init.lua" ] && [ -f "$SOURCE_DIR/install.sh" ]; then
    log "Linking $SOURCE_DIR to $CONFIG_DIR"
    move_aside
    ln -s "$SOURCE_DIR" "$CONFIG_DIR"
  elif is_this_repo "$CONFIG_DIR"; then
    log "Updating the config in $CONFIG_DIR"
    git -C "$CONFIG_DIR" pull --ff-only \
      || printf 'warning: could not update %s (local changes?), keeping it as it is\n' "$CONFIG_DIR"
  else
    log "Putting the config in $CONFIG_DIR"
    move_aside
    git clone "$REPO_URL" "$CONFIG_DIR"
  fi
}

install_plugins() {
  log "Installing plugins and building parsers (this takes a while the first time)"
  local lock_clean=0
  git -C "$CONFIG_DIR" diff --quiet -- lazy-lock.json 2>/dev/null && lock_clean=1
  nvim --headless "+Lazy! restore" +qa
  printf '\n'
  # lazy.nvim's bootstrap rewrites its own line, which would block a later git pull
  [ "$lock_clean" -eq 0 ] || git -C "$CONFIG_DIR" checkout -- lazy-lock.json
}

# All in one function, so bash has read the whole script before anything runs:
# that keeps curl | bash from feeding the rest of the script to apt or nvim, and
# lets git pull replace this file while it runs.
main() {
  check_platform
  if [ "${1:-}" = "--check" ]; then
    report
    exit
  fi

  report || true
  install_apt_packages
  install_neovim
  install_node
  install_tree_sitter
  report || die "something is still missing, see above"
  install_config
  install_plugins

  log "Done"
  printf 'Start nvim: the language servers install on the first start, watch them with :Mason.\n'
  printf 'Next steps: https://venkat-rajgopal.github.io/nvim.init/guide/install#first-start\n'
}

main "$@"
