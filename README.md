# cookiecutter-arch-docs-repo

Cookiecutter-шаблон для архитектурного репозитория в подходе Architecture / Documentation First.

Шаблон создаёт отдельный репозиторий, в котором документация является primary source of truth для:

- требований;
- бизнес-фич;
- архитектуры;
- API и event-контрактов;
- данных;
- тестовых сценариев;
- deployment/runtime-решений;
- release notes;
- Codex workflow и review skills.

## Что создаётся

После генерации получается архитектурный репозиторий с:

- `AGENTS.md` как главным набором правил для Codex;
- `arch-docs.yaml` как машиночитаемой конфигурацией локального стандарта;
- служебными каталогами `.arch-docs/` и `.docs/`, где лежат роли Codex,
  шаблоны документов, YAML-схемы, deterministic scripts, retrieval-конфигурация,
  локальный стандарт, generated reports и workflow-инструкции;
- адаптером под GitLab CI и набором локальных валидаций;
- конфигурацией `.arch-docs/wiki-llm/` для retrieval-политик.

## Использование

```bash
cookiecutter .
```

Рекомендуемые параметры:

- `project_id` — стабильный идентификатор продукта;
- `project_name` — человекочитаемое имя;
- `repository_slug` — имя создаваемого архитектурного репозитория;
- `feature_prefix` — префикс веток для документационных инкрементов;
- `primary_git_provider` — `github` или `gitlab`.

## Что важно после генерации

1. Обновить `repository.yaml` под реальные кодовые репозитории, сервисы, БД и интеграции.
2. Заполнить шаблонные разделы в `repository.yaml` и профильных каталогах реальным содержимым.
3. Проверить локально:

```bash
./.arch-docs/scripts/audit-standard.sh --fail-on-gap
./.arch-docs/scripts/wiki-llm-sync.sh
./.arch-docs/scripts/validate-docs.sh
./.arch-docs/scripts/validate-links.sh
./.arch-docs/scripts/validate-schemas.sh
./.arch-docs/scripts/validate-mermaid.sh
./.arch-docs/scripts/validate-openapi.sh
./.arch-docs/scripts/validate-asyncapi.sh
```

4. При необходимости добавить CI-адаптацию под ваш git-провайдер и организационные правила вокруг MR/PR.

## Новые локальные режимы

- `./.arch-docs/scripts/audit-standard.sh` проверяет отставание локального репозитория от текущего стандарта, обязательные артефакты и stale `.arch-docs/wiki-llm` индекс.
- `./.arch-docs/scripts/migrate-standard.sh` строит цепочку миграций стандарта и фиксирует её версионное прохождение; фактическое обновление файлов выполняет skill `.arch-docs/agents/standard-migrator`.
- `./.arch-docs/scripts/bootstrap-repo.sh` формирует as-is bootstrap gap-report для существующего проекта.
- `./.arch-docs/scripts/wiki-llm-sync.sh` обновляет локальный `.arch-docs/wiki-llm/index-manifest.yaml` после изменений документации.

## Как вызывать skills в Codex

Шаблон поставляет роли в `.arch-docs/agents/*/SKILL.md`. Их можно вызывать прямо текстом в запросе к Codex.

Примеры:

- `Codex, работай по AGENTS.md и используй skill .arch-docs/agents/standard-migrator. Сначала сравни локальный репозиторий с cookiecutter-стандартом, затем выполни миграцию на target_version.`
- `Codex, работай по AGENTS.md и используй skill .arch-docs/agents/analyst-architect для уточнения новой фичи.`
- `Codex, используй skill .arch-docs/agents/documentation-mapper и разложи изменения по документации.`
- `Codex, проверь текущую ветку через skills .arch-docs/agents/completeness-reviewer, .arch-docs/agents/contract-reviewer и .arch-docs/agents/test-reviewer.`

Практика использования:

- сначала сослаться на `AGENTS.md`;
- затем явно назвать один или несколько skills;
- после этого сформулировать задачу и ожидаемый результат.

Если нужен повторяемый процесс, добавляйте готовые формулировки в `AGENTS.md` и соответствующий `.arch-docs/agents/*/SKILL.md`, а не в предметные документы репозитория.

## Принципы шаблона

- `main` содержит только production-состояние документации.
- Документация мержится после реализации в кодовых репозиториях.
- CI выполняет только детерминированные проверки.
- Review skills запускаются локально до коммита и не вызываются из CI.
- Неизвестные требования фиксируются как `Неизвестно / требует уточнения`.
