# YAML Field Reference

Этот документ описывает структуру YAML-файлов шаблона, их основные поля и
смысл атрибутов. Для служебных конфигов комментарии находятся прямо в файлах,
а для предметных контрактов ниже приведен компактный справочник.

## `repository.yaml`

Файл описывает продукт, его репозитории, сервисы, хранилища, интеграции,
окружения и связи между ними.

### `project`

- `id` — стабильный идентификатор продукта или платформы.
- `name` — человекочитаемое название продукта.
- `description` — границы и назначение документационного репозитория.
- `owner_team` — команда, отвечающая за актуальность описания.
- `documentation_language` — основной язык документации.

### `role_policy`

- `role` — имя роли, участвующей в процессе изменения документации.
- `responsibilities` — ключевые обязанности роли.
- `access_scope` — какие разделы роль может менять или инициировать.
- `approval_scope` — какие решения и артефакты эта роль согласует.
- `notes` — локальные договоренности и пояснения.

### `repositories`

- `id` — внутренний идентификатор репозитория.
- `name` — короткое имя репозитория.
- `provider` — Git-провайдер.
- `url` — канонический URL репозитория.
- `default_branch` — основная ветка.
- `repository_type` — тип репозитория.
- `architecture_type` — архитектурная роль репозитория.
- `primary_languages` — основные языки реализации.
- `frameworks` — ключевые фреймворки и платформы.
- `contains_services` — сервисы, лежащие в репозитории.
- `contains_libraries` — библиотеки, поддерживаемые в репозитории.
- `contains_infrastructure_code` — IaC или платформенный код.
- `access_mode_for_agents` — ожидаемый режим доступа автоматизированных агентов.
- `description` — краткое назначение репозитория.

### `services`

- `id` — идентификатор сервиса.
- `repository_id` — ссылка на `repositories[].id`.
- `service_type` — тип сервиса.
- `runtime` — runtime или платформа выполнения.
- `language` — основной язык.
- `framework` — основной фреймворк.
- `description` — назначение сервиса.
- `owned_datastores` — хранилища, которыми сервис владеет.
- `consumed_datastores` — хранилища, которые сервис использует.
- `produces_events` — публикуемые события.
- `consumes_events` — потребляемые события.
- `exposed_ports` — список сетевых интерфейсов.
- `exposed_ports[].port` — номер порта.
- `exposed_ports[].protocol` — протокол.
- `exposed_ports[].purpose` — назначение порта.

### `datastores`

- `id` — идентификатор хранилища.
- `type` — тип технологии хранилища.
- `owner_service` — сервис-владелец.
- `purpose` — назначение хранилища.
- `contains_personal_data` — наличие персональных данных.
- `logical_schemas` — логические схемы, namespace или bounded contexts.
- `used_by_services` — потребители хранилища.

### `queues`

- `id` — идентификатор брокера или очереди.
- `type` — тип технологии.
- `purpose` — назначение.
- `topics` — логические каналы внутри брокера.
- `topics[].name` — имя топика/очереди.
- `topics[].producers` — издатели.
- `topics[].consumers` — потребители.

### `external_services`

- `id` — идентификатор внешней системы.
- `type` — тип внешнего контура.
- `protocol` — протокол взаимодействия.
- `purpose` — зачем нужен внешний контур.
- `used_by_services` — кто его использует.

### `integration_catalog`

- `id` — идентификатор записи об интеграции.
- `counterpart` — контрагент или внешняя система.
- `direction` — направление потока.
- `protocol` — протокол или транспорт.
- `purpose` — бизнес-назначение интеграции.
- `owner_role` — кто отвечает за согласование изменений.
- `source_service` — источник вызова/публикации.
- `target_service` — получатель вызова/события.
- `contracts` — ссылки на машиночитаемые контракты.
- `risks` — ключевые технические риски.

### `environments`

- `name` — имя окружения.
- `purpose` — для чего используется среда.
- `addresses.public_base_url` — публичная точка входа.
- `addresses.private_endpoints` — внутренние адреса сервисов.
- `resources.runtime` — среда выполнения.
- `resources.replicas` — число реплик.
- `resources.cpu` — лимит/запрос CPU.
- `resources.memory` — лимит/запрос памяти.
- `resources.datastore_tier` — класс или tier хранилища.
- `notes` — особенности среды.

