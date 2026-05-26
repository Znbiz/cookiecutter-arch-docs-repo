# Диаграммы процессов

```mermaid
sequenceDiagram
    participant User as Пользователь
    participant Entry as Точка входа
    participant Core as Основной сервис
    participant Integration as Интеграция

    User->>Entry: Инициирует сценарий
    Entry->>Core: Передаёт запрос
    Core->>Integration: Вызывает зависимость
    Core-->>Entry: Возвращает результат
```
