# Standard Audit

- Template: `znbiz/cookiecutter-arch-docs-repo`
- Applied version: `2026.05.6`
- Target version: `2026.05.6`
- Version status: `aligned`
- Bootstrap status: `scaffold`
- wiki-llm manifest: `current`

## Gaps

- Missing required files: none
- Missing required directories: none
- Missing required roles: none
- Missing required scripts: none

## Placeholder Findings

- `repository.yaml`: `project.id={{cookiecutter.project_id}}`, `project.name={{cookiecutter.project_name}}`, `project.owner_team={{cookiecutter.owner_team}}`, `project.documentation_language={{cookiecutter.documentation_language}}`, `role_policy.0.notes=Замените на реальные роли и границы ответственности.`, `repositories.0.provider={{cookiecutter.primary_git_provider}}`, `repositories.0.url=https://{{cookiecutter.primary_git_provider}}.example.com/org/example-app`, `repositories.0.default_branch={{cookiecutter.default_branch}}`, `repositories.0.primary_languages.0=unknown`, `repositories.0.frameworks.0=unknown`, `repositories.0.description=Замените на реальные кодовые репозитории продукта.`, `services.0.runtime=unknown`, `services.0.language=unknown`, `services.0.framework=unknown`, `services.0.description=Опишите основной сервис или компонент.`, `datastores.0.type=unknown`, `datastores.0.purpose=Опишите назначение хранилища.`, `queues.0.type=unknown`, `queues.0.purpose=Опишите очередь, топик или брокер, если применимо.`, `external_services.0.protocol=unknown`, `external_services.0.purpose=Опишите внешнюю систему, если она есть.`, `environments.0.notes=Замените адреса и ресурсы на реальные значения.`
- `arch-docs.yaml`: none
