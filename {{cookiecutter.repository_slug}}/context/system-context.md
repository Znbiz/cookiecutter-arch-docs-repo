# System Context

```mermaid
flowchart LR
    User["Пользователь"] --> App["Клиентское приложение"]
    App --> Subscription["Subscription Service"]
    Subscription --> Payment["Payment Gateway"]
    Subscription --> Kafka["Billing Events"]
    Subscription --> DB["Subscription DB"]
    Kafka --> Notification["Notification Service"]
```

## Описание

- Клиентское приложение инициирует сценарии управления подпиской.
- `Subscription Service` координирует бизнес-логику и запись в БД.
- События оплаты и активации передаются через Kafka.
