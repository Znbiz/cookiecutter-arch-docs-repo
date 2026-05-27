# Branch Policy

- `{{cookiecutter.default_branch}}` — production truth.
- `{{cookiecutter.feature_prefix}}/*` — будущие изменения.
- `release/*` — состояние конкретного релиза.
- `tags` — зафиксированные release snapshots.
- Нельзя выдавать draft feature branch как реализованное production-поведение.
