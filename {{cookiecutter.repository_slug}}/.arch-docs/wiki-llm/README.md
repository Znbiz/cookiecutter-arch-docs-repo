# wiki-llm

`wiki-llm` обязателен для этого репозитория и используется как локальный
retrieval-слой поверх документации.

## Что читать

- `retrieval-policy.md` — что считается source of truth
- `source-policy.md` — приоритеты источников
- `branch-policy.md` — интерпретация веток и релизов
- `indexing.yaml` — какие файлы индексируются
- `index-manifest.yaml` — детерминированный индекс текущего состояния

## Как обновлять индекс

После любого изменения документации запустите:

```bash
./.arch-docs/scripts/wiki-llm-sync.sh
```

Для проверки без перезаписи manifest:

```bash
./.arch-docs/scripts/wiki-llm-sync.sh --check
```

## Как использовать в workflow

1. Сначала обновить `index-manifest.yaml`.
2. Затем читать `AGENTS.md`, `arch-docs.yaml`, `repository.yaml`, `overview.md`, `glossary.md`.
3. По общему вопросу о продукте, команде, интеграциях или стендах сначала идти в `overview.md`.
4. По вопросу о конкретной возможности сначала находить соответствующий файл в `features/`.
5. После этого читать профильные документы и локальные roles.

Если индекс устарел, сначала нужно синхронизировать `wiki-llm`, а потом
проводить audit, bootstrap или review.
