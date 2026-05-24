# Deep Dive Area Prioritas

Dokumen ini menyajikan analisis mendalam (*deep dive*) terhadap 4 area prioritas utama arsitektur proyek, lengkap dengan kutipan kode aktual, kesenjangan terhadap dokumentasi, identifikasi masalah spesifik beserta referensi file dan baris, contoh kode perbaikan konkret, serta estimasi usaha (*effort*) yang dibutuhkan.

---

## 📌 Area 1: Riverpod Architecture & Code Generation

### 1. Kode Aktual yang Ditemukan
Di `packages/features_shared/lib/src/auth/presentation/auth_notifier.dart` (baris 74-75):
```dart
final authNotifierProvider =
    NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);
```

### 2. Perbandingan dengan Dokumentasi
Dokumen arsitektur menyebutkan bahwa proyek ini menggunakan **Riverpod versi terbaru dengan code generation (`@riverpod`)**. 

### 3. Masalah Spesifik
- **File**: `packages/features_shared/lib/src/auth/presentation/auth_notifier.dart` (dan seluruh berkas provider di `features_shared` dan `apps`).
- **Masalah**: Pendefinisian provider secara manual (vanilla) menambah *boilerplate*, mempersulit penulisan rute dinamis (*family*), dan mengeliminasi fitur pembuangan memori otomatis (*autoDispose*) yang diaktifkan secara default oleh generator. Paket generator (`riverpod_generator`) bahkan belum terpasang di `pubspec.yaml`.

### 4. Kode Perbaikan Konkret
Pertama, tambahkan dependensi generator di `pubspec.yaml`:
```yaml
dependencies:
  riverpod_annotation: ^2.3.5

dev_dependencies:
  riverpod_generator: ^2.4.3
  build_runner: ^2.4.13
```

Kemudian, refaktor `auth_notifier.dart` menggunakan anotasi generator:
```dart
// packages/features_shared/lib/src/auth/presentation/auth_notifier.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/usecases/get_current_user_use_case.dart';
import '../domain/usecases/login_use_case.dart';
import '../domain/usecases/logout_use_case.dart';
import '../domain/usecases/register_use_case.dart';
import 'auth_repository_provider.dart';
import 'auth_state.dart';

part 'auth_notifier.g.dart';

@riverpod
class AuthNotifier extends _$AuthNotifier {
  late GetCurrentUserUseCase _getCurrentUser;
  late LoginUseCase _login;
  late LogoutUseCase _logout;
  late RegisterUseCase _register;

  @override
  AuthState build() {
    final repo = ref.watch(authRepositoryProvider);
    _getCurrentUser = GetCurrentUserUseCase(repo);
    _login = LoginUseCase(repo);
    _logout = LogoutUseCase(repo);
    _register = RegisterUseCase(repo);
    return const AuthInitial();
  }

  // (metode checkCurrentUser, login, register, logout tetap sama)
}
```

### 5. Estimasi Effort Perbaikan
- **Skala**: `M (1-3 hari)`
- **Justifikasi**: Membutuhkan penambahan paket dev-dependencies di semua proyek, penyesuaian penulisan provider, serta eksekusi `build_runner` untuk men-generate berkas pendukung `.g.dart`.

---

## 📌 Area 2: Offline Support & Local Storage

### 1. Kode Aktual yang Ditemukan
Di `packages/core/lib/src/storage/shared_preferences_storage.dart` (baris 4-10):
```dart
class SharedPreferencesStorage implements StorageService {
  late SharedPreferences _prefs;

  @override
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }
  // ...
}
```

### 2. Perbandingan dengan Dokumentasi
Proyek diklaim mendukung **Offline Support & Local Storage (Prioritas Tinggi)** sebagai standar kesiapan aplikasi SaaS.

### 3. Masalah Spesifik
- **File**: Seluruh folder `packages/core/lib/src/storage/`.
- **Masalah**: Tidak ada penyimpanan basis data relasional/dokumen terstruktur (seperti Isar atau Hive). Penggunaan `SharedPreferences` murni bertipe *key-value string* yang lambat dan berbahaya jika dipaksakan untuk mencache respons JSON REST API berukuran besar dalam arsitektur SaaS multi-tenant.

### 4. Kode Perbaikan Konkret
Tambahkan dependensi **Isar Database** di `packages/core/pubspec.yaml` dan buat skema data offline:
```dart
// packages/core/lib/src/storage/isar_database_service.dart
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

// Contoh skema entity bersama untuk cache offline
@collection
class CacheEntry {
  Id id = Isar.autoIncrement;
  
  @Index(unique: true)
  late String key;
  
  late String jsonPayload;
  late DateTime createdAt;
}

class IsarDatabaseService {
  late final Isar _isar;

  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [CacheEntrySchema],
      directory: dir.path,
    );
  }

  Future<void> writeCache(String key, String jsonPayload) async {
    final entry = CacheEntry()
      ..key = key
      ..jsonPayload = jsonPayload
      ..createdAt = DateTime.now();
      
    await _isar.writeTxn(() async {
      await _isar.cacheEntrys.putByKey(entry); // custom query or overwrite
    });
  }

  Future<String?> readCache(String key) async {
    final entry = await _isar.cacheEntrys.filter().keyEqualTo(key).findFirst();
    return entry?.jsonPayload;
  }
}
```

### 5. Estimasi Effort Perbaikan
- **Skala**: `L (3-7 hari)`
- **Justifikasi**: Membutuhkan perancangan arsitektur sinkronisasi jaringan (caching policies), penanganan *eviction policy* (menghapus entri cache kedaluwarsa), dan pembuatan skema koleksi Isar yang efisien.

