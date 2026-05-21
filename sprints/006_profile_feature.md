# Sprint 006 — Profile Feature

Tujuan: mengimplementasi fitur Profile yang saat ini masih stub di `packages/features_shared` — lengkap dengan domain, data, dan presentation layer — serta menampilkannya di kedua app. Sprint ini mendemonstrasikan full Clean Architecture pattern untuk fitur selain auth.

Acceptance criteria sprint: Profile screen tampil di kedua app, menampilkan data user yang sedang login (nama dan email), dengan tombol logout. Data profile dibaca dari sesi auth yang sudah ada — tidak perlu API call terpisah.

> **Desain keputusan:** Profile di sprint ini menggunakan data `User` dari sesi auth yang sudah ada (tidak memanggil `/profile` endpoint terpisah). Ini cukup untuk starter — pengembang yang butuh profile API terpisah bisa extend setelah starter ini menjadi project nyata.

---

## Arsitektur Profile Feature

```text
packages/features_shared/lib/src/profile/
├── domain/
│   ├── entities/profile.dart           ← entity Profile (wrap User)
│   ├── repositories/profile_repository.dart
│   └── usecases/
│       ├── get_profile_use_case.dart
│       └── update_profile_use_case.dart
├── data/
│   └── repositories/profile_repository_impl.dart  ← membaca dari AuthRepository
└── presentation/
    ├── profile_provider.dart
    └── profile_screen.dart             ← tampilkan nama, email, tombol logout

apps/main/lib/features/profile/        ← (opsional) jika UI main berbeda dari shared
apps/variant/lib/features/profile/     ← (opsional) jika UI variant berbeda
```

Untuk starter ini, `ProfileScreen` diletakkan di `features_shared` karena UI kedua app sama — hanya tampilkan nama, email, dan tombol logout.

---

## Phase 1 — Review & Complete Domain Layer

Stub sudah ada. Verifikasi isinya sudah benar, lalu lengkapi yang kosong.

- [ ] Review `packages/features_shared/lib/src/profile/domain/entities/profile.dart`:
  ```dart
  class Profile {
    const Profile({
      required this.id,
      required this.name,
      required this.email,
    });

    final String id;
    final String name;
    final String email;
  }
  ```
- [ ] Review `packages/features_shared/lib/src/profile/domain/repositories/profile_repository.dart`:
  ```dart
  abstract class ProfileRepository {
    Future<Profile?> getProfile();
    Future<void> updateProfile(Profile profile);
  }
  ```
- [ ] Review `packages/features_shared/lib/src/profile/domain/usecases/get_profile_use_case.dart`:
  ```dart
  class GetProfileUseCase {
    const GetProfileUseCase(this._repository);
    final ProfileRepository _repository;
    Future<Profile?> call() => _repository.getProfile();
  }
  ```
- [ ] `update_profile_use_case.dart` — scope Sprint 006 hanya read-only. Stub ini boleh dibiarkan tidak diimplementasi untuk sekarang (bertanda `TODO`).
- [ ] `dart analyze packages/features_shared` — no issues

**Selesai jika:** Domain layer clean, entity dan usecase sudah benar.

---

## Phase 2 — Implementasi Data Layer

`ProfileRepositoryImpl` membaca data dari `AuthRepository` (user yang sudah login) — tidak perlu API call baru.

- [ ] Update `packages/features_shared/lib/src/profile/data/repositories/profile_repository_impl.dart`:
  ```dart
  import '../../domain/entities/profile.dart';
  import '../../domain/repositories/profile_repository.dart';
  import '../../../auth/domain/repositories/auth_repository.dart';

  class ProfileRepositoryImpl implements ProfileRepository {
    const ProfileRepositoryImpl(this._authRepository);

    final AuthRepository _authRepository;

    @override
    Future<Profile?> getProfile() async {
      final user = await _authRepository.getCurrentUser();
      if (user == null) return null;
      return Profile(id: user.id, name: user.name, email: user.email);
    }

    @override
    Future<void> updateProfile(Profile profile) async {
      // TODO: implementasi update via API — scope Sprint 006 hanya read-only
    }
  }
  ```
- [ ] `dart analyze packages/features_shared` — no issues

**Selesai jika:** `ProfileRepositoryImpl` bisa dikompilasi tanpa error.

---

## Phase 3 — Implementasi Presentation Layer

