# Stud Book — Flutter Web

Desktop web client for the Stud Book API. Screens below 1024 px show a "Mobile isn’t supported yet" placeholder.

## Run

Flutter version is pinned in `.fvmrc` (3.41.4).

```bash
docker compose up db -d                 # from the repo root
cd StudBook.Backend/Web && dotnet run   # API on http://localhost:5266
cd StudBook.Frontend/app
fvm flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:5266
```

Without `API_BASE_URL` the app calls the API on its own origin, which is how it runs behind nginx in Docker:

```bash
docker compose up --build               # app on http://localhost:8081
```

Checks:

```bash
fvm flutter analyze
fvm flutter test
```

## Structure

Feature-first, Clean Architecture inside every feature, state in BLoC.

```text
lib/
  app/                  composition root: DI (get_it), router (go_router), shell with side navigation
  core/
    theme/
      tokens/           palette, spacing, radii, sizes, breakpoints, typography — the only raw values
      extensions/       ThemeExtensions: status colours, buttons, fields, tags, tables, surfaces, navigation
      app_theme.dart    ThemeData built from tokens
    widgets/            shared UI built on the extensions: AppButton, AppTextField, AppDropdown, AppTable, …
    network/            ApiClient (dio), errors → Failure
    error/, usecase/, utils/
  features/
    auth/               sign-in and role, session persisted locally
    horses/             registry (OW-01), horse card with pedigree (OW-02), add/edit (OW-03), removal
    clients/            owners list for the horse form
    compatibility_rules/ rule table (OW-15)
    client_home/        client landing page
```

Each feature is split into `domain` (entities, repository contracts, use cases), `data` (models, data sources, repository implementations) and `presentation` (blocs, pages, widgets, strings).

## Design rules

- Visual style follows the Stud Book UI Kit (Foundations and Components).
- Widgets never use hex colours or pixel literals: values come from `core/theme/tokens` or a ThemeExtension through `context.colors`, `context.buttons`, `context.fields`, `context.table`, and so on.
- Reusable controls live in `core/widgets` and are the only way screens draw buttons, fields, dropdowns, tags and tables, so they look the same everywhere.
