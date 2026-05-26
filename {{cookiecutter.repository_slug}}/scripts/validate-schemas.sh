#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd "$(dirname "$0")/.." && pwd)"
cd "$root_dir"

ruby <<'RUBY'
require "yaml"

def assert(condition, message)
  raise message unless condition
end

repo = YAML.load_file("repository.yaml")

assert(repo.is_a?(Hash), "repository.yaml must contain a mapping")
%w[project repositories services datastores queues external_services relationships].each do |key|
  assert(repo.key?(key), "repository.yaml missing key: #{key}")
end

project = repo["project"]
%w[id name description owner_team documentation_language].each do |key|
  assert(project[key].is_a?(String) && !project[key].empty?, "project.#{key} must be a non-empty string")
end

assert(repo["repositories"].is_a?(Array) && !repo["repositories"].empty?, "repositories must be a non-empty array")
assert(repo["services"].is_a?(Array) && !repo["services"].empty?, "services must be a non-empty array")
assert(repo["relationships"].is_a?(Array) && !repo["relationships"].empty?, "relationships must be a non-empty array")

repo_ids = repo["repositories"].map { |item| item["id"] }
service_ids = repo["services"].map { |item| item["id"] }
datastore_ids = repo["datastores"].map { |item| item["id"] }
queue_ids = repo["queues"].map { |item| item["id"] }

repo["services"].each do |service|
  assert(repo_ids.include?(service["repository_id"]), "service #{service['id']} references unknown repository_id")
  assert(service["exposed_ports"].is_a?(Array), "service #{service['id']} must define exposed_ports")
end

repo["datastores"].each do |datastore|
  owner = datastore["owner_service"]
  assert(owner.nil? || owner.empty? || service_ids.include?(owner), "datastore #{datastore['id']} references unknown owner_service")
end

repo["relationships"].each do |rel|
  assert(rel["from"].is_a?(String) && !rel["from"].empty?, "relationship.from must be set")
  assert(rel["to"].is_a?(String) && !rel["to"].empty?, "relationship.to must be set")
  known_targets = service_ids + datastore_ids + queue_ids
  assert(service_ids.include?(rel["from"]), "relationship.from references unknown service #{rel['from']}")
  assert(known_targets.include?(rel["to"]), "relationship.to references unknown target #{rel['to']}")
end

puts "Schema validation passed."
RUBY
