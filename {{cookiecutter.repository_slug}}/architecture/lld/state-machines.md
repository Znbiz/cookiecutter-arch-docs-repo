# State Machines

```mermaid
stateDiagram-v2
    [*] --> initial
    initial --> in_progress: trigger received
    in_progress --> completed: success
    in_progress --> failed: error
    completed --> archived: lifecycle finished
```
