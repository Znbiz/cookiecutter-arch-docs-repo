#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$root_dir"

required_files=(
  "README.md"
  "AGENTS.md"
  "arch-docs.yaml"
  "repository.yaml"
  "glossary.md"
  "overview.md"
  ".docs/codex-workflow.md"
  ".arch-docs/reports/README.md"
  ".arch-docs/standard/manifest.yaml"
  ".arch-docs/standard/migrations.yaml"
  ".arch-docs/templates/feature.md"
  ".arch-docs/templates/adr.md"
  ".arch-docs/templates/test-case.md"
  ".arch-docs/templates/release-notes.md"
  ".arch-docs/templates/review-report.md"
  ".arch-docs/wiki-llm/README.md"
  ".arch-docs/wiki-llm/indexing.yaml"
  ".arch-docs/wiki-llm/index-manifest.yaml"
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
