# flutter-starter

Flutter starter project dengan **Monorepo**, **Clean Architecture**, **Multi-Flavor**, dan **Multi-Environment** — siap di-fork sebagai fondasi project baru.

---

## Tech Stack

| Kategori | Library |
|---|---|
| Monorepo | [Melos](https://melos.invertase.dev/) |
| State Management | [Riverpod](https://riverpod.dev/) |
| Navigation | [GoRouter](https://pub.dev/packages/go_router) |
| HTTP Client | [Dio](https://pub.dev/packages/dio) |
| Local Storage | SharedPreferences + FlutterSecureStorage |
| Backend Services | Firebase |
| Localization | Flutter gen-l10n |

---

## Prerequisites

Pastikan tools berikut sudah terinstall:

- [Flutter SDK](https://docs.flutter.dev/get-started/install) — stable channel
- [Melos](https://melos.invertase.dev/getting-started) — `dart pub global activate melos`

---

## Getting Started

```bash
# 1. Clone repo
git clone https://github.com/ramadhanrosihadi/flutter-starter.git
cd flutter-starter

# 2. Install semua dependencies dari root
dart pub get

# 3. Jalankan app
melos run dev
```

---

## Menjalankan App

```bash
# apps/main
melos run dev                                         # dev (default)
flutter run --dart-define=ENV=staging                 # staging
flutter run --dart-define=ENV=prod                    # prod

# apps/variant
melos run dev:variant                                 # dev (default)
flutter run -t lib/main.dart --dart-define=ENV=staging   # staging
flutter run -t lib/main.dart --dart-define=ENV=prod      # prod

# Build
melos run build:android
melos run build:ios
```

---

## Struktur Project

Monorepo dengan dua layer utama:

```
packages/   → shared libraries (core, features_shared)
apps/       → Flutter apps (main, variant)
```

Lihat [ARCHITECTURE.md](ARCHITECTURE.md) untuk dokumentasi lengkap arsitektur, aturan dependency, dan panduan menambah fitur atau flavor baru.

---

## Cara Pakai Starter Ini

Setelah fork, lakukan langkah berikut sebelum mulai development:

- [ ] Rename package name di seluruh `pubspec.yaml` (ganti `app_main`, `app_variant`, dll)
- [ ] Update `applicationId` / bundle ID di `android/` dan `ios/` masing-masing app
- [ ] Ganti base URL di `MainConfig` dan `VariantConfig`
- [ ] Rename `variant` sesuai nama produk atau klien
- [ ] Tambahkan `google-services.json` (Android) dan `GoogleService-Info.plist` (iOS) dari Firebase Console
- [ ] Update nama app di `AndroidManifest.xml` dan `Info.plist`