- [ ] Update `packages/features_shared/lib/src/profile/presentation/profile_provider.dart`:
  ```dart
  import 'package:flutter_riverpod/flutter_riverpod.dart';

  import '../domain/entities/profile.dart';
  import '../domain/usecases/get_profile_use_case.dart';
  import '../data/repositories/profile_repository_impl.dart';
  import '../../auth/presentation/auth_repository_provider.dart';

  final profileRepositoryProvider = Provider((ref) =>
      ProfileRepositoryImpl(ref.watch(authRepositoryProvider)));

  final profileProvider = FutureProvider<Profile?>((ref) {
    final repo = ref.watch(profileRepositoryProvider);
    return GetProfileUseCase(repo)();
  });
  ```
- [ ] Update `packages/features_shared/lib/src/profile/presentation/profile_screen.dart`:
  ```dart
  import 'package:flutter/material.dart';
  import 'package:flutter_riverpod/flutter_riverpod.dart';

  import 'profile_provider.dart';
  import '../../auth/presentation/auth_provider.dart';

  class ProfileScreen extends ConsumerWidget {
    const ProfileScreen({super.key});

    @override
    Widget build(BuildContext context, WidgetRef ref) {
      final profileAsync = ref.watch(profileProvider);

      return Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: profileAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => const Center(child: Text('Failed to load profile')),
          data: (profile) => profile == null
              ? const Center(child: Text('Not logged in'))
              : ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    CircleAvatar(
                      radius: 40,
                      child: Text(
                        profile.name.isNotEmpty
                            ? profile.name[0].toUpperCase()
                            : '?',
                        style: const TextStyle(fontSize: 32),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ListTile(
                      leading: const Icon(Icons.person_outline),
                      title: const Text('Name'),
                      subtitle: Text(profile.name),
                    ),
                    ListTile(
                      leading: const Icon(Icons.email_outlined),
                      title: const Text('Email'),
                      subtitle: Text(profile.email),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.logout),
                      title: const Text('Logout'),
                      onTap: () => ref
                          .read(authNotifierProvider.notifier)
                          .logout(),
                    ),
                  ],
                ),
        ),
      );
    }
  }
  ```
- [ ] `dart analyze packages/features_shared` — no issues

**Selesai jika:** `ProfileScreen` bisa dirender dan menampilkan data dari `profileProvider`.

---

## Phase 4 — Export & Route

- [ ] Verifikasi exports di `packages/features_shared/lib/features_shared.dart` — semua file profile sudah diexport:
  ```dart
  // profile — domain
  export 'src/profile/domain/entities/profile.dart';
  export 'src/profile/domain/repositories/profile_repository.dart';
  export 'src/profile/domain/usecases/get_profile_use_case.dart';

  // profile — data
  export 'src/profile/data/repositories/profile_repository_impl.dart';

  // profile — presentation
  export 'src/profile/presentation/profile_provider.dart';
  export 'src/profile/presentation/profile_screen.dart';
  ```
- [ ] Tambah `AppRoutes.profile = '/profile'` ke `packages/core/lib/src/router/app_routes.dart` (jika belum ada)
- [ ] Buat `apps/main/lib/features/profile/presentation/profile_route.dart`:
  ```dart
  import 'package:go_router/go_router.dart';
  import 'package:core/core.dart';
  import 'package:features_shared/features_shared.dart';

  final profileRoute = GoRoute(
    path: AppRoutes.profile,
    builder: (context, state) => const ProfileScreen(),
  );
  ```
- [ ] Daftarkan `profileRoute` di `apps/main/lib/router/app_router.dart`
- [ ] Lakukan hal yang sama untuk `apps/variant`
- [ ] Tambah tombol/navigasi ke profile dari `HomeScreen` kedua app (misal via `AppBar` action icon `Icons.person`)
- [ ] `dart analyze packages/core packages/features_shared apps/main apps/variant` — no issues

**Selesai jika:** Profile screen bisa dibuka dari home, data user tampil.

---

## Phase 5 — L10n Profile (jika Sprint 003 sudah selesai)

Jika Sprint 003 sudah diimplementasi, tambah keys L10n untuk profile:

- [ ] Tambah ke kedua ARB:
  ```json
  "profile": "Profil",
  "name": "Nama",
  "logoutConfirm": "Yakin ingin keluar?"
  ```
- [ ] Ganti teks hardcode di `profile_screen.dart` dengan `l10n.*`
- [ ] Generate ulang: `cd packages/core && flutter gen-l10n`

---

## Phase 6 — Verifikasi

- [ ] `dart analyze packages/core packages/features_shared apps/main apps/variant` — no issues
- [ ] `flutter test` — semua pass
- [ ] Verifikasi di device:
  - Login → buka Profile → nama dan email tampil ✓
  - Tap Logout → redirect ke login screen ✓
  - Login ulang → Profile kembali menampilkan data ✓

**Selesai jika:** Profile screen fungsional di kedua app, logout bekerja dari profile screen.
