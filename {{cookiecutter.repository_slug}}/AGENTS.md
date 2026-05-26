# AGENTS.md

## Назначение репозитория

Этот репозиторий является primary source of truth для архитектуры, требований, контрактов, бизнес-фич, тестовых сценариев, release notes и документации одного продукта или одного проекта.

Код продукта в этом репозитории не хранится.

## Основной принцип

Работа ведётся по подходу Architecture / Documentation First.

Любая существенная бизнес-фича сначала описывается в архитектурном репозитории, согласуется через MR/PR, затем реализуется в кодовых репозиториях.

MR/PR в архитектурный репозиторий мержится только после того, как реализация в кодовых репозиториях завершена и проверена на соответствие документации.

## Язык документации

Вся документация ведётся на русском языке.

## Branch model

- `{{cookiecutter.default_branch}}` — актуальное production-состояние документации.
- `{{cookiecutter.feature_prefix}}/*` — будущие изменения.
- `release/*` — состояние конкретных релизов.
- `tags` — зафиксированные release snapshots.

## Workflow разработки фичи

1. Получить описание фичи.
2. Прочитать текущую документацию.
3. Прочитать `repository.yaml`.
4. Изучить доступные кодовые репозитории, если доступ есть.
5. Задать пользователю уточняющие вопросы.
6. Не придумывать неизвестные требования.
7. Создать feature branch по шаблону `{{cookiecutter.feature_prefix}}/FEATURE-XXX-short-name`.
8. Создать или обновить файл `features/FEATURE-XXX-short-name.md`.
9. Разложить изменения по профильным разделам документации.
10. Запустить review skills до коммита.
11. Исправить критичные замечания.
12. Создать commit.
13. Создать MR/PR.
14. Дождаться human review.
15. После реализации в кодовых репозиториях проверить соответствие реализации документации.
16. Если реализация соответствует документации, MR/PR может быть смержен в `{{cookiecutter.default_branch}}`.
17. Если фичу решили не делать, MR/PR закрывается без merge.

## Правила features/

В `features/` хранятся только реализованные бизнес-фичи.

Формат файла:

`features/FEATURE-XXX-short-name.md`

В `{{cookiecutter.default_branch}}` не должно быть draft-фич.

## Правила обновления документации

- Файл в `features/` является единым описанием бизнес-фичи, а не контейнером для вспомогательных артефактов.
- Неизвестные факты фиксируются как `Неизвестно / требует уточнения`.
- При наличии impact изменения должны быть разложены по `requirements/`, `processes/`, `architecture/`, `api/`, `events/`, `data/`, `testing/`, `deployment/`, `release-notes/`.
- При наличии архитектурного выбора нужно создать или обновить ADR.

## Правила CI

CI выполняет только детерминированные проверки.

CI не должен вызывать LLM, Codex skills, агентов или внешние reasoning-сервисы.

## Обязательные локальные review skills

Перед коммитом запустить:

- `analyst-architect` self-check;
- `documentation-mapper`;
- `completeness-reviewer`;
- `architecture-reviewer`;
- `contract-reviewer`;
- `test-reviewer`;
- `security-reviewer`.

## Справочник по roles

Ниже приведено краткое назначение каждого skill из `agents/*/SKILL.md`.

- `agents/analyst-architect`:
  Используется в начале работы над новой или изменяемой фичей.
  Собирает уточнения, формирует draft feature-файла, определяет impacted sections и решает, нужен ли ADR.

- `agents/documentation-mapper`:
  Используется после согласования feature-инкремента.
  Раскладывает изменения по профильным разделам документации и проверяет непротиворечивость ссылок между feature, tests, contracts и release notes.

- `agents/completeness-reviewer`:
  Используется перед коммитом как проверка полноты.
  Ищет пропуски в problem statement, requirements, acceptance criteria, e2e, release notes, deployment impact и traceability.

- `agents/architecture-reviewer`:
  Используется для архитектурного review документационного инкремента.
  Проверяет целостность между context, container, LLD, integrations, security, observability и ADR.

- `agents/contract-reviewer`:
  Используется при изменениях API, events или data contracts.
  Проверяет backward compatibility, breaking changes, схемы payload и наличие миграционного описания.

- `agents/test-reviewer`:
  Используется для проверки тестового покрытия.
  Сопоставляет acceptance criteria с e2e, contract, security, load и regression-покрытием.

- `agents/security-reviewer`:
  Используется при наличии security или privacy impact.
  Проверяет authentication, authorization, PII, audit, secrets, trust boundaries, внешние интеграции и обязательные security tests.

- `agents/implementation-verifier`:
  Используется после реализации в кодовых репозиториях.
  Сверяет feature и impacted docs с реальными MR/PR и формирует verification report по соответствию документации и реализации.

## Правила создания MR/PR

Описание MR/PR должно содержать:

- Feature ID;
- краткое описание фичи;
- ссылку на задачу;
- список изменённых разделов документации;
- открытые вопросы;
- результаты review skills;
- чеклист готовности к implementation;
- явное указание `Не мержить до завершения реализации в кодовых репозиториях`.

## Как вызывать роли в Codex

Вызывать роли нужно явно, текстом в запросе.

Базовый паттерн:

1. Сказать `Работай по AGENTS.md`.
2. Назвать один или несколько skills из `agents/*/SKILL.md`.
3. Описать задачу и ожидаемый артефакт.

Примеры команд:

- `Codex, работай по AGENTS.md и используй skill agents/analyst-architect. Сначала задай уточняющие вопросы по новой фиче.`
- `Codex, работай по AGENTS.md и используй skill agents/documentation-mapper. Разложи согласованные изменения по профильным разделам документации.`
- `Codex, работай по AGENTS.md и используй skills agents/completeness-reviewer, agents/contract-reviewer, agents/test-reviewer. Проверь текущую ветку и сформируй review report.`

Правило шаблона:

- примеры вызова и сценарии работы держим в `AGENTS.md` и `agents/*/SKILL.md`;
- предметные документы репозитория не должны содержать демо-фичу, демо-домен или встроенный walkthrough.

## Правила проверки реализации

После merge кода нужно:

1. Прочитать feature-файл.
2. Сопоставить acceptance criteria и реализацию.
3. Проверить API, events, data, testing и deployment sections.
4. Сверить фактические MR/PR в кодовых репозиториях.
5. Зафиксировать статусы:
   - соответствует;
   - не соответствует;
   - невозможно проверить;
   - требует ручной проверки.

## Критичные ошибки

MR/PR не должен быть создан или должен быть помечен как not ready, если есть:

- конфликт с текущей документацией;
- неполное описание фичи;
- отсутствие acceptance criteria;
- отсутствие e2e тест-кейсов;
- отсутствие описания API/event/data impact при наличии такого impact;
- отсутствие ADR при наличии архитектурного выбора;
- отсутствие release notes;
- отсутствие deployment/runtime impact при наличии такого impact.
