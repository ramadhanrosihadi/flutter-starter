# 🤖 Agent Task: Deep Review — Flutter Starter Project (Iterasi)

## Identitas Task
- **Tipe Task**: Analisa Iteratif & Audit Mendalam (Deep Review)
- **Target**: Flutter Starter Project (Riverpod + REST API + Firebase + Material 3)
- **Use Case Target**: SaaS / Multi-tenant Mobile App
- **Output**: Dokumen review lengkap di folder `docs/review/`
- **Bahasa Output**: Bahasa Indonesia
- **Compatible dengan**: Claude, Gemini, GPT

---

## ⚠️ PENTING — Baca Ini Sebelum Melakukan Apapun

Project ini **bukan starter dari nol**. Ini adalah project yang sudah berjalan dan sedang dalam proses iterasi. Sudah ada dokumentasi di dalamnya.

**Kamu wajib membaca seluruh dokumentasi yang ada terlebih dahulu** sebelum mulai menganalisa apapun. Dokumentasi existing adalah konteks utama yang menjelaskan keputusan arsitektur, konvensi, dan arah project. Jangan berasumsi atau menganalisa berdasarkan kode saja tanpa membaca dokumennya lebih dulu.

Urutan wajib:
1. Baca semua dokumentasi existing → pahami intent dan keputusan yang sudah dibuat
2. Baru kemudian analisa kode untuk menilai apakah implementasi sesuai dengan dokumentasi
3. Gap antara dokumentasi dan implementasi adalah salah satu temuan terpenting

---

## 🎯 Misi Utama

Kamu adalah **Senior Flutter Architect** sekaligus **AI Agent Consultant**. Tugasmu adalah melakukan audit mendalam terhadap Flutter starter project ini dalam konteks **iterasi** — bukan review dari nol.

Tujuan audit:
1. Memahami kondisi dan intent project dari dokumentasi yang sudah ada
2. Menilai apakah project ini **siap digunakan sebagai starter project** untuk project SaaS baru
3. Menilai apakah project ini **AI Agent Friendly**
4. Menilai kesesuaian dengan **best practice Flutter modern** (khususnya Riverpod)
5. Mengidentifikasi **gap antara dokumentasi dan implementasi aktual**
6. Menilai kelengkapan **fitur generic** untuk SaaS mobile app

---

## 📋 Langkah-langkah Eksekusi (Ikuti Urutan Ini Ketat)

### LANGKAH 1 — Baca Semua Dokumentasi Existing

Sebelum menyentuh kode apapun, lakukan hal berikut:

1. Cari dan list semua file dokumentasi di project (README, docs/, CHANGELOG, ARCHITECTURE, CONVENTIONS, dsb)
2. Baca setiap file dokumentasi dari awal sampai akhir
3. Catat poin-poin penting:
   - Arsitektur yang direncanakan/digunakan
   - Konvensi yang ditetapkan
   - Fitur yang sudah diklaim ada
   - Fitur yang direncanakan (roadmap)
   - Keputusan teknis penting dan alasannya
4. Buat ringkasan pemahaman kamu dari dokumentasi di `00_SUMMARY.md` bagian "Pemahaman dari Dokumentasi Existing"

**Jangan lanjut ke Langkah 2 sebelum ini selesai.**

---

### LANGKAH 2 — Persiapan Folder Output

Buat struktur folder berikut jika belum ada:

```
docs/
└── review/
    ├── 00_SUMMARY.md
    ├── 01_starter_readiness.md
    ├── 02_ai_agent_friendliness.md
    ├── 03_best_practice.md
    ├── 04_documentation_completeness.md
    ├── 05_feature_completeness.md
    ├── 06_priority_areas.md
    └── 07_action_plan.md
```

---

### LANGKAH 3 — Mapping Struktur Project

Setelah membaca dokumentasi, lakukan eksplorasi kode. Petakan:

