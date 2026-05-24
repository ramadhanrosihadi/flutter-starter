# Action Plan & Roadmap Iterasi

Dokumen ini memuat peta jalan taktis (*tactical roadmap*) untuk membawa Flutter Starter Project ini dari kondisinya saat ini ke kondisi prima yang siap digunakan (*SaaS starter-ready*). Peta jalan dibagi berdasarkan skala prioritas kepentingan, dilengkapi dengan outline dokumen baru dan estimasi total waktu pengerjaan.

---

## A. Temuan Kritis (🔥 Selesaikan Segera)

Ini adalah masalah mendesak yang menyebabkan kegagalan build/analisis atau kerentanan keamanan serius, dan harus diselesaikan sebelum starter project didistribusikan ke developer lain:

| # | Temuan | File / Lokasi | Dampak | Estimasi Effort |
| :-: | :--- | :--- | :--- | :---: |
| **1** | **Compile Error `RadioGroup`** | `apps/main/lib/features/settings/presentation/settings_screen.dart` | Kegagalan kompilasi total pada main app flavor. | `S (< 1 jam)` |
| **2** | **Ketiadaan Generated `AppLocalizations`** | `packages/core/lib/src/l10n/` | 37 error analisis statis di seluruh workspace. | `S (5 menit)` |
| **3** | **Kredensial Tidak Dikecualikan di Git** | Root `.gitignore` | Potensi kebocoran file `.env` dan `google-services.json`. | `S (10 menit)` |

---

## B. Perbaikan Penting — Sprint 1 (1-2 Minggu)

Fokus pada penguatan arsitektur, standarisasi Riverpod modern, dan penyediaan infrastruktur penting SaaS (notifikasi push & database lokal):

| # | Item | Alasan Prioritas | Estimasi Effort |
| :-: | :--- | :--- | :---: |
| **1** | **Migrasi ke Riverpod Generator (`@riverpod`)** | Menghilangkan boilerplate penulisan provider, mengaktifkan autoDispose bawaan, dan menjamin tipe data aman (*type safety*). | `M (2-3 hari)` |
| **2** | **Integrasi Riil Firebase Core & FCM** | Mengganti stub notifikasi push dengan SDK Firebase asli agar aplikasi dapat menerima pesan foreground/background. | `L (4-5 hari)` |
| **3** | **Integrasi Isar Database (Offline Cache)** | Menyediakan mesin basis data lokal berkinerja tinggi untuk mendukung penyimpanan data SaaS offline secara terstruktur. | `L (4-5 hari)` |

---

## C. Peningkatan — Sprint 2 (2-4 Minggu)

Fokus pada peningkatan kenyamanan pengguna (UX), fitur sekuritas lanjutan, dan integrasi siklus sesi yang mulus:

| # | Item | Manfaat | Estimasi Effort |
| :-: | :--- | :--- | :---: |
| **1** | **Auto-Refresh Token (401 Interceptor)** | Mencegah pengguna dikeluarkan secara paksa saat token kedaluwarsa dengan memperbaruinya otomatis di latar belakang. | `M (2 hari)` |
| **2** | **Splash Screen & Onboarding UI** | Memberikan kesan pertama yang sangat premium dan profesional saat aplikasi pertama kali dibuka. | `M (3 hari)` |
| **3** | **Autentikasi Biometrik (Sidik Jari/Wajah)** | Menyediakan fitur masuk cepat yang aman dan canggih bagi pengguna akhir mobile. | `M (2 hari)` |

---

## D. Nice to Have — Backlog (Jangka Panjang)

- **Mason CLI Bricks**: Otomasi pembuatan struktur folder Clean Architecture per fitur.
- **Certificate Pinning**: Peningkatan proteksi keamanan jaringan tingkat tinggi dari ancaman *man-in-the-middle attack*.
- **Firebase Performance Monitoring & Crashlytics**: Pelacakan metrik latensi UI dan laporan error rilis secara terotomatisasi.

---

## E. Dokumen Baru yang Harus Dibuat (Outline Lengkap)

### 1. `CLAUDE.md` (Panduan Pintas untuk AI Agent)
Dokumen ringkas satu halaman diletakkan di root repositori untuk menuntun AI Agent baru bekerja dengan benar:
```markdown
# Panduan AI Agent — Flutter Starter Workspace

## Perintah Pintas (Melos Commands)
- Bootstrap proyek: `dart run melos bootstrap`
- Jalankan analisis: `dart run melos run analyze`
- Jalankan pengujian: `dart run melos run test`
- Jalankan auto-format kode: `dart run melos run format`
- Jalankan generate kode l10n: `cd packages/core && flutter gen-l10n`

## Aturan Struktur Kode & Dependency
- core: Tidak boleh mengimport pustaka features_shared maupun apps.
- features_shared: Boleh mengimport core, tidak boleh import apps.
- apps/*: Boleh mengimport keduanya.
- Selalu gunakan relative imports untuk file di dalam package src/ yang sama.
- Ekspor API publik package melalui berkas barrel (`core.dart` / `features_shared.dart`).
```

### 2. `docs/firebase-setup.md` (Langkah Integrasi Firebase)
```markdown
# Panduan Integrasi Firebase Multi-Tenant

## Langkah 1: Registrasi Konsol Firebase
1. Buka [Console Firebase](https://console.firebase.google.com/).
2. Buat proyek baru untuk tiap flavor (misal `your-app-main` dan `your-app-variant`).

## Langkah 2: Konfigurasi FlutterFire CLI
1. Jalankan `npm install -g firebase-tools` (jika belum ada).
2. Login menggunakan `firebase login`.
3. Jalankan `flutterfire configure` dari dalam folder masing-masing aplikasi (`apps/main` dan `apps/variant`) untuk men-generate berkas `firebase_options.dart`.

## Langkah 3: Penempatan Berkas Konfigurasi Native
- Android: Letakkan `google-services.json` hasil unduhan ke dalam `apps/<app_name>/android/app/`.
- iOS: Daftarkan `GoogleService-Info.plist` melalui Xcode ke dalam proyek runner aplikasi bersangkutan.
```

---

## F. Saran Khusus untuk Iterasi Berikutnya

1. **Apa yang Harus Dipertahankan**:
   - Struktur monorepo multi-app terpisah (`apps/main` dan `apps/variant`) sangat brilian untuk model bisnis SaaS multi-tenant / multi-brand. Model ini jauh lebih mudah diatur, aman secara isolasi data native, dan lebih bersih dibanding konfigurasi satu aplikasi dengan puluhan flavor gradle yang rumit. Pertahankan struktur ini!
   
2. **Apa yang Harus Di-refactor**:
   - Kode pengisian data model DTO manual harus segera diganti menggunakan **Freezed** atau **Json Serializable** untuk menghemat waktu penulisan pengujian dan mencegah error tipografi nama key JSON API.
   - Pindahkan logika inisialisasi krusial dari *frame callback* `app.dart` ke tingkat entry point sesungguhnya di `bootstrap.dart` untuk memastikan persiapan seluruh layanan penyimpanan dan jaringan selesai seutuhnya sebelum widget pertama dirender.

---

## G. Estimasi Total Effort

Membawa proyek ini dari kondisi saat ini ke kondisi seutuhnya siap pakai untuk produksi SaaS mobile membutuhkan waktu pengerjaan sekitar **3 Minggu Kerja Efektif (Full-time Development)**.
