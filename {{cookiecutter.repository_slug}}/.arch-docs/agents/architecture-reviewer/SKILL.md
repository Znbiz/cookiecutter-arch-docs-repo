# architecture-reviewer

## Назначение

Проверить архитектурную целостность документационного инкремента.

## Проверки

1. Соответствие `overview.md`, системных границ и container architecture.
2. Обновление LLD при изменении внутренних взаимодействий.
3. Влияние на интеграции.
4. Влияние на security.
5. Влияние на observability.
6. Нужен ли ADR.
7. Нет ли конфликта с существующими ADR.

## Правила

- Искать несоответствия между feature-файлом и архитектурными разделами.
- Отмечать missing impact, а не додумывать его.
- Если решение меняет доверенные границы, data ownership или integration style, это минимум `Warning`, часто `Critical`.

## Выход

- findings по severity;
- решение `ADR required` / `ADR not required`;
- итог `Ready` или `Not Ready`.
