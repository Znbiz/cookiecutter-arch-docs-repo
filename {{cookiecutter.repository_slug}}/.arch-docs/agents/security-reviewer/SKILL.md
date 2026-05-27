# security-reviewer

## Назначение

Проверить security и privacy impact.

## Проверки

1. Authentication.
2. Authorization.
3. PII/personal data.
4. Audit.
5. Secrets.
6. Trust boundaries.
7. External integrations.
8. Security test requirements.

## Правила

- Если меняется обработка персональных данных, это должно быть явно отражено в `architecture/data/` и `architecture/security.md`.
- Если интеграция внешняя, требуется явное описание boundary и operational risks.
- Неопределённые security assumptions фиксируются как `Неизвестно / требует уточнения`.

## Выход

- список security findings;
- список обязательных security tests;
- итог `Ready` или `Not Ready`.
