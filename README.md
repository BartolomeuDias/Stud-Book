# Stud Book

## Структура
- `StudBook.Backend/` — ASP.NET Core API
  - `Core/Domain` — сущности
  - `Core/Application` — сервисы, DTO, интерфейсы (репозитории)
  - `Infrastructure` — EF Core / PostgreSQL, сидер, демоданные (`Seed/demo_data_v1.json`)
  - `Web` — контроллеры, контракты (HTTP-модели), `Program.cs`
- `StudBook.Frontend/app` — Flutter Web клиент (desktop), подробности в `StudBook.Frontend/app/README.md`
- `StudBook.Frontend/html` — старые HTML-заглушки, больше не раздаются
- `docs/` — проектная документация

## Запуск через Docker
    docker compose up --build

- Приложение: http://localhost:8081
- API / OpenAPI: http://localhost:8080 (`/health`, `/openapi/v1.json`)

## Запуск локально (без Docker для API)
    docker compose up db -d
    cd StudBook.Backend/Web
    dotnet run

API: http://localhost:5266 (см. `Properties/launchSettings.json`). Фронт в режиме разработки:

    cd StudBook.Frontend/app
    fvm flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:5266

В Development API разрешает CORS для localhost.