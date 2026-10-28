#!/usr/bin/env bash
# Sync laravel/react-starter-kit into this JSX fork.
#
# Usage (from a clean `main`):
#   scripts/sync-upstream.sh              regular sync
#   scripts/sync-upstream.sh --baseline   one-time: build upstream-jsx from upstream-ts
#
# Branches:
#   upstream-ts  exact mirror of upstream/main (ff-only, never commit on it)
#   upstream-jsx upstream-ts + conversion (never hand-edit)
#   main         this kit; receives upstream-jsx via merge
#
# Files in scripts/jsx-overrides/ replace upstream's version after conversion
# (our JS-only eslint config and jsconfig.json). Update them on main when needed.
set -euo pipefail

# The script switches branches, so run from a copy to avoid bash reading a changing file.
if [ -z "${SYNC_REEXEC:-}" ]; then
  TMP="$(mktemp)"; cp "$0" "$TMP"; SYNC_REEXEC=1 exec bash "$TMP" "$@"
fi

CONVERTER="tsx-to-jsx-cli@0.0.3"
TODAY="$(date +%F)"
ROOT="$(git rev-parse --show-toplevel)"
cd "$ROOT"

[ -z "$(git status --porcelain)" ] || { echo "Working tree not clean."; exit 1; }
START_BRANCH="$(git branch --show-current)"

OVERRIDES="$(mktemp -d)"
cp -r scripts/jsx-overrides/. "$OVERRIDES"/

# Turns an upstream snapshot (current working tree) into its JSX version.
convert_snapshot() {
  npx --yes "$CONVERTER" -s ./resources/js -d ./resources/js

  # Remove TS sources (generated wayfinder dirs are gitignored).
  find resources/js -type f \( -name '*.ts' -o -name '*.tsx' \) \
    -not -path 'resources/js/actions/*' -not -path 'resources/js/routes/*' \
    -not -path 'resources/js/wayfinder/*' -delete

  # Deterministic text patches for files the converter doesn't touch.
  [ -f vite.config.ts ] && git mv vite.config.ts vite.config.js
  sed -i "s#resources/js/app\.tsx#resources/js/app.jsx#; s#resources/js/ssr\.tsx#resources/js/ssr.jsx#" vite.config.js
  sed -i "s#resources/js/app\.tsx#resources/js/app.jsx#; s#{\$page\['component'\]}\.tsx#{\$page['component']}.jsx#" resources/views/app.blade.php
  sed -i 's#"tsx": true#"tsx": false#' components.json
  sed -i 's#"name": "laravel/react-starter-kit"#"name": "yazidkhaldi/react-jsx-starter-kit"#' composer.json

  # Drop TypeScript packages by name (new upstream deps still flow through).
  node -e '
    const fs = require("fs");
    const p = JSON.parse(fs.readFileSync("package.json"));
    const rm = ["typescript","typescript-eslint","@types/react","@types/react-dom","@types/node","eslint-import-resolver-typescript"];
    for (const s of ["dependencies","devDependencies"]) for (const k of rm) delete (p[s] || {})[k];
    p.name = p.name || "react-jsx-starter-kit";
    fs.writeFileSync("package.json", JSON.stringify(p, null, 4) + "\n");
  '

  # JS-only tooling configs (ours replace upstream's).
  [ -f tsconfig.json ] && git rm -q tsconfig.json
  cp "$OVERRIDES"/* .

  if grep -rIn -E '\.tsx?\b' resources/views vite.config.js components.json eslint.config.js package.json; then
    echo "WARNING: leftover .ts/.tsx references above - add a patch in convert_snapshot."
  fi
}

# Replace the working tree with the tree of $1 (including deletions).
checkout_tree_of() {
  git rm -rfq . && git clean -fdq
  git checkout "$1" -- .
}

if [ "${1:-}" = "--baseline" ]; then
  git checkout -B upstream-jsx upstream-ts
  convert_snapshot
  git add -A
  git commit -m "Baseline: upstream $(git rev-parse --short upstream-ts) converted to JSX"
  git checkout "$START_BRANCH"
  git merge -s ours upstream-jsx -m "Record upstream-jsx baseline (no file changes)"
  echo "Baseline done. Push with: git push origin upstream-ts upstream-jsx"
  exit 0
fi

[ "$START_BRANCH" = "main" ] || { echo "Run from main."; exit 1; }

git fetch upstream
OLD="$(git rev-parse upstream-ts)"
NEW="$(git rev-list --count "$OLD"..upstream/main)"
[ "$NEW" -gt 0 ] || { echo "Already up to date with upstream."; exit 0; }
echo "Upstream has $NEW new commit(s)."

git checkout upstream-ts
git merge --ff-only upstream/main
SHA="$(git rev-parse --short HEAD)"

# Our overrides shadow these upstream files - flag if upstream changed them.
for f in eslint.config.js tsconfig.json; do
  git diff --quiet "$OLD" upstream-ts -- "$f" || \
    echo "NOTICE: upstream changed $f - review scripts/jsx-overrides/ for needed updates."
done

git checkout -B "sync/$TODAY" upstream-jsx
checkout_tree_of upstream-ts
convert_snapshot
git add -A
git commit -m "Sync upstream $SHA (auto-converted to JSX)"

git checkout upstream-jsx
git merge --ff-only "sync/$TODAY"
git branch -d "sync/$TODAY"

git checkout main
git merge upstream-jsx -m "Merge upstream $SHA (converted)" || {
  echo "Resolve conflicts, commit, then verify."
  exit 1
}
echo "Merged. Verify: npm install && npm run build && npm run lint && ./vendor/bin/phpunit"
echo "Then: git push origin main upstream-ts upstream-jsx"
