#!/usr/bin/env bash
# Add the standard push-mirror fan-out to a freshly cloned repo's origin.
#
# Convention: origin's existing fetch URL (GitLab, usually) stays the sole
# fetch source. This adds push URLs for that same host plus GitHub and
# Bitbucket, so `git push` fans out to all three. GitHub/Bitbucket paths are
# assumed to be allmightyroot/<repo-name> (matches this account's existing
# repos) - override with GITHUB_ORG / BITBUCKET_ORG if a given repo differs.
#
# Optional 4th mirror (e.g. Forgejo) via FORGEJO_URL, for repos that have one.
#
# Usage (from inside the freshly cloned repo):
#   ~/dotfiles/scripts/setup-remotes.sh
#   FORGEJO_URL=ssh://git@forgejo-ssh.example.ts.net/ORG/repo.git ./setup-remotes.sh

set -euo pipefail

remote="${1:-origin}"
github_org="${GITHUB_ORG:-allmightyroot}"
bitbucket_org="${BITBUCKET_ORG:-allmightyroot}"

fetch_url=$(git remote get-url "$remote")
repo_name=$(basename -s .git "$fetch_url")

echo "Repo:            $repo_name"
echo "Primary (fetch): $fetch_url"

# The first --add also re-adds the fetch URL as a push URL, since setting
# any pushurl overrides git's default push-to-fetch-url behavior.
git remote set-url --add --push "$remote" "$fetch_url"
git remote set-url --add --push "$remote" "git@github.com:${github_org}/${repo_name}.git"
git remote set-url --add --push "$remote" "git@bitbucket.org:${bitbucket_org}/${repo_name}.git"

if [ -n "${FORGEJO_URL:-}" ]; then
  git remote set-url --add --push "$remote" "$FORGEJO_URL"
fi

echo
git remote -v
