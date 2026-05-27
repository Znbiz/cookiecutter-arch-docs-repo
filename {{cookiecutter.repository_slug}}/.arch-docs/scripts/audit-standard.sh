#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$root_dir"

ruby .arch-docs/scripts/arch-docs-tool.rb audit "$@"
