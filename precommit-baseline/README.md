# precommit-baseline

Master copy of the pre-commit hooks shared by every repo under `~/.repos/mygit`.

- `.pre-commit-config.yaml` is the master. Edit it (or let Renovate bump its pins), never a repo's managed block.
- `skip.txt` lists repos (path relative to `~/.repos/mygit`, or bare name) that the sync ignores.
- `scripts/precommit-baseline` copies the master into each repo's own config between `# >>> BEGIN managed baseline` and `# <<< END managed baseline`. Everything outside the markers is the repo's own.

```
precommit-baseline                  # dry run: status table plus diffs for every repo
precommit-baseline --check          # quiet, exit 1 if any repo needs attention
precommit-baseline --apply          # write changes, no git
precommit-baseline --commit         # --apply, then one commit per repo; never pushes
precommit-baseline --repo PATH      # one repo only
```

Statuses: `ok`, `drift` (markers present, content differs), `adopt` (first sync), `custom` (the repo has settings the baseline would drop; not touched unless `--force`), `dirty` (the config has uncommitted changes), `no-config`, `skipped`.

On first sync, extra hooks a repo already had from a baseline repo (for example `detect-private-key` from pre-commit-hooks) are kept in a separate entry after the block, and the script keeps that entry's `rev` equal to the master's.
