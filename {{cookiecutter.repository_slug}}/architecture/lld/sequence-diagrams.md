# Sequence Diagrams

```mermaid
sequenceDiagram
    participant Actor as Caller
    participant Service as Example Service
    participant Store as Example Datastore
    participant Bus as Example Broker

    Actor->>Service: Request / command / event
    Service->>Store: Read or write state
    Service->>Bus: Publish domain event
```
