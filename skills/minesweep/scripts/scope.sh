#!/usr/bin/env bash
# Pin the change and list the repo's rule documents in one pass.
# Usage: scope.sh [fixed-point]   (run from anywhere inside the repo)
set -euo pipefail
top=$(git rev-parse --show-toplevel 2>/dev/null) || { echo "NOT_A_REPO: run inside a git repository"; exit 2; }
cd "$top"
git() { command git -c core.quotePath=false "$@"; }

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

base=$(git merge-base "$fp" HEAD) || { echo "NO_MERGE_BASE: HEAD shares no history with $fp here (a shallow clone?); fetch more history or pass a commit"; exit 2; }
if [ -z "${1:-}" ] && [ "$base" = "$(git rev-parse HEAD)" ]; then
  [ -n "$(git status --porcelain)" ] || { echo "ON_DEFAULT_BRANCH: HEAD has no commits beyond $fp and the tree is clean; pass the commit before the work started"; exit 2; }
  echo "== note: HEAD has no commits beyond $fp, so only uncommitted work is in scope; if the work began in earlier commits, rerun with the commit before it"
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
  '(^|/)(AGENTS|CLAUDE|GEMINI|CONTRIBUTING|GLOSSARY|CONTEXT)\.md$|(^|/)\.github/(copilot-instructions\.md$|instructions/|pull_request_template)|(^|/)\.cursor/rules/|((^|/)(adrs?|decisions)/|standard|convention|exception|suppression).*\.(md|mdx|rst|adoc|txt)$' \
  | grep -vE '(^|/)(node_modules|vendor|dist|build)/' || true
echo "== gate"
git ls-files | grep -E '^(\.github/workflows/[^/]+\.ya?ml|\.gitlab-ci\.yml|([^/]+/)?(package\.json|deno\.json|Makefile|justfile|Taskfile\.ya?ml|pyproject\.toml|tox\.ini|Cargo\.toml|go\.mod|composer\.json|Gemfile|pom\.xml|build\.gradle(\.kts)?|mix\.exs|pubspec\.yaml|Package\.swift))$' || true
if [ -f package.json ] && command -v node >/dev/null; then
  node -e 'const s=require("./package.json").scripts||{};for(const[k,v]of Object.entries(s))if(/lint|check|test|type|build|format|verify|ci/i.test(k))console.log(`  ${k}: ${v}`)' 2>/dev/null \
    || echo "  (package.json scripts unreadable)"
fi
