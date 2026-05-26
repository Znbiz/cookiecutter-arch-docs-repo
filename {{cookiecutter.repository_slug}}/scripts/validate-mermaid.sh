#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd "$(dirname "$0")/.." && pwd)"
cd "$root_dir"

status=0

while IFS= read -r file; do
  ruby - "$file" <<'RUBY' || status=1
content = File.read(ARGV[0])
open_blocks = content.scan(/^```mermaid\s*$/).size
close_blocks = content.scan(/^```\s*$/).size
raise "Unclosed mermaid fences in #{ARGV[0]}" if open_blocks.zero?
raise "Too few closing fences in #{ARGV[0]}" if close_blocks < open_blocks
RUBY
done < <(grep -R -l '^```mermaid' context processes architecture deployment .)

echo "Mermaid validation passed."
exit "$status"
