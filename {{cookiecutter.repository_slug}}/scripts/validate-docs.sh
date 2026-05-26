#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd "$(dirname "$0")/.." && pwd)"
cd "$root_dir"

required_files=(
  "README.md"
  "AGENTS.md"
  "repository.yaml"
  "glossary.md"
  "overview.md"
  "docs/codex-workflow.md"
  "templates/feature.md"
  "templates/adr.md"
  "templates/test-case.md"
  "templates/release-notes.md"
  "templates/review-report.md"
)

for path in "${required_files[@]}"; do
  [[ -f "$path" ]] || {
    echo "Missing required file: $path" >&2
    exit 1
  }
done

invalid_feature_files="$(find features -maxdepth 1 -type f ! -name 'FEATURE-*.md' ! -name 'README.md' | wc -l | tr -d ' ')"
[[ "$invalid_feature_files" -eq 0 ]] || {
  echo "features/ contains files not matching FEATURE-*.md or README.md" >&2
  exit 1
}

echo "Documentation layout validation passed."
