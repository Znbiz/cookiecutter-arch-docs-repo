# {{cookiecutter.project_name}}

Этот репозиторий является primary source of truth для архитектуры, требований, контрактов, бизнес-фич, тестовых сценариев, release notes и workflow документационного управления продуктом `{{cookiecutter.project_id}}`.

Код продукта в этом репозитории не хранится.

## Основная идея

Работа ведётся по подходу Architecture / Documentation First:

1. Сначала описывается фича и её impact.
2. Затем документация проходит review и согласование.
3. После этого реализация выполняется в кодовых репозиториях.
4. Merge документации в `{{cookiecutter.default_branch}}` допускается только после проверки соответствия реализации документации.

## Быстрый старт для Codex

1. Прочитать [AGENTS.md](AGENTS.md).
2. Прочитать [repository.yaml](repository.yaml).
3. Изучить текущую документацию по разделам.
4. Для новой фичи сначала использовать skill `agents/analyst-architect`.
5. Для раскладки изменений использовать `agents/documentation-mapper`.
6. Перед коммитом пройти review skills и оформить review report.

## Как вызвать skills

Skills вызываются текстом в запросе к Codex.

Примеры:

- `Codex, работай по AGENTS.md и используй skill agents/analyst-architect.`
- `Codex, работай по AGENTS.md и используй skill agents/documentation-mapper.`
- `Codex, работай по AGENTS.md и используй skills agents/completeness-reviewer, agents/contract-reviewer, agents/test-reviewer.`

## Основные команды

```bash
./scripts/validate-docs.sh
./scripts/validate-links.sh
./scripts/validate-schemas.sh
./scripts/validate-mermaid.sh
./scripts/validate-openapi.sh
./scripts/validate-asyncapi.sh
```

## Типовые сценарии

Подробный workflow вынесен в [docs/codex-workflow.md](docs/codex-workflow.md).
