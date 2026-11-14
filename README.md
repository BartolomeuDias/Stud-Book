# Stud Book

## Структура
- `StudBook.Backend/` — ASP.NET Core API
  - `Core/Domain` — сущности
  - `Core/Application` — сервисы, DTO, интерфейсы (репозитории)
  - `Infrastructure` — EF Core / PostgreSQL, сидер, демоданные (`Seed/demo_data_v1.json`)
  - `Web` — контроллеры, контракты (HTTP-модели), `Program.cs`
- `StudBook.Frontend/` — HTML-заглушки (`html/`), позже Flutter
- `docs/` — проектная документация

## Запуск через Docker
    docker compose up --build

- Страницы: http://localhost:8081
- API / OpenAPI: http://localhost:8080 (`/health`, `/openapi/v1.json`)

## Запуск локально (без Docker для API)
    docker compose up db -d
    cd StudBook.Backend/Web
    dotnet run

API: http://localhost:5266 (см. `Properties/launchSettings.json`). Страницы без nginx не раздаются:
для них нужен `docker compose up frontend`.