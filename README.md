# dotfiles

Shell config, Brewfiles, ssh config and helper scripts.

## Helper scripts

`scripts/` holds small tools (`sync-repos`, `mirror-main`, `mirror-prune-branches`, `setup-remotes.sh`). After cloning, or after adding a script, run:

```
scripts/link-scripts       # symlinks the executables into ~/.local/bin
scripts/link-scripts -n    # dry run
```

`~/.local/bin` must be on `PATH` (the zshrc files already do this). `install_*` scripts are one-off machine setup and are not linked.
