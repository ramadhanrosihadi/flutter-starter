# Sprint 007 — Release Preparation

Tujuan: mengubah starter dari template boilerplate menjadi project siap publish — identitas app diganti, icon dan splash screen terpasang, signing config Android dikonfigurasi, dan README mendeskripsikan project nyata bukan starter generic.

Acceptance criteria sprint: `flutter build apk --release` dan `flutter build ipa` sukses dengan app identity yang benar, icon dan splash tampil, nama app sesuai project.

> **Catatan:** Sprint ini dieksekusi **per project**, bukan sekali di starter. Setiap kali starter di-fork untuk project baru, sprint ini dijalankan ulang dengan nilai yang sesuai project tersebut.

---

## Phase 1 — Ganti Identitas App

### Android

- [ ] Update `apps/main/android/app/build.gradle.kts`:
  ```kotlin
  namespace = "com.company.appname"    // ganti dengan namespace project
  applicationId = "com.company.appname"
  ```
- [ ] Update `apps/variant/android/app/build.gradle.kts` (jika variant dipakai):
  ```kotlin
  namespace = "com.company.appname.variant"
  applicationId = "com.company.appname.variant"
  ```
- [ ] Update nama app di `apps/main/android/app/src/main/AndroidManifest.xml`:
  ```xml
  android:label="NamaApp"
  ```
- [ ] Sama untuk variant

### iOS

- [ ] Update bundle identifier di `apps/main/ios/Runner.xcodeproj/project.pbxproj`:
  ```
  PRODUCT_BUNDLE_IDENTIFIER = com.company.appname;
  ```
  > Cari semua kemunculan `PRODUCT_BUNDLE_IDENTIFIER` — ada di Debug, Release, dan Profile configuration.
- [ ] Update nama app di `apps/main/ios/Runner/Info.plist`:
  ```xml
  <key>CFBundleName</key>
  <string>NamaApp</string>
  ```
- [ ] Sama untuk variant

### Web

- [ ] Update `apps/main/web/index.html` — ganti `<title>` dan meta description
- [ ] Update `apps/main/web/manifest.json` — ganti `name` dan `short_name`
- [ ] Sama untuk variant

### Dart / pubspec

- [ ] Update `name` dan `description` di:
  - `pubspec.yaml` root (workspace name)
  - `apps/main/pubspec.yaml`
  - `apps/variant/pubspec.yaml`
  - `packages/core/pubspec.yaml`
  - `packages/features_shared/pubspec.yaml`
- [ ] Update `version` ke `1.0.0+1` atau sesuai kebutuhan project

**Selesai jika:** `flutter run` menampilkan nama app yang benar di device.

---

## Phase 2 — App Icon

Gunakan `flutter_launcher_icons` untuk generate icon dari satu sumber gambar.

