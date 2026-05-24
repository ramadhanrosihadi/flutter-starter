# Audit Praktek Terbaik Flutter & Riverpod

Dokumen ini menganalisis kualitas kode dan kesesuaian proyek dengan praktik terbaik (*best practices*) pengembangan Flutter dan Riverpod modern. Analisis difokuskan pada 5 bidang prioritas arsitektur: Riverpod, Offline Support, Push Notification, Flavor & Build Config, serta Manajemen Autentikasi.

---

## A. Arsitektur Riverpod & Struktur Folder (Prioritas Tinggi)

- **[❌ Masalah] Ketiadaan Code Generation (`@riverpod`)**:
  Meskipun dokumentasi menyarankan penggunaan `@riverpod`, kenyataannya seluruh proyek murni menggunakan Riverpod vanilla klasik. Provider dideklarasikan sebagai variabel global statis, seperti:
  ```dart
  final themeNotifierProvider =
      AsyncNotifierProvider<ThemeNotifier, ThemeMode>(ThemeNotifier.new);
  ```
  **Dampak**: Developer kehilangan fitur-fitur modern Riverpod generator seperti pembuangan otomatis (*autoDispose* yang diaktifkan secara default), pengecekan tipe statis parameter (*family* type-safety), dan struktur kode yang lebih ringkas.

- **[✅ Baik] Pemisahan Layer & Single Responsibility**:
  Setiap *notifier* memiliki tanggung jawab tunggal (*Single Responsibility*) yang fokus. Contohnya, `AuthNotifier` hanya mengurusi status autentikasi pengguna dan memanggil kelas *usecase* yang sesuai (seperti `LoginUseCase`), alih-alih mengeksekusi panggilan API atau logika bisnis secara langsung di dalam kelas presentasi.

- **[✅ Baik] Penerapan `ref.watch` vs `ref.read`**:
  Akses provider diatur dengan benar: `ref.watch` digunakan untuk merekonstruksi UI berdasarkan perubahan status di dalam method `build`, sedangkan `ref.read` dipanggil hanya untuk trigger aksi di dalam fungsi pemicu aktivitas (seperti fungsi klik tombol).

---

## B. Offline Support & Local Storage (Prioritas Tinggi)

- **[❌ Masalah] Tidak Ada Database Lokal Terstruktur**:
  Aplikasi hanya menggunakan SharedPreferences (melalui `SharedPreferencesStorage`) untuk preference non-sensitif dan Flutter Secure Storage (melalui `SecureStorageService`) untuk data kredensial.
  **Dampak**: Tidak ada database lokal seperti **Isar**, **Hive**, atau **Drift** untuk memuat data luring secara terstruktur (*offline caching*). Jika aplikasi ini dikembangkan untuk SaaS multi-tenant dengan ratusan data entitas bisnis, penyimpanan berbasis string JSON di `SharedPreferences` akan sangat lambat dan berisiko tinggi terjadi kerusakan data.

- **[❌ Masalah] Ketiadaan Mekanisme Eviction & Sinkronisasi**:
  Tidak ditemukan adanya mekanisme pembersihan cache lama (*cache eviction*) maupun sinkronisasi otomatis ketika koneksi internet kembali pulih (*online sync retry*).

---

## C. Push Notification (Prioritas Tinggi)

- **[❌ Masalah] Fitur Notifikasi FCM Adalah Stub Kosong**:
  Implementasi notifikasi murni kosong di tingkat repositori:
  ```dart
  class NotificationsRepositoryImpl implements NotificationsRepository {
    @override
    Future<List<AppNotification>> getNotifications() {
      throw UnimplementedError('NotificationsRepositoryImpl.getNotifications not yet implemented');
    }
  }
  ```
  Tidak ada inisialisasi Firebase Cloud Messaging (FCM), penanganan *lifecycle* aplikasi (foreground/background/terminated), registrasi token perangkat ke backend, maupun pengenalan rute notifikasi (*deep link*).

---

## D. Flavors & Build Configuration (Prioritas Tinggi)

- **[✅ Baik] Monorepo Multi-App yang Fleksibel**:
  Struktur flavor diatur secara elegan melalui dua aplikasi Flutter yang berdiri sendiri: `apps/main` dan `apps/variant`. Ini adalah arsitektur multi-tenant yang sangat kuat, di mana masing-masing aplikasi memiliki dependensi Gradle dan properti platform Android/iOS tersendiri secara modular, bukan hanya menggunakan konfigurasi flavor bawaan satu aplikasi.

