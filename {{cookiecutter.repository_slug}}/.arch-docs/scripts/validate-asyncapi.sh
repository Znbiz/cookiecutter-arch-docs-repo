#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$root_dir"

ruby <<'RUBY'
require "yaml"
doc = YAML.load_file("architecture/api/events/asyncapi.yaml")
raise "architecture/api/events/asyncapi.yaml: missing asyncapi version" unless doc["asyncapi"].is_a?(String)
raise "architecture/api/events/asyncapi.yaml: missing info.title" unless doc.dig("info", "title").is_a?(String)
raise "architecture/api/events/asyncapi.yaml: missing info.version" unless doc.dig("info", "version").is_a?(String)
raise "architecture/api/events/asyncapi.yaml: missing channels" unless doc["channels"].is_a?(Hash) && !doc["channels"].empty?
puts "AsyncAPI validation passed."
RUBY