---

## 📌 Area 3: Push Notification

### 1. Kode Aktual yang Ditemukan
Di `packages/features_shared/lib/src/notifications/data/repositories/notifications_repository_impl.dart` (baris 8-12):
```dart
  @override
  Future<List<AppNotification>> getNotifications() {
    throw UnimplementedError(
      'NotificationsRepositoryImpl.getNotifications not yet implemented',
    );
  }
```

### 2. Perbandingan dengan Dokumentasi
Proyek diarsitekturkan memiliki penanganan **Push Notification (FCM)** terintegrasi bawaan.

### 3. Masalah Spesifik
- **File**: `packages/features_shared/lib/src/notifications/`
- **Masalah**: Fitur notifikasi murni kosong total (*stub UnimplementedError*). Tidak ada dependensi Firebase Messaging, izin iOS/Android, interaksi token, maupun navigasi *deep link*.

### 4. Kode Perbaikan Konkret
Membuat kelas pengelola notifikasi `FCMNotificationService` di tingkat core/shared:
```dart
// packages/core/lib/src/services/fcm_notification_service.dart
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class FCMNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<void> init() async {
    // 1. Request Permission (iOS & Android 13+)
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted notification permission');
      
      // 2. Dapatkan token FCM untuk dikirim ke backend
      String? token = await _fcm.getToken();
      debugPrint('FCM Token: $token');
      
      // 3. Konfigurasi listeners
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        debugPrint('Received foreground message: ${message.notification?.title}');
        // Tampilkan local notification
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        debugPrint('Notification clicked: ${message.data}');
        // Parsing data untuk navigasi deep link
      });
    }
  }
}
```

### 5. Estimasi Effort Perbaikan
- **Skala**: `L (3-7 hari)`
- **Justifikasi**: Memerlukan konfigurasi konsol Google Firebase, pembuatan berkas identitas Apple Developer APNs, penyusunan *payload push notification* di backend, serta penanganan 3 *state* siklus hidup aplikasi (*foreground*, *background*, *terminated*).

---

## 📌 Area 4: Compile Error `RadioGroup` di Main App Settings

### 1. Kode Aktual yang Ditemukan
Di `apps/main/lib/features/settings/presentation/settings_screen.dart` (baris 70-87):
```dart
  class _ThemeTile extends StatelessWidget {
    const _ThemeTile({required this.current, required this.onChanged});
    final ThemeMode current;
    final void Function(ThemeMode) onChanged;

    @override
    Widget build(BuildContext context) {
      final l10n = AppLocalizations.of(context)!;
      return RadioGroup<ThemeMode>(
        groupValue: current,
        onChanged: (val) { if (val != null) onChanged(val); },
        child: Column(
          children: ThemeMode.values
              .map((mode) => RadioListTile<ThemeMode>(
                    title: Text(switch (mode) {
                      ThemeMode.system => l10n.themeSystem,
                      ThemeMode.light => l10n.themeLight,
                      ThemeMode.dark => l10n.themeDark,
                    }),
                    value: mode,
                  ))
              .toList(),
        ),
      );
    }
  }
```

### 2. Perbandingan dengan Dokumentasi
Pengguna dijanjikan antarmuka settings yang dapat dikompilasi secara sukses dengan switch tema yang bekerja persisten.

### 3. Masalah Spesifik
- **File**: `apps/main/lib/features/settings/presentation/settings_screen.dart` (baris 71, 98).
- **Masalah**: Kegagalan kompilasi total proyek main app karena widget `RadioGroup` **tidak terdefinisi** (tidak ada di repositori maupun SDK Flutter).

### 4. Kode Perbaikan Konkret (Refaktor UI Bebas Bug)
Menghapus ketergantungan widget `RadioGroup` yang tidak eksis, dan menulis ulang pengelompokan radio menggunakan properti `groupValue` bawaan `RadioListTile` standar Flutter secara langsung:

```dart
// apps/main/lib/features/settings/presentation/settings_screen.dart
class _ThemeTile extends StatelessWidget {
  const _ThemeTile({required this.current, required this.onChanged});
  final ThemeMode current;
  final void Function(ThemeMode) onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: ThemeMode.values
          .map((mode) => RadioListTile<ThemeMode>(
                title: Text(switch (mode) {
                  ThemeMode.system => l10n.themeSystem,
                  ThemeMode.light => l10n.themeLight,
                  ThemeMode.dark => l10n.themeDark,
                }),
                value: mode,
                groupValue: current, // Gunakan groupValue di tingkat tile secara langsung
                onChanged: (val) {
                  if (val != null) onChanged(val);
                },
              ))
          .toList(),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile({required this.current, required this.onChanged});
  final Locale current;
  final void Function(Locale) onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        RadioListTile<String>(
          title: Text(l10n.langIndonesia),
          value: 'id',
          groupValue: current.languageCode, // Gunakan groupValue langsung
          onChanged: (val) {
            if (val != null) onChanged(Locale(val));
          },
        ),
        RadioListTile<String>(
          title: Text(l10n.langEnglish),
          value: 'en',
          groupValue: current.languageCode, // Gunakan groupValue langsung
          onChanged: (val) {
            if (val != null) onChanged(Locale(val));
          },
        ),
      ],
    );
  }
}
```

### 5. Estimasi Effort Perbaikan
- **Skala**: `S (< 1 hari / beberapa menit saja)`
- **Justifikasi**: Sangat mudah diperbaiki dengan menghapus *wrapper* `RadioGroup` dan merestorasi penulisan `RadioListTile` standar Flutter.
