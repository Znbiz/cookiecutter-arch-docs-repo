# Environments

Для каждого стенда фиксируйте не только назначение, но и адреса, owner и ресурсы.

| Environment | Purpose | Public Address | Internal Address / Endpoint | Owner | Runtime Resources | Notes |
| --- | --- | --- | --- | --- | --- | --- |
| `dev` | Ранняя проверка сценариев и интеграций | `https://dev.example.com` | `http://example-service.dev.svc.cluster.local:8080` | engineering-team | `1 replica`, `500m CPU`, `512Mi RAM`, `shared DB` | Замените на реальные значения |
| `stage` | Интеграционные, contract и e2e проверки | `https://stage.example.com` | `http://example-service.stage.svc.cluster.local:8080` | engineering-team / QA | `2 replicas`, `1 CPU`, `1Gi RAM`, `isolated DB` | Стенд, близкий к production |
| `prod` | Production runtime | `https://prod.example.com` | `http://example-service.prod.svc.cluster.local:8080` | operations / SRE | `3 replicas`, `2 CPU`, `2Gi RAM`, `production DB` | Добавьте SLA/SLO-критичные параметры |

Правила:

- адреса должны быть актуальными и однозначными;
- ресурсы должны отражать реальную конфигурацию стенда;
- если адреса или железо неизвестны, фиксируйте `Неизвестно / требует уточнения`;
- синхронизируйте раздел с `repository.yaml -> environments`.