- Seluruh struktur direktori (minimal 3 level dalam)
- File `pubspec.yaml` — semua dependencies dan versi
- Folder struktur utama: `lib/`, `test/`, `assets/`
- Semua layer arsitektur yang ada (feature/, shared/, core/, dsb)
- Semua Provider / Notifier (Riverpod)
- Semua Repository dan data source
- Semua screen / page
- Semua widget yang di-share
- Routing setup (go_router? auto_route? Navigator 2.0?)
- Flavor / build configuration
- Firebase setup (google-services.json ada? FirebaseOptions?)
- Test files yang ada

Bandingkan struktur aktual dengan apa yang didokumentasikan.

---

### LANGKAH 4 — Eksekusi 7 Dokumen Review

---

#### 📄 `00_SUMMARY.md` — Ringkasan Eksekutif

```markdown
# Ringkasan Eksekutif Review — Flutter Starter

## Informasi Project
- Nama Project:
- Flutter Version (dari pubspec / .fvmrc):
- Dart Version:
- Tanggal Review:
- Direview oleh: [nama AI Agent]

## Pemahaman dari Dokumentasi Existing
[Ringkasan apa yang kamu pelajari dari dokumentasi yang sudah ada.
Jelaskan: arsitektur yang dimaksud, konvensi yang ditetapkan, fitur yang diklaim ada,
keputusan teknis penting. Ini adalah bagian WAJIB.]

## Gap Dokumentasi vs Implementasi
[Hal-hal yang didokumentasikan tapi tidak/belum diimplementasikan, atau sebaliknya]

## Scorecard Keseluruhan

| Kategori                        | Skor (1-10) | Status |
|---------------------------------|-------------|--------|
| Kesiapan sebagai Starter        |             |        |
| AI Agent Friendliness           |             |        |
| Best Practice Flutter/Riverpod  |             |        |
| Kelengkapan Dokumentasi         |             |        |
| Kelengkapan Fitur Generic       |             |        |
| **TOTAL RATA-RATA**             |             |        |

## Temuan Kritis
## Kelebihan Menonjol
## Rekomendasi Utama (Top 5)
## Struktur Project (Hasil Mapping)
```

---

#### 📄 `01_starter_readiness.md` — Kesiapan sebagai Starter Project

**A. Setup & Onboarding**
- [ ] Apakah README menjelaskan cara setup dari nol dengan jelas?
- [ ] Apakah ada prasyarat yang terdokumentasi (Flutter version, FVM, dsb)?
- [ ] Apakah menggunakan FVM (Flutter Version Management)?
- [ ] Apakah ada `Makefile` atau script helper untuk task umum?
- [ ] Apakah `.gitignore` sudah benar (mengecualikan `google-services.json`, `.env`, dsb)?
- [ ] Apakah ada `analysis_options.yaml` dengan lint rules yang ketat?

**B. Konfigurasi & Environment**
- [ ] Apakah ada mekanisme environment variable? (`--dart-define`, `.env`, `flutter_dotenv`)
- [ ] Apakah konfigurasi base URL API bisa diganti per environment?
- [ ] Apakah Firebase project dikonfigurasi untuk multi-environment (dev/staging/prod)?
- [ ] Apakah ada `l10n` / localization setup?

**C. Assets & Theme**
- [ ] Apakah assets (fonts, images, icons) sudah terstruktur dengan baik?
- [ ] Apakah ada theme yang konsisten dan mudah dikustomisasi (Material 3)?
- [ ] Apakah color scheme, typography, dan spacing terdefinisi di satu tempat?
- [ ] Apakah dark mode sudah didukung?

**D. Keamanan Dasar**
- [ ] Apakah tidak ada API key / credential hardcoded di kode?
- [ ] Apakah token disimpan dengan aman (flutter_secure_storage, bukan SharedPreferences)?
- [ ] Apakah ada certificate pinning (opsional tapi nilai plus)?
- [ ] Apakah ada obfuscation config untuk build release?

