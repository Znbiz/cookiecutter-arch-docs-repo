# completeness-reviewer

## Назначение

Проверить полноту описания фичи до коммита.

## Как вызвать из Codex

`Codex, работай по AGENTS.md и используй skill .arch-docs/agents/completeness-reviewer. Проверь полноту текущего изменения и дай verdict.`

## Проверки

1. Есть ли problem statement.
2. Есть ли цели и пользовательская ценность.
3. Есть ли out of scope или ограничения.
4. Есть ли functional requirements.
5. Есть ли non-functional requirements.
6. Есть ли acceptance criteria.
7. Есть ли e2e test cases.
8. Есть ли release notes.
9. Есть ли deployment impact.
10. Есть ли traceability.

## Формат результата

- `Critical` для отсутствующих обязательных элементов;
- `Warning` для неясных формулировок;
- `Info` для улучшений.

## Рекомендация

В конце выдать `Ready` или `Not Ready`.
