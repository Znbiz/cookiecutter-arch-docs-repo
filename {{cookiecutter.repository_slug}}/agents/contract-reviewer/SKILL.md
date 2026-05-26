# contract-reviewer

## Назначение

Проверить API, event и data contracts.

## Как вызвать из Codex

`Codex, работай по AGENTS.md и используй skill agents/contract-reviewer. Проверь контракты и совместимость изменений.`

## Проверки

1. OpenAPI changes.
2. AsyncAPI changes.
3. Event payload schemas.
4. Data entities.
5. Backward compatibility.
6. Breaking changes.
7. Версионирование контрактов.

## Правила

- Сопоставлять feature impact с реальными контрактами.
- Отдельно помечать breaking changes.
- Если контракт затронут, но описание миграции отсутствует, это `Critical`.

## Выход

- перечень контрактных замечаний;
- список breaking / non-breaking changes;
- рекомендации по версионированию и traceability.
