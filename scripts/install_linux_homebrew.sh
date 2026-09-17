#!/usr/bin/env bash
# Install Homebrew (Linuxbrew) if not already present, then apply the
# shared package baseline from Brewfile.linux.
#
# Deliberately a plain script, not Ansible: Homebrew refuses to run as
# root and its one-time setup wants an interactive sudo prompt, which is
# real friction to encode correctly with Ansible's become/become_user.
# It's also opt-in per host on purpose - not every sysprep'd host (e.g.
# servers) needs Linuxbrew, only the main interactive ones.
#
# Usage (from inside a cloned dotfiles repo):
#   ~/dotfiles/scripts/install_linux_homebrew.sh
#
# Safe to re-run: the Homebrew installer no-ops if already installed, and
# `brew bundle` only installs what's missing.

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "$script_dir/.." && pwd)"
brewfile="$repo_root/Brewfile.linux"
brew_bin="/home/linuxbrew/.linuxbrew/bin/brew"

if [ ! -x "$brew_bin" ]; then
  echo "Homebrew not found at $brew_bin - installing..."
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "Homebrew already installed at $brew_bin"
fi

eval "$("$brew_bin" shellenv)"

echo "Applying $brewfile"
brew bundle --file="$brewfile"
