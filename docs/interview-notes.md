# Interview notes

These notes explain the decisions behind Weatherly in practical terms.

## Short project explanation

Weatherly is a responsive Flutter application that searches cities through Open-Meteo and presents current, hourly, and daily weather. It uses Riverpod for asynchronous state, Dio for networking, go_router for route-backed navigation, and SharedPreferences for local favorites. The architecture keeps API parsing outside widgets and replaces external services with fakes in tests.

## Flutter, Dart, and widgets

Flutter is a UI toolkit that renders an application from a tree of widgets. The same Dart code can target Android, iOS, web, and other platforms. Dart is the programming language: it provides sound null safety, classes, futures, streams, and the tooling used to analyze, test, and compile the project.

A widget is an immutable description of part of the interface. Flutter rebuilds the relevant descriptions when state changes and updates the rendered element tree efficiently. Layout widgets such as `Row`, `Column`, `Expanded`, `GridView`, and `LayoutBuilder` are composed with visual and interactive widgets.

`StatelessWidget` is appropriate when output depends only on constructor arguments and inherited state. `StatefulWidget` owns short-lived mutable state whose lifecycle belongs to one screen. Weatherly uses a `StatefulWidget` for the search text and controller; shared application state stays in Riverpod.

## Why Riverpod?

Riverpod makes dependencies explicit and easy to override. The repository, selected city, forecasts, search results, and favorite store are all providers. A widget watches the state it needs, while tests replace the real repository or persistence layer without changing production code.

`AsyncValue` also gives the interface a single model for loading, success, and failure. This reduces manual boolean state and prevents impossible combinations such as loading and data errors appearing together.

### Provider types used here

- `Provider` creates stable dependencies such as the Dio client, data source, repository, and favorites store.
- `FutureProvider.family` loads weather or search data for a specific city/query and exposes an `AsyncValue`.
- `NotifierProvider` owns the currently selected city.
- `AsyncNotifierProvider` loads and changes persisted favorites.

Weatherly does not use `StateProvider`: the selected city has named behavior through `SelectedCityController`, while search text is local widget state.

## Why Dio?

Dio provides concise query parameters, connect/send/receive timeouts, and typed transport errors. Weatherly does not depend on interceptors or complex middleware, but the client leaves room for logging, retry, or caching policies later.

## How does a REST request work?

The app sends an HTTP `GET` request to an Open-Meteo endpoint with query parameters such as coordinates, time zone, and requested fields. Dio waits for the JSON response. The data source reads the transport model, and the repository returns domain entities to the provider. A `Future` represents a value that will arrive later; `async` allows a function to return one, while `await` pauses that function without blocking Flutter's UI thread.

## Why a repository?

The Open-Meteo JSON shape should not leak into the interface. The repository contract returns domain entities and hides whether data came from HTTP, a cache, or a fixture. It also gives provider and widget tests a narrow fakeable seam.

## How is API data mapped safely?

Current conditions are read from a JSON object. Hourly and daily forecasts arrive as parallel arrays, so the mapper uses the shortest valid array length rather than assuming every list is complete. Dates and numbers are parsed defensively, then converted into immutable domain objects before rendering.

## How does search work?

The text field stores the current query locally. Queries shorter than two characters return immediately. Valid queries wait 350ms before calling the repository, which prevents a request for every keystroke. The provider is `autoDispose`, so results belong to the active query and screen lifecycle.

## What does go_router do?

`go_router` maps URLs to pages and updates browser history on web. It builds on Flutter's Navigator but makes route definitions, path parameters, redirects, and deep links easier to manage declaratively. Navigator is the underlying stack-based system: pushing adds a page and popping removes the current page. Weatherly calls `context.go` because its top-level destinations represent locations rather than temporary overlays.

## How do favorites persist?

The favorites controller loads cities through a `FavoritesStore`. The production store JSON-encodes them in SharedPreferences; tests use an in-memory store. Toggling a city updates Riverpod state and persists the new list. City identity comes from Open-Meteo's city ID.

## How are errors handled?

The repository catches Dio failures and translates timeout, connection, server, and unexpected failures into concise messages. Pages render an error state with a retry action. A failed request is never represented as an empty successful response.

## How are Flutter tests organized?

A unit test checks Dart logic without rendering UI—for example repository mapping, condition codes, or provider behavior. A widget test pumps widgets into Flutter's test binding, interacts with them, and checks visible states such as loading, results, errors, and empty favorites. Widget tests sit between unit and full device tests: they exercise rendering and interaction quickly without launching an emulator.

## Why no offline forecast?

Offline behavior needs a freshness policy, cache invalidation, and clear timestamps. This version persists only favorites and states the network dependency honestly. A future cache should expose when data was fetched and visibly distinguish stale results.

## How is the UI responsive?

Weatherly responds to available width, not a device label. Content stacks on narrow layouts, forecast panels share horizontal space when possible, and navigation changes from a bottom bar to a rail at 960px. A maximum content width prevents desktop layouts from becoming sparse.

## What is tested?

Tests cover repository mapping, WMO code conversion, Riverpod state, debounced search, favorite persistence, and important widget states. Network and storage are replaced with fakes, so tests remain fast and deterministic. A live-service test would be more realistic but could fail because of connectivity or an upstream change rather than an application regression.

## What would I improve next?

I would add a last-known forecast cache with explicit freshness, unit preferences, localization, and golden tests at representative breakpoints. Device location would remain opt-in and would need permission education plus a graceful denied state.

For a production release I would also add crash reporting with a documented privacy policy, end-to-end tests on real devices, API observability, accessibility testing with screen readers, release signing, and an explicit support policy for Flutter and platform versions.
