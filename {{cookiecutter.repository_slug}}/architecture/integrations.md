# Integrations

Для каждой интеграции должно быть явно видно, с кем интегрируемся и зачем.

| Integration | Counterpart | Direction | Protocol | Purpose | Owner | Risks / Notes |
| --- | --- | --- | --- | --- | --- | --- |
| Example External API | external partner / external system | outbound | HTTPS | Опишите бизнес-цель интеграции | architecture-owner | timeouts, rate limits, contract drift |
| Example Event Flow | internal broker / downstream consumer | inbound or outbound | Kafka / AMQP / etc | Опишите, какие события и зачем передаются | engineering-team | retries, duplication, eventual consistency |

Правила:

- каждая интеграция должна иметь owner;
- назначение интеграции должно быть сформулировано в терминах бизнес-ценности или операционной необходимости;
- если интеграция внешняя, укажите trust boundary и ограничения доступа;
- синхронизируйте этот раздел с `repository.yaml -> integration_catalog`.