- **[✅ Baik] Konfigurasi Peluncuran VS Code**:
  Berkas `.vscode/launch.json` terkonfigurasi dengan sangat profesional. Ini menyediakan menu peluncuran instan untuk masing-masing flavor di tiga lingkungan (`dev`, `staging`, `prod`) menggunakan argument `--dart-define=ENV=...`.

- **[❌ Masalah] Ketiadaan Konfigurasi Rilis Kunci signing**:
  Proyek hanya menyertakan berkas `key.properties.example` namun belum mengotomatiskan build signing di tingkat *build.gradle.kts*, yang berarti proses perilisan APK/IPA masih membutuhkan banyak konfigurasi manual yang belum terintegrasi di skrip Melos.

---

## E. Autentikasi & Manajemen Token

- **[✅ Baik] Interceptor Pengisian Token Otomatis**:
  Dio Client di `core` dilengkapi dengan `AuthInterceptor` yang membaca token auth secara otomatis dari `SecureStorageService` pada setiap kali *request* dibuat:
  ```dart
  final token = await _storage.read(AppConstants.keyAuthToken);
  if (token != null) {
    options.headers['Authorization'] = 'Bearer $token';
  }
  ```

- **[❌ Masalah] Ketiadaan Refresh Token Otomatis (401 Handler)**:
  `DioClient` menangkap status 401 dan memetakan sebagai `UnauthorizedException`, namun **tidak memiliki alur untuk auto-refresh token** menggunakan *refresh token* dari backend. Sesi pengguna akan langsung terputus dan memaksa *logout* tanpa adanya upaya pembaruan token di latar belakang.

---

## F. Kualitas Kode & Penanganan Error

- **[⚠️ Perlu Perhatian] Penulisan Model DTO Manual**:
  Model data seperti `UserModel` di `features_shared/lib/src/auth/data/models/user_model.dart` ditulis secara manual termasuk fungsi `fromJson` dan `toJson`.
  **Dampak**: Menulis model secara manual di era Flutter modern adalah hutang teknis (*technical debt*). Sangat direkomendasikan menggunakan **Freezed** atau **Json Serializable** untuk menghindari *human error* penulisan nama kunci JSON.

---

## Kesimpulan & Skor Best Practice

> [!IMPORTANT]
> **Skor Rata-Rata Best Practice: 6.0 / 10**
> 
> - **Riverpod Architecture**: 6.5/10 (Layer terpisah rapi, tapi tanpa code generation)
> - **Offline Support**: 4.0/10 (Hanya key-value biasa, tidak ada database lokal)
> - **Push Notification**: 1.0/10 (Masih berupa stub kosong total)
> - **Flavors & Build**: 8.5/10 (Sangat baik, monorepo terpisah secara elegan)
> - **Auth & Networking**: 7.0/10 (Dio terintegrasi baik dengan interceptor, tanpa auto-refresh token)
> - **OVERALL SKOR**: **6.0 / 10** (⚠️ Cukup)

---

## Contoh Dart Konkret: Mengatasi Compile Error `RadioGroup`

Untuk mengatasi compile error fatal di `apps/main` tanpa melanggar prinsip desain, berikut contoh berkas widget custom `RadioGroup` yang dapat ditambahkan di `packages/core/lib/src/widgets/radio_group.dart` agar aplikasi dapat dibangun kembali:

```dart
// packages/core/lib/src/widgets/radio_group.dart
import 'package:flutter/material.dart';

class RadioGroup<T> extends InheritedWidget {
  const RadioGroup({
    super.key,
    required this.groupValue,
    required this.onChanged,
    required super.child,
  });

  final T groupValue;
  final ValueChanged<T?> onChanged;

  static RadioGroup<T>? maybeOf<T>(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<RadioGroup<T>>();
  }

  static RadioGroup<T> of<T>(BuildContext context) {
    final RadioGroup<T>? result = maybeOf<T>(context);
    assert(result != null, 'No RadioGroup<$T> found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(RadioGroup<T> oldWidget) {
    return oldWidget.groupValue != groupValue || oldWidget.onChanged != onChanged;
  }
}
```

*Catatan: Widget ini harus diekspor di `packages/core/lib/core.dart` agar dapat digunakan secara global.*
