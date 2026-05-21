# Sprint 005 — CI/CD Verification

Tujuan: memastikan pipeline GitHub Actions di `.github/workflows/ci.yml` benar-benar pass — semua Melos script yang dipanggil CI terdefinisi dan berjalan tanpa error di lingkungan clean Ubuntu.

Acceptance criteria sprint: push ke branch `develop` → CI green semua step tanpa modifikasi manual.

---

## State Saat Ini

CI sudah ada di `.github/workflows/ci.yml` dengan step:
1. `dart pub get`
2. `dart run melos list`
3. `dart run melos run format:check`
4. `dart run melos run analyze`
5. `dart run melos run test`

Yang belum diverifikasi: apakah semua script ini terdefinisi di `pubspec.yaml` root dan berjalan clean di environment CI.

---

## Phase 1 — Audit Melos Scripts

- [ ] Baca `pubspec.yaml` root — verifikasi semua script yang dipanggil CI sudah ada:
  - `format:check` — ada?
  - `analyze` — ada?
  - `test` — ada?
- [ ] Jika ada script yang hilang, tambahkan ke `melos.scripts` di `pubspec.yaml`:
  ```yaml
  melos:
    scripts:
      format:check:
        run: dart format --set-exit-if-changed .
        description: Cek formatting tanpa mengubah file
      format:
        run: dart format .
        description: Format semua file Dart
      analyze:
        exec: flutter analyze
        description: Analyze semua package dan app
      test:
        exec: flutter test
        concurrency: 4
        description: Jalankan semua test
      dev:
        run: cd apps/main && flutter run --dart-define=ENV=dev
      "dev:variant":
        run: cd apps/variant && flutter run --dart-define=ENV=dev
      build:android:
        run: cd apps/main && flutter build apk --dart-define=ENV=prod
      build:ios:
        run: cd apps/main && flutter build ipa --dart-define=ENV=prod
  ```
- [ ] Jalankan lokal dari root — verifikasi setiap script:
  ```bash
  dart run melos list
  dart run melos run format:check
  dart run melos run analyze
  dart run melos run test
  ```
- [ ] Semua lolos tanpa error

**Selesai jika:** Semua script CI terdefinisi dan lolos lokal.

---

## Phase 2 — Verifikasi Format

CI akan gagal jika ada file yang tidak ter-format. Format dulu sebelum push:

- [ ] Jalankan format dari root:
  ```bash
  dart format .
  ```
- [ ] Cek hasilnya — file apa saja yang berubah (jika ada)
- [ ] Commit perubahan format jika ada
- [ ] Jalankan `dart run melos run format:check` → harus exit 0

**Selesai jika:** `format:check` lolos tanpa perubahan.

---

## Phase 3 — Push dan Verifikasi CI

- [ ] Commit semua perubahan sprint sebelumnya yang belum di-push
- [ ] Push ke branch `develop` (atau buat branch `develop` jika belum ada):
  ```bash
  git checkout -b develop
  git push -u origin develop
  ```
- [ ] Buka GitHub → tab Actions → tunggu CI selesai
- [ ] Verifikasi semua step hijau:
  - ✓ Checkout
  - ✓ Setup Flutter
  - ✓ Flutter version
  - ✓ Install dependencies
  - ✓ List workspace packages
  - ✓ Check formatting
  - ✓ Analyze
  - ✓ Test

**Selesai jika:** CI green di GitHub Actions tanpa intervensi manual.

---

## Phase 4 — Update CI Jika Perlu

Jika ada step yang gagal di CI tapi lolos lokal, kemungkinan penyebab:

| Gejala | Kemungkinan penyebab | Fix |
|--------|----------------------|-----|
| `format:check` gagal | File di-commit sebelum format | Jalankan `dart format .` → commit |
| `analyze` gagal | Warning/error yang hanya muncul di environment clean | Fix issue, push lagi |
| `test` gagal | Test bergantung pada file platform atau path absolut | Isolasi test dari platform dependency |
| `melos list` gagal | `melos` tidak terinstall di CI | Verifikasi step `dart pub get` install melos dari devDependencies |
| Flutter channel mismatch | CI pakai `stable` tapi local pakai versi lain | Pin channel di `ci.yml` via `flutter-version` jika perlu |

- [ ] Fix semua issue yang muncul di CI
- [ ] Push ulang → CI green

---

## Phase 5 — Dokumentasi CI di STARTER_GUIDE

- [ ] Pastikan `docs/STARTER_GUIDE.md` section 11 sudah akurat dengan state CI terkini
- [ ] Tambahkan badge CI ke `README.md`:
  ```markdown
  [![CI](https://github.com/<owner>/<repo>/actions/workflows/ci.yml/badge.svg)](https://github.com/<owner>/<repo>/actions/workflows/ci.yml)
  ```
  > Ganti `<owner>/<repo>` dengan path GitHub repo yang sebenarnya.

**Selesai jika:** CI green, badge tampil di README, STARTER_GUIDE akurat.
