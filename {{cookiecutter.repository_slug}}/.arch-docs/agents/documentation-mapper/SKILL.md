# documentation-mapper

## Назначение

Разложить согласованный feature-инкремент по профильным разделам документации.

## Как вызвать из Codex

`Codex, работай по AGENTS.md и используй skill .arch-docs/agents/documentation-mapper. Разложи согласованные изменения по документации.`

## Вход

- feature-файл;
- результаты интервью и review;
- список затронутых сервисов, контрактов и процессов.

## Обязательные целевые разделы

- `features/`
- `architecture/`
- `architecture/requirements/`
- `architecture/lld/`
- `architecture/api/`
- `architecture/data/`
- `architecture/testing/`
- `architecture/deployment/`
- `release-notes/`
- `adr/`

## Алгоритм

1. Прочитать feature-файл целиком.
2. Отметить impacted sections.
3. Обновить только релевантные документы.
4. Сохранить единый словарь терминов и именование сущностей.
5. Проверить, что ссылки между feature, contracts, tests и release notes непротиворечивы.

## Ограничения

- Не переносить требования без явного источника.
- Не создавать фиктивные API/event/data impact.
- Не создавать ADR, если architectural choice отсутствует.

## Выход

- список обновлённых документов;
- список разделов, которые ещё требуют уточнения;
- краткая карта трассировки feature -> docs.