### `relationships`

- `from` — сервис-источник взаимодействия.
- `to` — целевой сервис, datastore или queue.
- `type` — тип связи.
- `contract` — ссылка на документ, описывающий связь.

## `arch-docs.yaml`

Файл задает локальный стандарт репозитория, режимы его обслуживания и
обязательные роли.

### `standard`

- `template_name` — имя шаблона/стандарта.
- `template_repository` — источник шаблона.
- `applied_version` — уже примененная версия стандарта.
- `target_version` — версия, до которой нужно довести репозиторий.
- `migration_index` — путь к списку миграций стандарта.

### `repository_modes`

- `audit.enabled` — включает аудит соответствия стандарту.
- `audit.report_path` — путь к audit report.
- `audit.fail_on_gap_in_ci` — ломать ли CI при обнаружении gap.
- `migrate.enabled` — включает миграции стандарта.
- `migrate.commit_per_migration` — делать отдельный commit на миграцию.
- `migrate.allow_dirty_worktree` — можно ли запускать миграции на грязном дереве.
- `migrate.report_path` — путь к отчету о миграции.
- `bootstrap.enabled` — включает первичное наполнение.
- `bootstrap.status` — состояние bootstrap: `scaffold`, `in_progress`, `established`.
- `bootstrap.iterative` — можно ли наполнять репозиторий итеративно.
- `bootstrap.report_path` — путь к gap-report.
- `bootstrap.gather_from` — допустимые источники исходного контекста.

### `wiki_llm`

- `enabled` — включен ли локальный retrieval-слой.
- `indexing_config` — правила отбора файлов в индекс.
- `manifest_path` — путь к детерминированному manifest индекса.
- `sync_on_doc_changes` — нужно ли синхронизировать индекс после правок.
- `required_documents` — обязательный минимальный набор документов для retrieval.

### `local_roles`

- `id` — идентификатор локальной роли или skill.
- `path` — путь к `SKILL.md`.
- `required` — обязательна ли роль для стандартного workflow.
- `standard-migrator` — роль для анализа расхождений между cookiecutter-стандартом и локальным репозиторием перед миграцией.

## `architecture/data/entities.yaml`

Файл фиксирует упрощенную карту доменных сущностей и их привязку к сервисам и
хранилищам.

- `entities` — список доменных сущностей.
- `entities[].id` — стабильный идентификатор сущности.
- `entities[].owner_service` — сервис-владелец сущности.
- `entities[].datastore` — основное хранилище сущности.
- `entities[].description` — краткое бизнес-описание.
- `entities[].fields` — список атрибутов сущности.
- `entities[].fields[].name` — имя поля.
- `entities[].fields[].type` — тип поля.

## `architecture/api/events/asyncapi.yaml`

Файл описывает каталог событий и каналы event-driven взаимодействия.

- `asyncapi` — версия AsyncAPI.
- `info.title` — название event contract.
- `info.version` — версия контракта.
- `info.description` — назначение event catalog.
- `channels` — каналы/топики и операции над ними.
- `channels.<channel>.publish` — публикация события в канал.
- `channels.<channel>.subscribe` — потребление события из канала, если используется.
- `message.$ref` — ссылка на описание payload или сообщения.
- `components.messages` — переиспользуемые message definitions.

## `architecture/api/events/schemas/example-event.schema.yaml`

Файл хранит JSON Schema payload конкретного события.

- `type` — верхнеуровневый тип schema.
- `title` — имя schema.
- `required` — обязательные поля payload.
- `properties` — карта атрибутов события.
- `properties.<field>.type` — тип конкретного атрибута.

## `architecture/api/openapi/example-service.yaml`

Файл описывает HTTP API сервиса в формате OpenAPI.

- `openapi` — версия OpenAPI.
- `info.title` — название API.
- `info.version` — версия API-контракта.
- `info.description` — назначение API.
- `paths` — список маршрутов.
- `paths.<path>.<method>.summary` — короткое назначение операции.
- `paths.<path>.<method>.operationId` — стабильный идентификатор операции.
- `parameters` — параметры запроса/пути/заголовков.
- `requestBody` — тело запроса и его schema.
- `responses` — карта ответов по HTTP status.
