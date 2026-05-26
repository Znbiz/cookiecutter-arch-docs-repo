# Workflow работы с Codex

## Создать новую фичу

```text
Codex, работай по AGENTS.md и используй skill agents/analyst-architect.
Сначала задай уточняющие вопросы по новой фиче.
После уточнения подготовь feature-файл и список затронутых разделов.
```

## Проверить готовность фичи

```text
Codex, работай по AGENTS.md и используй skills agents/completeness-reviewer,
agents/architecture-reviewer, agents/contract-reviewer, agents/test-reviewer,
agents/security-reviewer.
Проверь текущую ветку локально, не вызывай CI, сформируй review report.
```

## Разложить изменение по документации

```text
Codex, работай по AGENTS.md и используй skill agents/documentation-mapper.
Разложи изменения из feature-файла по профильным разделам документации.
```

## Проверить реализацию

```text
Codex, работай по AGENTS.md и используй skill agents/implementation-verifier.
Проверь соответствие реализации документации по feature-файлу и связанным репозиториям.
```

## Правила использования

- Codex сначала читает `README.md`, `AGENTS.md`, `repository.yaml` и профильные разделы документации.
- Если данных недостаточно, Codex обязан фиксировать `Неизвестно / требует уточнения`.
- Перед коммитом Codex обязан пройти локальные review skills.
- В CI не должны запускаться агенты и semantic review.
