# Sprint 001 — Project Setup

Tujuan: membangun fondasi flutter-starter sesuai ARCHITECTURE.md — dari monorepo root hingga kedua flavor app siap dijalankan.

---

## Phase 1 — Monorepo Root

- [ ] Buat root `pubspec.yaml` — workspace config, daftarkan semua member package
- [ ] Buat `melos.yaml` — definisi scripts: `dev`, `dev:variant`, `build:android`, `build:ios`, `test`

---

## Phase 2 — `packages/core/`

- [ ] Setup package — struktur folder, `pubspec.yaml`, `lib/core.dart` barrel export
- [ ] `errors/` — `Exception` classes (data layer) + `Failure` classes (domain layer)
- [ ] `config/` — `AppConfig` abstract class + `Environment` enum
- [ ] `constants/` — global constants
- [ ] `storage/` — wrapper SharedPreferences & SecureStorage
- [ ] `network/` — Dio client: base URL, interceptor, error handler
- [ ] `theme/` — `ThemeData` light & dark
- [ ] `responsive/` — `Breakpoints` + `ResponsiveLayout` widget
- [ ] `extensions/` — Dart extension methods
- [ ] `utils/` — helper functions
- [ ] `widgets/` — `AppButton`, `AppTextField`, `LoadingOverlay`
- [ ] `router/` — `AppRoutes` constants + `AuthGuard` + `NavigatorObserver`
- [ ] `l10n/` — `.arb` files + konfigurasi `gen-l10n`

---

## Phase 3 — `packages/features_shared/`

- [ ] Setup package — struktur folder, `pubspec.yaml`, `lib/features_shared.dart` barrel export
- [ ] `auth/domain/` — entity, repository interface, usecases
- [ ] `auth/data/` — datasource, model, repository impl
- [ ] `auth/presentation/` — provider, screen, widget, route
- [ ] `profile/domain/` — entity, repository interface, usecases
- [ ] `profile/data/` — datasource, model, repository impl
- [ ] `profile/presentation/` — provider, screen, widget, route
- [ ] `notifications/domain/` — entity, repository interface, usecases
- [ ] `notifications/data/` — datasource, model, repository impl
- [ ] `notifications/presentation/` — provider, screen, widget, route

---

## Phase 4 — `apps/main/`

- [ ] Buat Flutter project + integrasi ke workspace (`resolution: workspace`)
- [ ] `config/` — `MainConfig` extends `AppConfig`, membaca `--dart-define=ENV`
- [ ] `bootstrap.dart` — async init: `WidgetsFlutterBinding`, Firebase, error handler
- [ ] `app.dart` — `ProviderScope`, `MaterialApp.router` — menerapkan tema dan router
- [ ] `router/app_router.dart` — `GoRouter` instance, gabungkan shared routes + routes eksklusif main
- [ ] `main.dart` — inject `AppConfig.instance`, panggil `bootstrap()`

---

## Phase 5 — `apps/variant/`

- [ ] Buat Flutter project + integrasi ke workspace (`resolution: workspace`)
- [ ] `config/` — `VariantConfig` extends `AppConfig`, membaca `--dart-define=ENV`
- [ ] `bootstrap.dart` — async init: `WidgetsFlutterBinding`, Firebase, error handler
- [ ] `app.dart` — `ProviderScope`, `MaterialApp.router` — menerapkan tema dan router
- [ ] `router/app_router.dart` — `GoRouter` instance, gabungkan shared routes + routes eksklusif variant
- [ ] `main.dart` — inject `AppConfig.instance`, panggil `bootstrap()`
