#!/usr/bin/env bash
# Install Homebrew if not already present, then apply the shared macOS
# package baseline from Brewfile.mac (and, on SDG work laptops, the
# work-only overlay in Brewfile.mac.work).
#
# Usage (from inside a cloned dotfiles repo):
#   ~/dotfiles/scripts/install_mac_homebrew.sh          # baseline only
#   ~/dotfiles/scripts/install_mac_homebrew.sh --work   # baseline + SDG overlay
#
# Safe to re-run: the Homebrew installer no-ops if already installed, and
# `brew bundle` only installs what's missing.

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "$script_dir/.." && pwd)"
brewfile="$repo_root/Brewfile.mac"
work_brewfile="$repo_root/Brewfile.mac.work"

if [ "$(uname -m)" = "arm64" ]; then
  brew_bin="/opt/homebrew/bin/brew"
else
  brew_bin="/usr/local/bin/brew"
fi

if [ ! -x "$brew_bin" ]; then
  echo "Homebrew not found at $brew_bin - installing..."
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "Homebrew already installed at $brew_bin"
fi

eval "$("$brew_bin" shellenv)"

echo "Applying $brewfile"
brew bundle --file="$brewfile"

if [ "${1:-}" = "--work" ]; then
  echo "Applying $work_brewfile"
  brew bundle --file="$work_brewfile"
fi
