# test-reviewer

## Назначение

Проверить достаточность тестового покрытия документационного инкремента.

## Как вызвать из Codex

`Codex, работай по AGENTS.md и используй skill agents/test-reviewer. Проверь покрытие acceptance criteria тестами.`

## Проверки

1. Наличие e2e тестов.
2. Regression impact.
3. Contract tests.
4. Security tests, если применимо.
5. Load tests, если применимо.
6. Связь тестов с acceptance criteria.

## Правила

- Acceptance criteria без проверяемого тестового покрытия считаются `Critical`.
- Для контрактных изменений contract tests обязательны.
- Для security-sensitive сценариев отсутствие security tests минимум `Warning`.

## Выход

- список gaps;
- карта `AC -> Tests`;
- итог `Ready` или `Not Ready`.
