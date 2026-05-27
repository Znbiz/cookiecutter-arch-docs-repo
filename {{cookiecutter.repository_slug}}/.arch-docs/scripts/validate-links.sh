#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$root_dir"

status=0

while IFS= read -r file; do
  while IFS= read -r link; do
    [[ "$link" =~ ^https?:// ]] && continue
    [[ "$link" =~ ^# ]] && continue
    link_path="${link%%#*}"
    [[ -z "$link_path" ]] && continue
    resolved="$(cd "$(dirname "$file")" && python3 -c 'import os,sys; print(os.path.normpath(sys.argv[1]))' "$link_path")"
    [[ -e "$(dirname "$file")/$resolved" ]] || {
      echo "Broken relative link in $file -> $link" >&2
      status=1
    }
  done < <(perl -nle 'while(/\[[^\]]+\]\(([^)]+)\)/g){print $1}' "$file")
done < <(find . -type f -name '*.md' ! -path './.git/*' | sort)

[[ "$status" -eq 0 ]] && echo "Relative link validation passed."
exit "$status"