Sertakan **Skor Akhir: X/10** dengan justifikasi.

---

#### 📄 `02_ai_agent_friendliness.md` — AI Agent Friendliness

**A. Keterbacaan & Predictability**
- [ ] Apakah penamaan file, class, method konsisten dan deskriptif?
- [ ] Apakah struktur folder logis dan mudah diprediksi oleh AI?
- [ ] Apakah tidak ada "magic" yang tidak terdokumentasi (generated code, macro, dsb)?
- [ ] Apakah import path konsisten (relative vs absolute/package)?

**B. Dokumentasi untuk AI Context**
- [ ] Apakah ada file `CLAUDE.md` / `AGENTS.md` / `GEMINI.md`?
- [ ] Apakah ada `ARCHITECTURE.md` yang menjelaskan layer dan responsibility masing-masing?
- [ ] Apakah ada `CONVENTIONS.md` (naming, folder, state management patterns)?
- [ ] Apakah ada komentar pada Provider/Notifier yang kompleks?
- [ ] Apakah ada dokumentasi tentang cara menambah fitur baru (step by step)?

**C. Consistency — Hal Paling Penting untuk AI**
- [ ] Apakah semua fitur mengikuti pola folder yang sama?
- [ ] Apakah semua Notifier mengikuti pola yang sama?
- [ ] Apakah semua Repository mengikuti interface/abstraksi yang sama?
- [ ] Apakah HTTP error handling konsisten di semua data source?
- [ ] Apakah navigasi mengikuti satu pola yang konsisten?

**D. Kemudahan Generate Fitur Baru**
- [ ] Apakah ada contoh fitur CRUD lengkap yang bisa dijadikan template?
- [ ] Apakah ada code generator / mason brick untuk scaffold fitur baru?
- [ ] Apakah dependency antar fitur minimal?
- [ ] Apakah mudah untuk menambah screen baru tanpa menyentuh banyak file?

**E. Testing sebagai Safety Net**
- [ ] Apakah ada test yang cukup untuk AI bermodifikasi dengan aman?

Sertakan **Skor Akhir: X/10** dan rekomendasi spesifik.

---

#### 📄 `03_best_practice.md` — Flutter & Riverpod Best Practice

**A. Riverpod Architecture & Folder Structure (PRIORITAS TINGGI)**
- [ ] Apakah menggunakan Riverpod versi terbaru dengan code generation (`@riverpod`)?
- [ ] Apakah ada pemisahan jelas: `AsyncNotifierProvider` vs `NotifierProvider` vs `Provider`?
- [ ] Apakah Provider tidak melakukan terlalu banyak hal (Single Responsibility)?
- [ ] Apakah ada pemisahan `repository layer` dan `notifier layer`?
- [ ] Apakah folder structure berbasis fitur (feature-first) atau layer-first? Konsistenkah?
- [ ] Apakah ada `family` provider untuk data yang parametric?
- [ ] Apakah `ref.watch` vs `ref.read` digunakan dengan benar?
- [ ] Apakah ada memory leak dari listener yang tidak di-dispose?
- Tampilkan contoh Provider pattern yang ditemukan dan evaluasinya

**B. Offline Support & Local Storage (PRIORITAS TINGGI)**
- [ ] Apakah ada strategi offline-first atau cache-first?
- [ ] Package apa yang digunakan untuk local storage? (Hive, Isar, Drift, SQLite, SharedPreferences)
- [ ] Apakah ada sinkronisasi data ketika koneksi kembali?
- [ ] Apakah ada handling untuk kondisi "no internet" yang user-friendly?
- [ ] Apakah data sensitif dienkripsi di local storage?
- [ ] Apakah ada batasan ukuran cache dan mekanisme eviction?
- Tampilkan implementasi yang ditemukan dan evaluasinya

