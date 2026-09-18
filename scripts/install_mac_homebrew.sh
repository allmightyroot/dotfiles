#!/usr/bin/env bash
# Install Homebrew if not already present, then apply the shared macOS
# package baseline from Brewfile.mac (and, on SDG work laptops, the
# work-only overlay in Brewfile.mac.work).
#
# Usage (from inside a cloned dotfiles repo):
#   ~/dotfiles/scripts/install_mac_homebrew.sh                    # baseline only
#   ~/dotfiles/scripts/install_mac_homebrew.sh --work              # baseline + SDG overlay
#   ~/dotfiles/scripts/install_mac_homebrew.sh --cleanup            # preview drift (dry run)
#   ~/dotfiles/scripts/install_mac_homebrew.sh --cleanup --force    # remove drift for real
#   ~/dotfiles/scripts/install_mac_homebrew.sh --work --cleanup --force
#
# Safe to re-run: the Homebrew installer no-ops if already installed, and
# `brew bundle` only installs what's missing. `--cleanup` without --force
# only lists what's not declared in the Brewfile(s) - it never removes
# anything unless --force is also given.

set -euo pipefail

work=false
cleanup=false
force=false

for arg in "$@"; do
  case "$arg" in
    --work) work=true ;;
    --cleanup) cleanup=true ;;
    --force) force=true ;;
    *)
      echo "Unknown argument: $arg" >&2
      exit 1
      ;;
  esac
done

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

if [ "$work" = true ]; then
  echo "Applying $work_brewfile"
  brew bundle --file="$work_brewfile"
fi

if [ "$cleanup" = true ]; then
  # brew bundle cleanup only takes one --file, so when --work is active,
  # the drift check must run against the union of both Brewfiles - a
  # cleanup scoped to just Brewfile.mac would wrongly flag every
  # work-overlay package as unwanted.
  cleanup_target="$brewfile"
  if [ "$work" = true ]; then
    cleanup_target="$(mktemp)"
    trap 'rm -f "$cleanup_target"' EXIT
    cat "$brewfile" "$work_brewfile" > "$cleanup_target"
  fi

  if [ "$force" = true ]; then
    echo "Removing drift not declared in the Brewfile(s)..."
    brew bundle cleanup --file="$cleanup_target" --force
  else
    echo "Previewing drift not declared in the Brewfile(s) (re-run with --force to remove):"
    brew bundle cleanup --file="$cleanup_target"
  fi
fi
