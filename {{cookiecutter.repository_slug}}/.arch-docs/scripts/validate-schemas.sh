#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$root_dir"

ruby <<'RUBY'
require "yaml"

def assert(condition, message)
  raise message unless condition
end

repo = YAML.load_file("repository.yaml")
arch = YAML.load_file("arch-docs.yaml")

assert(repo.is_a?(Hash), "repository.yaml must contain a mapping")
%w[project repositories services datastores queues external_services relationships].each do |key|
  assert(repo.key?(key), "repository.yaml missing key: #{key}")
end

assert(arch.is_a?(Hash), "arch-docs.yaml must contain a mapping")
%w[standard repository_modes wiki_llm local_roles].each do |key|
  assert(arch.key?(key), "arch-docs.yaml missing key: #{key}")
end

standard = arch["standard"]
%w[template_name template_repository applied_version target_version migration_index].each do |key|
  assert(standard[key].is_a?(String) && !standard[key].empty?, "standard.#{key} must be a non-empty string")
end

assert(arch["repository_modes"].is_a?(Hash), "repository_modes must be a mapping")
assert(arch["wiki_llm"].is_a?(Hash), "wiki_llm must be a mapping")
assert(arch["local_roles"].is_a?(Array) && !arch["local_roles"].empty?, "local_roles must be a non-empty array")
bootstrap_mode = arch["repository_modes"]["bootstrap"]
assert(bootstrap_mode.is_a?(Hash), "repository_modes.bootstrap must be a mapping")
assert(%w[scaffold in_progress established].include?(bootstrap_mode["status"]), "repository_modes.bootstrap.status must be scaffold, in_progress or established")

arch["local_roles"].each do |role|
  assert(role["id"].is_a?(String) && !role["id"].empty?, "local_roles.id must be a non-empty string")
  assert(role["path"].is_a?(String) && !role["path"].empty?, "local_roles.path must be a non-empty string")
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

if repo.key?("role_policy")
  assert(repo["role_policy"].is_a?(Array), "role_policy must be an array")
end

if repo.key?("integration_catalog")
  assert(repo["integration_catalog"].is_a?(Array), "integration_catalog must be an array")
end

if repo.key?("environments")
  assert(repo["environments"].is_a?(Array), "environments must be an array")
  repo["environments"].each do |env|
    assert(env["name"].is_a?(String) && !env["name"].empty?, "environment.name must be a non-empty string")
    assert(env["purpose"].is_a?(String) && !env["purpose"].empty?, "environment.purpose must be a non-empty string")
    assert(env["addresses"].is_a?(Hash), "environment.addresses must be a mapping")
    assert(env["resources"].is_a?(Hash), "environment.resources must be a mapping")
  end
end

puts "Schema validation passed."
RUBY