**C. Push Notification (PRIORITAS TINGGI)**
- [ ] Apakah menggunakan Firebase Cloud Messaging (FCM)?
- [ ] Apakah ada handling untuk 3 state: foreground, background, terminated?
- [ ] Apakah ada deep link dari notifikasi ke screen yang tepat?
- [ ] Apakah ada permission request yang proper (iOS dan Android)?
- [ ] Apakah FCM token diupdate ke backend saat login/refresh?
- [ ] Apakah ada local notification untuk foreground?
- Tampilkan implementasi yang ditemukan dan evaluasinya

**D. Flavors & Build Configuration (PRIORITAS TINGGI)**
- [ ] Apakah ada Flutter flavors? (dev, staging, prod)
- [ ] Apakah nama app, bundle ID, dan icon berbeda per flavor?
- [ ] Apakah Firebase project berbeda per flavor?
- [ ] Apakah base URL API dikonfigurasi per flavor?
- [ ] Apakah ada `launch.json` (VS Code) dan `Run Configurations` (Android Studio) untuk setiap flavor?
- [ ] Apakah ada script build untuk tiap flavor?
- Tampilkan konfigurasi yang ditemukan dan evaluasinya

**E. Authentication & Token Management**
- [ ] Apakah ada interceptor HTTP untuk auto-attach token?
- [ ] Apakah ada mekanisme auto-refresh token ketika expired (401 handler)?
- [ ] Apakah token disimpan di `flutter_secure_storage`?
- [ ] Apakah ada handling multi-tenant (tenant identifier dikirim di header/subdomain)?
- [ ] Apakah state login/logout di-handle dengan Riverpod secara konsisten?
- [ ] Apakah ada biometric login?

**F. HTTP & Networking**
- [ ] Package apa yang digunakan? (Dio? http?)
- [ ] Apakah ada base interceptor untuk logging, token, error handling?
- [ ] Apakah semua response di-parse ke model dengan `fromJson`?
- [ ] Apakah menggunakan `freezed` / `json_serializable` untuk model?
- [ ] Apakah error dari API dihandle secara konsisten (network error vs API error)?
- [ ] Apakah ada timeout configuration?

**G. Code Quality**
- [ ] Apakah ada `analysis_options.yaml` dengan lint rules?
- [ ] Apakah tidak ada `dynamic` type yang berlebihan?
- [ ] Apakah widget tidak terlalu besar (perlu dipecah)?
- [ ] Apakah menggunakan `const` constructor di mana memungkinkan?
- [ ] Apakah ada `build_runner` untuk code generation dan bagaimana cara menjalankannya?

Sertakan **Skor Akhir: X/10** per area dan overall.

---

#### 📄 `04_documentation_completeness.md` — Kelengkapan Dokumentasi

**A. Audit Dokumentasi Existing**

Ini adalah kelanjutan dari LANGKAH 1. Nilai kualitas setiap dokumen yang sudah ada:

| Dokumen yang Ditemukan | Lokasi | Kualitas (1-5) | Up-to-date? | Catatan |
|------------------------|--------|----------------|-------------|---------|
| (isi dari hasil eksplorasi) | | | | |

**B. Dokumen yang Seharusnya Ada tapi Belum**

| Dokumen | Prioritas | Outline Singkat |
|---------|-----------|----------------|
| `CLAUDE.md` / `AGENTS.md` | Tinggi | |
| `ARCHITECTURE.md` | Tinggi | |
| `CONVENTIONS.md` | Tinggi | |
| `docs/adding-new-feature.md` | Tinggi | |
| `docs/flavors-setup.md` | Sedang | |
| `docs/firebase-setup.md` | Sedang | |
| `docs/state-management-guide.md` | Sedang | |
| `CHANGELOG.md` | Sedang | |

**C. Gap Dokumentasi vs Kode**

Hal-hal yang didokumentasikan tapi tidak/belum diimplementasikan — atau sebaliknya.

**D. Kualitas Komentar dalam Kode**

