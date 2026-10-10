# Contributing

Thanks for considering an improvement to Weatherly.

## Local setup

```bash
flutter pub get
flutter run -d chrome
```

Open-Meteo does not require an API key. Keep API parsing in the data layer, application concepts in domain entities, and asynchronous coordination in Riverpod providers.

## Before opening a pull request

```bash
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
flutter build web --release
```

Please add or update tests when behavior changes. Tests must not depend on live APIs. Do not commit `.env` files, credentials, build outputs, or platform-local configuration.

For visual changes, follow [DESIGN.md](DESIGN.md) and verify compact and wide layouts, keyboard navigation on web, readable semantics, and error/empty states.
