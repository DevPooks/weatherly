# CV summary

## Weatherly — Responsive Weather Application

**Flutter, Dart, Riverpod, Dio, go_router, SharedPreferences, Open-Meteo**

- Built a responsive Flutter application that retrieves current, hourly, and seven-day weather forecasts with debounced city search and route-backed detail views.
- Structured API parsing, domain entities, repository contracts, and Riverpod presentation state into testable feature layers.
- Implemented persistent local favorites, adaptive mobile/web navigation, typed failure handling, retry flows, and dedicated loading and empty states.
- Added deterministic unit and widget coverage for API mapping, providers, search behavior, persistence, condition codes, and UI states without live network dependencies.
- Configured automated formatting, static analysis, tests, and web build validation in GitHub Actions.

## One-line version

Developed a tested Flutter weather app with Open-Meteo integration, Riverpod state management, responsive layouts, persistent favorites, and CI validation.

## Versión en español

**Weatherly — Aplicación meteorológica responsive**

- Desarrollé una aplicación responsive con Flutter y Dart para consultar clima actual y pronósticos mediante la API REST de Open-Meteo, utilizando Riverpod para el estado y Dio para HTTP.
- Implementé navegación con go_router, búsqueda con debounce, favoritos persistentes, layouts adaptativos y estados explícitos de carga, error y resultados vacíos.
- Añadí tests unitarios, de providers y widgets con flutter_test, sustituyendo la red y el almacenamiento por fakes deterministas.