Nilai komentar di kode: apakah ada, cukup, relevan, tidak berlebihan?

Sertakan **Skor Akhir: X/10**.

---

#### 📄 `05_feature_completeness.md` — Kelengkapan Fitur Generic SaaS Mobile

**A. Autentikasi & User**
| Fitur | Status | Catatan |
|-------|--------|---------|
| Login (email/password) | | |
| Register | | |
| Forgot password | | |
| Email verification | | |
| Social login (Google) | | |
| Biometric login | | |
| Edit profile | | |
| Ubah password | | |
| Upload foto profil | | |
| Logout | | |
| Auto-logout saat token expired | | |

**B. Multi-tenancy**
| Fitur | Status | Catatan |
|-------|--------|---------|
| Tenant selection / switcher | | |
| Tenant context di setiap request | | |
| Tenant-aware routing | | |
| Onboarding tenant baru | | |

**C. Notifikasi**
| Fitur | Status | Catatan |
|-------|--------|---------|
| FCM setup (Android & iOS) | | |
| Foreground notification | | |
| Background notification | | |
| Deep link dari notifikasi | | |
| Notification history / inbox | | |
| Notification preferences | | |

**D. Offline & Data**
| Fitur | Status | Catatan |
|-------|--------|---------|
| Deteksi koneksi internet | | |
| Cache data untuk offline | | |
| Retry saat kembali online | | |
| Loading state yang konsisten | | |
| Empty state yang konsisten | | |
| Error state yang konsisten | | |
| Pull-to-refresh | | |
| Infinite scroll / pagination | | |

**E. UI & UX Generic**
| Fitur | Status | Catatan |
|-------|--------|---------|
| Splash screen | | |
| Onboarding screens | | |
| Bottom navigation | | |
| Drawer / side menu | | |
| Dark mode | | |
| Loading skeleton | | |
| Toast / snackbar | | |
| Konfirmasi dialog | | |
| Image picker & preview | | |
| In-app update prompt | | |

**F. Developer Experience**
| Fitur | Status | Catatan |
|-------|--------|---------|
| Flavors (dev/staging/prod) | | |
| Logging / crash reporting (Firebase Crashlytics) | | |
| Analytics setup (Firebase Analytics) | | |
| Performance monitoring | | |
| Unit tests | | |
| Widget tests | | |
| Integration tests | | |

Status: ✅ Lengkap / ⚠️ Sebagian / ❌ Belum Ada / 🔲 Tidak Relevan

Sertakan **Skor Akhir: X/10** dan fitur paling mendesak untuk ditambahkan.

---

#### 📄 `06_priority_areas.md` — Deep Dive Area Prioritas

Untuk setiap area berikut, berikan analisa sangat mendalam:
1. Tampilkan kode/konfigurasi aktual yang ditemukan (snippet relevan)
2. Bandingkan dengan apa yang didokumentasikan
3. Identifikasi masalah spesifik dengan referensi file dan baris
4. Berikan contoh kode perbaikan yang konkret (Dart/Flutter)
5. Estimasi effort perbaikan: S (< 1 hari) / M (1-3 hari) / L (3-7 hari) / XL (> 1 minggu)

**Area 1: Riverpod Architecture & Folder Structure**
- Apakah sesuai dengan pola yang didokumentasikan?
- Apakah ada inkonsistensi antar fitur?
- Apakah mengikuti best practice Riverpod terbaru?
- Rekomendasi refactor spesifik jika ada

**Area 2: Offline Support & Local Storage**
- Package apa yang digunakan dan bagaimana implementasinya?
- Apakah strategi cache sudah tepat untuk use case SaaS?
- Rekomendasi perbaikan/penambahan

**Area 3: Push Notification**
- Status implementasi FCM saat ini
- Apakah 3 state (foreground/background/terminated) sudah dihandle?
- Apakah deep link sudah berfungsi?
- Rekomendasi perbaikan/penambahan

