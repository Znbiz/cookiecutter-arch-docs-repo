# Retrieval Policy

- Источник истины — только файлы этого репозитория и доступные кодовые репозитории.
- Ответ должен различать `{{cookiecutter.default_branch}}`, feature branches, release branches и tags.
- `{{cookiecutter.default_branch}}` считается production-состоянием.
- Feature branch считается будущим инкрементом и не может выдаваться как уже реализованное поведение.
