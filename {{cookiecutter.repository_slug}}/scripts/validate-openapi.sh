#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd "$(dirname "$0")/.." && pwd)"
cd "$root_dir"

status=0

for file in api/openapi/*.yaml; do
  [[ -f "$file" ]] || continue
  ruby - "$file" <<'RUBY' || status=1
require "yaml"
doc = YAML.load_file(ARGV[0])
raise "#{ARGV[0]}: missing openapi" unless doc["openapi"].is_a?(String)
raise "#{ARGV[0]}: missing info.title" unless doc.dig("info", "title").is_a?(String)
raise "#{ARGV[0]}: missing info.version" unless doc.dig("info", "version").is_a?(String)
raise "#{ARGV[0]}: missing paths" unless doc["paths"].is_a?(Hash) && !doc["paths"].empty?
RUBY
done

echo "OpenAPI validation passed."
exit "$status"