**Area 4: Flavors & Build Configuration**
- Status konfigurasi flavor saat ini
- Apakah sudah cukup untuk workflow dev/staging/prod?
- Rekomendasi setup yang lebih lengkap jika perlu

---

#### 📄 `07_action_plan.md` — Action Plan & Roadmap Iterasi

**A. Temuan Kritis (Selesaikan Sebelum Digunakan sebagai Starter)**

| # | Temuan | File/Lokasi | Dampak | Estimasi Effort |
|---|--------|-------------|--------|----------------|
| 1 | | | | |

**B. Perbaikan Penting — Sprint 1 (1-2 Minggu)**

| # | Item | Alasan Prioritas | Estimasi Effort |
|---|------|-----------------|----------------|
| 1 | | | |

**C. Peningkatan — Sprint 2 (2-4 Minggu)**

| # | Item | Manfaat | Estimasi Effort |
|---|------|---------|----------------|
| 1 | | | |

**D. Nice to Have — Backlog**

**E. Dokumen yang Harus Dibuat (dengan Outline Lengkap)**

Untuk setiap dokumen yang direkomendasikan, berikan outline lengkap agar developer atau AI Agent bisa langsung mengerjakannya.

**F. Saran Khusus untuk Iterasi Berikutnya**

Berdasarkan kondisi project yang sudah berjalan, berikan saran strategis:
- Apa yang sebaiknya di-refactor vs dipertahankan?
- Apakah ada hutang teknis yang perlu dilunasi sebelum scale?
- Apakah arsitektur saat ini cukup untuk kebutuhan SaaS multi-tenant jangka panjang?

**G. Estimasi Total Effort**

Estimasi total waktu untuk membawa project ini ke kondisi "starter-ready untuk SaaS".

---

## 📌 Aturan Penulisan Output

1. **Baca dokumentasi existing dulu** — ini non-negotiable, lakukan sebelum analisa kode
2. **Hormati keputusan yang sudah ada** — jika ada alasan di balik suatu keputusan arsitektur (tercatat di dokumentasi), akui itu sebelum memberikan alternatif
3. **Konteks iterasi** — bedakan antara "ini kurang bagus" vs "ini sudah oke untuk iterasi saat ini"
4. **Referensi file spesifik** — selalu sebut nama file dan baris ketika membahas temuan
5. **Kode Dart konkret** — berikan contoh kode perbaikan yang langsung bisa digunakan
6. **Gunakan emoji status**: ✅ Baik / ⚠️ Perlu Perhatian / ❌ Masalah / 💡 Rekomendasi / 🔥 Kritis / 📖 Dari Dokumentasi
7. **Bahasa Indonesia** — seluruh output dalam Bahasa Indonesia
8. **Jangan skip bagian** — jika fitur tidak ditemukan, tulis eksplisit "Tidak ditemukan"
9. **Akhiri setiap dokumen** dengan tabel ringkasan dan skor

---

## ⚠️ Batasan & Catatan

- Jangan modifikasi file apapun selain membuat file baru di `docs/review/`
- Jika ada file yang tidak bisa diakses, catat di `00_SUMMARY.md` dan lanjutkan
- Jika menemukan security issue serius, tandai dengan 🔥 **SECURITY**
- Generated files (`.g.dart`, `.freezed.dart`) tidak perlu dianalisa isinya, cukup konfirmasi keberadaannya
- Setelah semua dokumen selesai, tampilkan: `✅ Review selesai. Semua dokumen tersimpan di docs/review/`

---

## 🚀 Mulai Sekarang

**LANGKAH 1 dulu**: Temukan dan baca semua dokumentasi existing. Buat ringkasan pemahaman kamu. Baru lanjut ke langkah berikutnya.

Konfirmasi setiap dokumen review selesai dibuat sebelum lanjut ke berikutnya.

**Selamat mengaudit!**