> **Catatan versi dependency:**
> Verifikasi versi terbaru di [pub.dev](https://pub.dev) sebelum eksekusi.
>
> | Package | Versi saat dokumen ditulis |
> |---|---|
> | `flutter_launcher_icons` | `^0.14.3` |

- [ ] Siapkan file icon `1024x1024` PNG tanpa transparansi (untuk Android dan iOS)
- [ ] Tambah `flutter_launcher_icons` ke dev_dependencies `apps/main/pubspec.yaml` dan `apps/variant/pubspec.yaml`:
  ```yaml
  dev_dependencies:
    flutter_launcher_icons: ^0.14.3
  ```
- [ ] Tambah konfigurasi icon di `apps/main/pubspec.yaml`:
  ```yaml
  flutter_launcher_icons:
    android: true
    ios: true
    image_path: "assets/icon/icon.png"
    web:
      generate: true
      image_path: "assets/icon/icon.png"
  ```
- [ ] Taruh file icon di `apps/main/assets/icon/icon.png`
- [ ] Generate:
  ```bash
  cd apps/main
  dart run flutter_launcher_icons
  ```
- [ ] Lakukan hal yang sama untuk `apps/variant` (icon bisa berbeda)
- [ ] Jalankan app → verifikasi icon tampil di launcher

**Selesai jika:** Icon app muncul di launcher Android dan iOS sesuai desain.

---

## Phase 3 — Splash Screen

Gunakan `flutter_native_splash` untuk splash screen native.

> **Catatan versi dependency:**
> Verifikasi versi terbaru di [pub.dev](https://pub.dev) sebelum eksekusi.
>
> | Package | Versi saat dokumen ditulis |
> |---|---|
> | `flutter_native_splash` | `^2.4.6` |

- [ ] Tambah `flutter_native_splash` ke dev_dependencies kedua app
- [ ] Tambah konfigurasi ke `apps/main/pubspec.yaml`:
  ```yaml
  flutter_native_splash:
    color: "#FFFFFF"              # background color splash
    image: assets/splash/logo.png # logo di tengah (opsional)
    android_12:
      color: "#FFFFFF"
      image: assets/splash/logo.png
    ios: true
    web: false
  ```
- [ ] Taruh file logo di `apps/main/assets/splash/logo.png`
- [ ] Generate:
  ```bash
  cd apps/main
  dart run flutter_native_splash:create
  ```
- [ ] Lakukan hal yang sama untuk variant
- [ ] Jalankan app → verifikasi splash tampil saat launch

**Selesai jika:** Splash screen tampil dengan warna dan logo yang benar.

---

## Phase 4 — Android Signing Config (Release)

Tanpa signing config, `flutter build apk --release` akan gagal untuk publish ke Play Store.

- [ ] Buat keystore (simpan di luar repo — jangan commit!):
  ```bash
  keytool -genkey -v \
    -keystore ~/keys/appname-release.jks \
    -alias appname \
    -keyalg RSA \
    -keysize 2048 \
    -validity 10000
  ```
- [ ] Buat file `apps/main/android/key.properties` (tambahkan ke `.gitignore`!):
  ```properties
  storePassword=<password>
  keyPassword=<password>
  keyAlias=appname
  storeFile=<path-ke-keystore>
  ```
- [ ] Update `apps/main/android/app/build.gradle.kts` — tambah signing config:
  ```kotlin
  import java.util.Properties

  val keyProps = Properties().apply {
      rootProject.file("key.properties").takeIf { it.exists() }?.inputStream()?.use { load(it) }
  }

  android {
      signingConfigs {
          create("release") {
              keyAlias = keyProps["keyAlias"] as String? ?: ""
              keyPassword = keyProps["keyPassword"] as String? ?: ""
              storeFile = keyProps["storeFile"]?.let { file(it as String) }
              storePassword = keyProps["storePassword"] as String? ?: ""
          }
      }
      buildTypes {
          release {
              signingConfig = signingConfigs.getByName("release")
          }
      }
  }
  ```
- [ ] Pastikan `key.properties` dan `*.jks` ada di `.gitignore`
- [ ] `flutter build apk --release --dart-define=ENV=prod` — sukses
- [ ] Sama untuk variant

**Selesai jika:** APK release bisa dibangun dan di-sign tanpa error.

---

## Phase 5 — Update Base URL

- [ ] Update `apps/main/lib/config/main_config.dart` — ganti placeholder URL dengan URL API project:
  ```dart
  String get baseUrl => switch (environment) {
    Environment.dev => 'https://api-dev.myproject.com',
    Environment.staging => 'https://api-staging.myproject.com',
    Environment.prod => 'https://api.myproject.com',
  };
  ```
- [ ] Sama untuk `apps/variant/lib/config/variant_config.dart`
- [ ] Hapus atau sesuaikan `FakeAuthRepository` di `apps/main/lib/dev/` — putuskan apakah tetap dipakai untuk development atau dihapus

**Selesai jika:** App terhubung ke URL API yang benar per environment.

---

## Phase 6 — Update Dokumentasi

- [ ] Update `README.md` root — ganti deskripsi starter dengan deskripsi project nyata:
  - Nama project
  - Apa yang dilakukan app
  - Tech stack
  - Cara setup dan run
  - Link ke docs/
- [ ] Update `CONTRIBUTING.md` — sesuaikan dengan workflow tim
- [ ] Hapus atau update `sprints/` — sprint starter tidak relevan untuk project baru:
  - Bisa dihapus semua
  - Atau pindahkan ke folder arsip
- [ ] `dart analyze packages/core packages/features_shared apps/main apps/variant` — no issues
- [ ] `flutter test` — semua pass

**Selesai jika:** README mendeskripsikan project nyata, tidak ada sisa boilerplate starter.
