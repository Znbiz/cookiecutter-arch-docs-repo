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
- `agents/*/SKILL.md` для специализированных ролей;
- шаблонами документов в `templates/`;
- YAML-схемами в `schemas/`;
- детерминированными скриптами проверок в `scripts/`;
- адаптером под GitLab CI и набором локальных валидаций;
- конфигурацией `wiki-llm/` для retrieval-политик.

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
./scripts/validate-docs.sh
./scripts/validate-links.sh
./scripts/validate-schemas.sh
./scripts/validate-mermaid.sh
./scripts/validate-openapi.sh
./scripts/validate-asyncapi.sh
```

4. При необходимости добавить CI-адаптацию под ваш git-провайдер и организационные правила вокруг MR/PR.

## Как вызывать skills в Codex

Шаблон поставляет роли в `agents/*/SKILL.md`. Их можно вызывать прямо текстом в запросе к Codex.

Примеры:

- `Codex, работай по AGENTS.md и используй skill agents/analyst-architect для уточнения новой фичи.`
- `Codex, используй skill agents/documentation-mapper и разложи изменения по документации.`
- `Codex, проверь текущую ветку через skills agents/completeness-reviewer, agents/contract-reviewer и agents/test-reviewer.`

Практика использования:

- сначала сослаться на `AGENTS.md`;
- затем явно назвать один или несколько skills;
- после этого сформулировать задачу и ожидаемый результат.

Если нужен повторяемый процесс, добавляйте готовые формулировки в `AGENTS.md` и соответствующий `agents/*/SKILL.md`, а не в предметные документы репозитория.

## Принципы шаблона

- `main` содержит только production-состояние документации.
- Документация мержится после реализации в кодовых репозиториях.
- CI выполняет только детерминированные проверки.
- Review skills запускаются локально до коммита и не вызываются из CI.
- Неизвестные требования фиксируются как `Неизвестно / требует уточнения`.
