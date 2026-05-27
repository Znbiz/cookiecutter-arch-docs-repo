#!/usr/bin/env ruby
# frozen_string_literal: true

require "digest"
require "fileutils"
require "pathname"
require "yaml"

ROOT = Pathname.new(__dir__).join("../..").realpath

def load_yaml(path)
  YAML.load_file(ROOT.join(path))
end

def write_yaml(path, data)
  target = ROOT.join(path)
  FileUtils.mkdir_p(target.dirname)
  File.write(target, YAML.dump(data))
end

def ensure_hash(value, path)
  raise "#{path} must contain a mapping" unless value.is_a?(Hash)
end

def ensure_array(value, path)
  raise "#{path} must contain an array" unless value.is_a?(Array)
end

def stringify(value)
  value.nil? ? "" : value.to_s
end

def shell_escape(value)
  "'" + value.to_s.gsub("'", %q('"'"')) + "'"
end

def tracked_file?(path)
  File.file?(ROOT.join(path))
end

def load_configs
  arch = load_yaml("arch-docs.yaml")
  manifest = load_yaml(".arch-docs/standard/manifest.yaml")
  migrations = load_yaml(".arch-docs/standard/migrations.yaml")
  repository = load_yaml("repository.yaml")

  ensure_hash(arch, "arch-docs.yaml")
  ensure_hash(manifest, ".arch-docs/standard/manifest.yaml")
  ensure_hash(migrations, ".arch-docs/standard/migrations.yaml")
  ensure_hash(repository, "repository.yaml")

  [arch, manifest, migrations, repository]
end

def placeholder_markers(manifest)
  Array(manifest["placeholder_markers"]).map(&:to_s)
end

def placeholder_string?(value, markers)
  return false unless value.is_a?(String)

  markers.any? { |marker| value.include?(marker) }
end

def collect_placeholders(object, markers, path = [], results = [])
  case object
  when Hash
    object.each do |key, value|
      collect_placeholders(value, markers, path + [key], results)
    end
  when Array
    object.each_with_index do |value, index|
      collect_placeholders(value, markers, path + [index], results)
    end
  else
    results << [path.join("."), object] if placeholder_string?(object, markers)
  end

  results
end

def role_paths_from_config(arch)
  ensure_array(arch.fetch("local_roles"), "arch-docs.yaml.local_roles")
  arch.fetch("local_roles").map { |item| item.fetch("path") }
end

def build_wiki_manifest(arch, manifest)
  wiki = arch.fetch("wiki_llm")
  indexing = load_yaml(wiki.fetch("indexing_config"))
  ensure_hash(indexing, wiki.fetch("indexing_config"))

  includes = Array(indexing["include"])
  excludes = Array(indexing["exclude"])
  files = Dir.chdir(ROOT) do
    includes.flat_map { |pattern| Dir.glob(pattern, File::FNM_EXTGLOB) }
  end
  files = files.uniq.sort
  files.reject! do |path|
    excludes.any? { |pattern| File.fnmatch?(pattern, path, File::FNM_PATHNAME | File::FNM_EXTGLOB) }
  end
  files.select! { |path| File.file?(ROOT.join(path)) }

  {
    "standard_version" => arch.dig("standard", "applied_version"),
    "document_count" => files.length,
    "documents" => files.map do |path|
      {
        "path" => path,
        "sha256" => Digest::SHA256.file(ROOT.join(path)).hexdigest,
        "kind" => File.extname(path).delete_prefix(".")
      }
    end,
    "expected_sections" => Array(manifest["expected_sections"])
  }
end

def wiki_manifest_current?(arch, manifest)
  path = arch.dig("wiki_llm", "manifest_path")
  return false unless File.file?(ROOT.join(path))

  current = load_yaml(path)
  current == build_wiki_manifest(arch, manifest)
end

def git_clean?
  system("git diff --quiet >/dev/null 2>&1") && system("git diff --cached --quiet >/dev/null 2>&1")
end

def write_report(path, content)
  target = ROOT.join(path)
  FileUtils.mkdir_p(target.dirname)
  File.write(target, content)
end

def render_audit_report(arch, manifest, repository)
  markers = placeholder_markers(manifest)
  missing_files = Array(manifest["required_files"]).reject { |path| tracked_file?(path) }
  missing_dirs = Array(manifest["required_directories"]).reject { |path| Dir.exist?(ROOT.join(path)) }
  missing_roles = Array(manifest["required_role_paths"]).reject { |path| tracked_file?(path) }
  missing_scripts = Array(manifest["required_scripts"]).reject { |path| tracked_file?(path) }
  repo_placeholders = collect_placeholders(repository, markers)
  config_placeholders = collect_placeholders(arch, markers)
  bootstrap_status = arch.dig("repository_modes", "bootstrap", "status")
  version_status = if arch.dig("standard", "applied_version") == arch.dig("standard", "target_version")
    "aligned"
  else
    "pending migration"
  end
  wiki_status = wiki_manifest_current?(arch, manifest) ? "current" : "stale"

  lines = []
  lines << "# Standard Audit"
  lines << ""
  lines << "- Template: `#{arch.dig("standard", "template_repository")}`"
  lines << "- Applied version: `#{arch.dig("standard", "applied_version")}`"
  lines << "- Target version: `#{arch.dig("standard", "target_version")}`"
  lines << "- Version status: `#{version_status}`"
  lines << "- Bootstrap status: `#{bootstrap_status}`"
  lines << "- wiki-llm manifest: `#{wiki_status}`"
  lines << ""
  lines << "## Gaps"
  lines << ""
  lines << "- Missing required files: #{missing_files.empty? ? 'none' : missing_files.map { |item| "`#{item}`" }.join(', ')}"
  lines << "- Missing required directories: #{missing_dirs.empty? ? 'none' : missing_dirs.map { |item| "`#{item}`" }.join(', ')}"
  lines << "- Missing required roles: #{missing_roles.empty? ? 'none' : missing_roles.map { |item| "`#{item}`" }.join(', ')}"
  lines << "- Missing required scripts: #{missing_scripts.empty? ? 'none' : missing_scripts.map { |item| "`#{item}`" }.join(', ')}"
  lines << ""
  lines << "## Placeholder Findings"
  lines << ""
  lines << "- `repository.yaml`: #{repo_placeholders.empty? ? 'none' : repo_placeholders.map { |path, value| "`#{path}=#{value}`" }.join(', ')}"
  lines << "- `arch-docs.yaml`: #{config_placeholders.empty? ? 'none' : config_placeholders.map { |path, value| "`#{path}=#{value}`" }.join(', ')}"

  effective_placeholder_gaps = if bootstrap_status == "established"
    repo_placeholders + config_placeholders
  else
    []
  end

  {
    report: lines.join("\n") + "\n",
    gaps: missing_files + missing_dirs + missing_roles + missing_scripts + effective_placeholder_gaps + (wiki_status == "current" ? [] : [["wiki_llm.manifest", "stale"]]) + (version_status == "aligned" ? [] : [["standard.version", "pending migration"]])
  }
end

def run_audit(args)
  fail_on_gap = args.include?("--fail-on-gap")
  write_output = args.include?("--write-report")
  arch, manifest, = load_configs
  repository = load_yaml("repository.yaml")
  result = render_audit_report(arch, manifest, repository)
  puts result[:report]

  if write_output
    write_report(arch.dig("repository_modes", "audit", "report_path"), result[:report])
  end

  exit 1 if fail_on_gap && !result[:gaps].empty?
end

def migration_chain(migrations, current_version, target_version)
  return [] if current_version == target_version

  items = Array(migrations["migrations"])
  chain = []
  version = current_version

  while version != target_version
    next_item = items.find { |item| item["from"] == version }
    return nil unless next_item

    chain << next_item
    version = next_item["to"]
    return nil if chain.length > items.length + 1
  end

  chain
end

def apply_migration_action(action, arch, manifest)
  case action["type"]
  when nil
    nil
  when "set-applied-version"
    arch["standard"]["applied_version"] = action.fetch("value")
  when "sync-wiki-manifest"
    write_yaml(arch.dig("wiki_llm", "manifest_path"), build_wiki_manifest(arch, manifest))
  else
    raise "Unsupported migration action type: #{action['type']}"
  end
end

def commit_migration(message)
  system("git add arch-docs.yaml .arch-docs/wiki-llm/index-manifest.yaml .arch-docs/reports/standard-migration.md >/dev/null 2>&1")
  system("git commit -m #{shell_escape(message)}")
end

def run_migrate(args)
  apply = args.include?("--apply")
  commit = args.include?("--commit")
  allow_dirty = args.include?("--allow-dirty")
  arch, manifest, migrations, = load_configs
  target_version = begin
    index = args.index("--target-version")
    index ? args[index + 1] : arch.dig("standard", "target_version")
  end

  current_version = arch.dig("standard", "applied_version")
  chain = migration_chain(migrations, current_version, target_version)
  raise "No migration chain from #{current_version} to #{target_version}" if chain.nil?

  lines = []
  lines << "# Standard Migration"
  lines << ""
  lines << "- Applied version: `#{current_version}`"
  lines << "- Target version: `#{target_version}`"
  lines << "- Pending migrations: `#{chain.length}`"
  lines << "- Execution mode: `agent-led with .arch-docs/agents/standard-migrator`"
  lines << ""

  if chain.empty?
    lines << "No pending migrations."
    report = lines.join("\n") + "\n"
    puts report
    write_report(arch.dig("repository_modes", "migrate", "report_path"), report) if apply
    return
  end

  chain.each do |migration|
    lines << "## #{migration.fetch('id')}"
    lines << ""
    lines << migration.fetch("description")
    lines << ""
  end

  lines << "Перед `--apply` сначала сравните cookiecutter-репозиторий и локальный репозиторий,"
  lines << "обновите все затронутые файлы стандарта и только потом фиксируйте новую applied_version."
  lines << ""

  report = lines.join("\n") + "\n"
  puts report
  return unless apply

  raise "Dirty git worktree, rerun with --allow-dirty or clean changes first" if !allow_dirty && !git_clean?

  chain.each do |migration|
    Array(migration["actions"]).each do |action|
      apply_migration_action(action, arch, manifest)
    end
    arch["standard"]["applied_version"] = migration.fetch("to")
    write_yaml("arch-docs.yaml", arch)
    write_report(arch.dig("repository_modes", "migrate", "report_path"), report)
    commit_migration(migration.fetch("commit_message")) if commit
  end
end

def run_bootstrap(args)
  write_output = args.include?("--write-report")
  arch, manifest, = load_configs
  repository = load_yaml("repository.yaml")
  markers = placeholder_markers(manifest)
  source_globs = Array(manifest["bootstrap_source_globs"])
  sources = Dir.chdir(ROOT) do
    source_globs.flat_map { |pattern| Dir.glob(pattern, File::FNM_EXTGLOB) }
  end
  sources = sources.uniq.sort
  placeholders = collect_placeholders(repository, markers)
  missing_sections = Array(manifest["expected_sections"]).reject { |section| Dir.exist?(ROOT.join(section)) }
  wiki_status = wiki_manifest_current?(arch, manifest) ? "current" : "stale"

  lines = []
  lines << "# Bootstrap Gap Report"
  lines << ""
  lines << "## Sources Discovered"
  lines << ""
  lines << "- Candidate source files: `#{sources.length}`"
  lines << "- Example inputs: #{sources.first(20).map { |item| "`#{item}`" }.join(', ')}"
  lines << ""
  lines << "## Gaps"
  lines << ""
  lines << "- Missing standard sections: #{missing_sections.empty? ? 'none' : missing_sections.map { |item| "`#{item}`" }.join(', ')}"
  lines << "- Placeholder values in `repository.yaml`: #{placeholders.empty? ? 'none' : placeholders.map { |path, value| "`#{path}=#{value}`" }.join(', ')}"
  lines << "- wiki-llm manifest: `#{wiki_status}`"
  lines << ""
  lines << "## Recommended Iteration Plan"
  lines << ""
  lines << "1. Уточнить и заполнить `repository.yaml` по найденным placeholder."
  lines << "2. Заполнить `overview.md` как корневую точку входа и разложить текущее состояние системы по `architecture/requirements/`, `architecture/`, `architecture/api/`, `architecture/data/`, `architecture/testing/`, `architecture/deployment/`, `release-notes/`, `adr/`."
  lines << "3. Запустить `./.arch-docs/scripts/wiki-llm-sync.sh`, затем `./.arch-docs/scripts/audit-standard.sh --fail-on-gap`."
  report = lines.join("\n") + "\n"

  puts report
  write_report(arch.dig("repository_modes", "bootstrap", "report_path"), report) if write_output
end

def run_wiki_sync(args)
  check = args.include?("--check")
  arch, manifest, = load_configs
  manifest_data = build_wiki_manifest(arch, manifest)
  path = arch.dig("wiki_llm", "manifest_path")

  if check
    exit(wiki_manifest_current?(arch, manifest) ? 0 : 1)
  end

  write_yaml(path, manifest_data)
  puts "Updated #{path} with #{manifest_data.fetch('document_count')} documents."
end

command = ARGV.shift

case command
when "audit"
  run_audit(ARGV)
when "migrate"
  run_migrate(ARGV)
when "bootstrap"
  run_bootstrap(ARGV)
when "wiki-llm-sync"
  run_wiki_sync(ARGV)
else
  warn "Usage: .arch-docs/scripts/arch-docs-tool.rb [audit|migrate|bootstrap|wiki-llm-sync] [options]"
  exit 1
end
