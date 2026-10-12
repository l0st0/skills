#!/usr/bin/env bash
# Pin the change and list the repo's rule documents in one pass.
# Usage: scope.sh [fixed-point]   (run from inside the repo)
set -euo pipefail

fp="${1:-}"
if [ -z "$fp" ]; then
  fp=$(git symbolic-ref --quiet --short refs/remotes/origin/HEAD 2>/dev/null || true)
  if [ -z "$fp" ]; then
    for b in main master trunk develop; do
      git rev-parse --verify --quiet "$b" >/dev/null && { fp=$b; break; }
    done
  fi
fi
[ -n "$fp" ] || { echo "NO_FIXED_POINT: no default branch found; pass one"; exit 2; }
git rev-parse --verify --quiet "$fp^{commit}" >/dev/null || { echo "BAD_REF: $fp does not resolve"; exit 2; }

base=$(git merge-base "$fp" HEAD)
if [ "$base" = "$(git rev-parse HEAD)" ] && [ -z "${1:-}" ] && [ -z "$(git status --porcelain)" ]; then
  echo "ON_DEFAULT_BRANCH: HEAD is $fp with a clean tree; pass the commit before the work started"; exit 2
fi

echo "== fixed point: $fp"
echo "== merge-base: $base"
echo "== diff: git diff $base"
echo "== commits"
git log --oneline "$base..HEAD"
echo "== changed files (merge-base to working tree)"
git diff --stat=200 "$base"
echo "== untracked (lenses read these whole)"
git ls-files --others --exclude-standard
if [ -z "$(git diff --name-only "$base")$(git ls-files --others --exclude-standard)" ]; then
  echo "EMPTY_CHANGE"; exit 2
fi

echo "== rule documents"
git ls-files --cached --others --exclude-standard | grep -iE \
  '(^|/)(AGENTS|CLAUDE|CONTRIBUTING|GLOSSARY|CONTEXT)\.md$|(^|/)docs?/(adr|decisions)/|standard|convention|exception|suppression|(^|/)\.github/pull_request_template' \
  | grep -vE '(^|/)(node_modules|vendor|dist|build)/' | head -60 || true
echo "== gate"
for f in package.json Makefile justfile Taskfile.yml pyproject.toml Cargo.toml go.mod composer.json Gemfile; do
  [ -f "$f" ] && echo "$f"
done
if [ -f package.json ] && command -v node >/dev/null; then
  node -e 'const s=require("./package.json").scripts||{};for(const[k,v]of Object.entries(s))if(/lint|check|test|type|build|format|verify|ci/i.test(k))console.log(`  ${k}: ${v}`)'
fi
