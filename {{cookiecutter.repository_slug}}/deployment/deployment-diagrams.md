# Deployment Diagrams

```mermaid
flowchart LR
    Ingress["Ingress"] --> API["Subscription Service"]
    API --> DB["PostgreSQL"]
    API --> Kafka["Kafka"]
    Worker["Subscription Worker"] --> DB
    Worker --> Kafka
```
