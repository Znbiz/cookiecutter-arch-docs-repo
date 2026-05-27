# {{cookiecutter.project_name}}

Этот репозиторий является primary source of truth для архитектуры, требований, контрактов, фич и возможностей продукта, тестовых сценариев, release notes и workflow документационного управления продуктом `{{cookiecutter.project_id}}`.

Код продукта в этом репозитории не хранится.

## Основная идея

Работа ведётся по подходу Architecture / Documentation First:

1. Сначала описывается фича или изменяемая возможность системы и её impact.
2. Затем документация проходит review и согласование.
3. После этого реализация выполняется в кодовых репозиториях.
4. Merge документации в `{{cookiecutter.default_branch}}` допускается только после проверки соответствия реализации документации.

## Быстрый старт для Codex

1. Прочитать [AGENTS.md](AGENTS.md).
2. Прочитать [arch-docs.yaml](arch-docs.yaml).
3. Прочитать [repository.yaml](repository.yaml).
4. Прочитать [overview.md](overview.md) и [glossary.md](glossary.md).
5. Проверить актуальность локального индекса через `./.arch-docs/scripts/wiki-llm-sync.sh --check`.
6. Изучить текущую документацию по разделам.
7. Если обновляется сам стандарт репозитория, сначала использовать skill `.arch-docs/agents/standard-migrator`.
8. Для новой фичи сначала использовать skill `.arch-docs/agents/analyst-architect`.
9. Для раскладки изменений использовать `.arch-docs/agents/documentation-mapper`.
10. Перед коммитом пройти review skills и оформить review report.

Для process impact по конкретной фиче сначала обновляйте сам feature-файл как
каноническое описание этой возможности.
Дальше раскладывайте impact по профильным разделам, если он влияет на требования, тесты, deployment или эксплуатацию.

## Как вызвать skills

Skills вызываются текстом в запросе к Codex.

Примеры:

- `Codex, работай по AGENTS.md и используй skill .arch-docs/agents/standard-migrator.`
- `Codex, работай по AGENTS.md и используй skill .arch-docs/agents/analyst-architect.`
- `Codex, работай по AGENTS.md и используй skill .arch-docs/agents/documentation-mapper.`
- `Codex, работай по AGENTS.md и используй skills .arch-docs/agents/completeness-reviewer, .arch-docs/agents/contract-reviewer, .arch-docs/agents/test-reviewer.`

## Основные команды

```bash
./.arch-docs/scripts/audit-standard.sh --fail-on-gap
./.arch-docs/scripts/migrate-standard.sh
./.arch-docs/scripts/bootstrap-repo.sh --write-report
./.arch-docs/scripts/wiki-llm-sync.sh
./.arch-docs/scripts/validate-docs.sh
./.arch-docs/scripts/validate-links.sh
./.arch-docs/scripts/validate-schemas.sh
./.arch-docs/scripts/validate-mermaid.sh
./.arch-docs/scripts/validate-openapi.sh
./.arch-docs/scripts/validate-asyncapi.sh
```

## Типовые сценарии

Подробный workflow вынесен в [.docs/codex-workflow.md](.docs/codex-workflow.md).
Обучающее руководство по внедрению и повседневной работе вынесено в
[.docs/tool-adoption-guide.md](.docs/tool-adoption-guide.md).
Описание полей служебных и предметных YAML-файлов вынесено в
[.docs/yaml-field-reference.md](.docs/yaml-field-reference.md).

## Operating Model

- `arch-docs.yaml` хранит версию локального стандарта, режимы `audit/migrate/bootstrap` и настройку `wiki-llm`.
- `.arch-docs/agents/standard-migrator/SKILL.md` описывает agent-led процесс анализа изменений шаблона и миграции локального стандарта.
- `.arch-docs/standard/manifest.yaml` задаёт обязательные файлы, каталоги, роли и этапы процесса.
- `.arch-docs/standard/migrations.yaml` хранит цепочку миграций стандарта.
- `.arch-docs/wiki-llm/index-manifest.yaml` обновляется локально после изменений документации и проверяется в CI.
