# Workflow работы с Codex

## Провести audit стандарта

```text
Codex, работай по AGENTS.md.
Сначала прочитай arch-docs.yaml, .arch-docs/standard/manifest.yaml и repository.yaml.
Запусти локальный audit стандарта, проверь gap-report и скажи, что устарело относительно шаблона.
```

Команда:

```bash
./.arch-docs/scripts/audit-standard.sh --fail-on-gap
```

## Подготовить migration плана

```text
Codex, работай по AGENTS.md.
Используй skill .arch-docs/agents/standard-migrator.
Проверь arch-docs.yaml, .arch-docs/standard/migrations.yaml и diff между cookiecutter-репозиторием и текущим локальным репозиторием.
Сформируй план миграции локального репозитория на target_version и предложи, какие изменения будут идти commit-by-commit.
```

Команда:

```bash
./.arch-docs/scripts/migrate-standard.sh
```

Примечание:

- `migrate-standard.sh` сам по себе не заменяет анализ и перенос файлов стандарта; он используется вместе со skill `.arch-docs/agents/standard-migrator`.

Применить миграцию:

```bash
./.arch-docs/scripts/migrate-standard.sh --apply --commit
```

## Bootstrap существующего проекта

```text
Codex, работай по AGENTS.md.
Собери текущее состояние проекта as is из repository.yaml, документации, CI-конфигов и контрактов.
Сформируй bootstrap gap-report и перечисли, что ещё требует уточнения.
```

Команда:

```bash
./.arch-docs/scripts/bootstrap-repo.sh --write-report
```

## Синхронизировать wiki-llm

```bash
./.arch-docs/scripts/wiki-llm-sync.sh
```

Проверка без обновления:

```bash
./.arch-docs/scripts/wiki-llm-sync.sh --check
```

## Создать новую фичу

```text
Codex, работай по AGENTS.md и используй skill .arch-docs/agents/analyst-architect.
Сначала задай уточняющие вопросы по новой фиче.
После уточнения подготовь feature-файл, опиши process impact в секции
`Затронутые бизнес-процессы` и перечисли затронутые разделы.
```

## Проверить готовность фичи

```text
Codex, работай по AGENTS.md и используй skills .arch-docs/agents/completeness-reviewer,
.arch-docs/agents/architecture-reviewer, .arch-docs/agents/contract-reviewer, .arch-docs/agents/test-reviewer,
.arch-docs/agents/security-reviewer.
Проверь текущую ветку локально, не вызывай CI, сформируй review report.
```

## Разложить изменение по документации

```text
Codex, работай по AGENTS.md и используй skill .arch-docs/agents/documentation-mapper.
Разложи изменения из feature-файла по профильным разделам документации.
```

Feature-файл здесь считается каноническим описанием конкретной возможности.
Разделы `architecture/requirements/`, `architecture/api/`, `architecture/data/`,
`architecture/testing/`, `architecture/deployment/`, а также `release-notes/`
не заменяют его, а уточняют его со своей стороны.

## Проверить реализацию

```text
Codex, работай по AGENTS.md и используй skill .arch-docs/agents/implementation-verifier.
Проверь соответствие реализации документации по feature-файлу и связанным репозиториям.
```

## Правила использования

- Codex сначала читает `README.md`, `AGENTS.md`, `arch-docs.yaml`, `repository.yaml`, `overview.md`, `glossary.md` и только потом профильные разделы документации.
- Если изменение затрагивает поведение системы, Codex должен найти и обновить соответствующий feature-файл до раскладки impact по профильным разделам.
- Если `.arch-docs/wiki-llm/index-manifest.yaml` устарел, сначала нужно запустить `./.arch-docs/scripts/wiki-llm-sync.sh`.
- Если данных недостаточно, Codex обязан фиксировать `Неизвестно / требует уточнения`.
- Перед коммитом Codex обязан пройти локальные review skills.
- В CI не должны запускаться агенты и semantic review.
