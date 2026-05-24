# Audit AI Agent Friendliness (Kemudahan bagi AI Agent)

Tingkat kemudahan bagi kecerdasan buatan (*AI Agent Friendliness*) sangat penting dalam proyek modern. Ketika agen AI seperti Claude, Gemini, atau GPT ditugaskan untuk memperbaiki *bug* atau menambah fitur baru, kejelasan struktur, konsistensi pola, dan ketersediaan dokumen instruksi khusus akan menentukan keberhasilan pengerjaan tanpa merusak kode lainnya.

---

## A. Keterbacaan & Predictability

- **[✅ Baik] Penamaan File, Class, & Method**:
  Penamaan dalam proyek ini sangat deskriptif dan konsisten mengikuti konvensi Flutter/Dart standar. Penamaan layer (seperti `AuthLocalDataSource` di data layer, `AuthRepository` di domain layer, dan `LoginScreen` di presentation layer) sangat intuitif dan memudahkan AI melacak alur eksekusi data.
  
- **[✅ Baik] Struktur Folder yang Terprediksi**:
  Struktur monorepo dan pembagian folder Clean Architecture (`data/`, `domain/`, `presentation/`) di bawah folder fitur memudahkan AI dalam menebak di mana letak komponen tertentu secara instan. AI dapat memprediksi lokasi dengan ketepatan tinggi (efek *highly predictable structure*).

- **[✅ Baik] Minim "Magic Code"**:
  Karena proyek ini murni menggunakan Riverpod vanilla dan belum menggunakan generator atau makro berat yang menghasilkan banyak berkas `.g.dart` misterius, AI dapat dengan mudah membaca dan mengedit logika state secara langsung tanpa takut merusak ketergantungan kode tersembunyi.

- **[✅ Baik] Import Path yang Rapi**:
  Penggunaan import relatif di dalam implementasi internal package (`src/`) dan import barrel (`package:core/core.dart`) saat diakses dari luar package dipatuhi secara konsisten. Ini mencegah kekacauan impor (*import pollution*) yang sering membingungkan AI.

---

## B. Dokumentasi untuk AI Context

- **[❌ Masalah] Ketiadaan Berkas Kebutuhan AI (`CLAUDE.md` / `AGENTS.md`)**:
  Repositori ini **tidak memiliki berkas panduan khusus untuk AI** seperti `CLAUDE.md` atau `AGENTS.md`. File semacam ini sangat krusial bagi AI Agent untuk mengetahui pintasan perintah instan (misal cara menjalankan analisis, format kode, dan pengujian secara lokal) serta batasan modifikasi file.

- **[✅ Baik] Berkas `ARCHITECTURE.md` yang Rinci**:
  Dokumen arsitektur di root sangat membantu AI dalam memahami keputusan arsitektur monorepo, aliran data Clean Architecture, serta pemisahan flavor dan environment.

- **[❌ Masalah] Ketiadaan `CONVENTIONS.md`**:
  Tidak ada dokumen standarisasi penulisan kode (*coding conventions*) terpisah. Meskipun aturan dependency dibahas secara ringkas di `ARCHITECTURE.md`, AI membutuhkan rincian spesifik mengenai aturan penulisan *state management*, penanganan *error*, dan struktur penulisan berkas pengujian.

- **[⚠️ Perlu Perhatian] Dokumentasi Step-by-Step Menambah Fitur**:
  Panduan operasional di `docs/ADD_FEATURE.md` dan `docs/ADD_APP_FLAVOR.md` sudah sangat baik dan menjadi referensi konkret bagi AI untuk menduplikasi pola saat ditugaskan membuat modul baru. Namun, panduan ini belum diperbarui untuk memperhitungkan error kompilasi lokal yang ada saat ini.

---

## C. Consistency (Konsistensi Pola)

- **[✅ Baik] Konsistensi Pola Folder Fitur**:
  Semua fitur (baik di `features_shared` maupun di `apps/`) menerapkan konvensi penamaan folder layer yang sama secara presisi.

- **[✅ Baik] Konsistensi Penulisan Notifier & Repository**:
  Semua *notifier* memperluas kelas `Notifier` atau `AsyncNotifier` dengan pola inisialisasi usecase yang serupa di dalam method `build()`. Begitu pula dengan kelas implementasi repository yang selalu menerima data source melalui *constructor injection*.

- **[⚠️ Perlu Perhatian] Konsistensi HTTP Error Handling**:
  Penanganan *error* jaringan menggunakan Dio Client di `core` sudah dideklarasikan melalui kelas `AppException`, namun penggunaannya belum sepenuhnya merata di seluruh data source riil (karena sebagian besar data source saat ini masih berupa data simulasi/stub).

- **[✅ Baik] Konsistensi Navigasi**:
  Seluruh routing aplikasi diatur dengan format penggabungan rute (*route merging*) GoRouter yang seragam di berkas `app_router.dart` masing-masing aplikasi.

---

## D. Kemudahan Generate Fitur Baru

- **[✅ Baik] Template Fitur CRUD**:
  Fitur `auth` dan `profile` di `features_shared` menyajikan contoh implementasi Clean Architecture yang lengkap dan solid, mulai dari entity, model DTO, data source, usecase, provider, hingga layar presentasi. Ini adalah *blueprint* sempurna untuk diduplikasi oleh AI Agent.
  
- **[❌ Masalah] Ketiadaan Mason Brick / Code Generator**:
  Belum ada otomasi pembuatan struktur folder fitur (seperti Mason CLI atau generator lokal). AI harus menulis folder `data/domain/presentation` dan file pendukungnya satu per satu secara manual.

- **[✅ Baik] Independensi Fitur (Decoupled)**:
  Tingkat ketergantungan antar fitur (*feature coupling*) sangat rendah. Menambah fitur baru di `features_shared` dapat dilakukan dengan mudah tanpa memicu efek domino yang merusak rute atau state fitur lain.

---

## E. Testing sebagai Safety Net

- **[✅ Baik] Keberadaan Berkas Pengujian**:
  Pengujian unit (*unit tests*) untuk repository dan notifier, serta pengujian widget (*widget tests*) untuk tampilan layar settings dan home sudah tersedia secara representatif. Keberadaan tes ini menjadi pagar pengaman (*safety net*) yang luar biasa bagi AI Agent untuk memastikan modifikasi kodenya tidak merusak fungsionalitas yang sudah berjalan.

---

## Kesimpulan & Skor AI Friendliness

> [!TIP]
> **Skor Akhir AI Agent Friendliness: 7.5 / 10**
> 
> **Justifikasi**:
> Proyek ini dirancang secara sangat terstruktur, bersih, konsisten, dan meminimalkan "magic code" yang rumit. Hal ini membuat repositori ini sangat mudah dipetakan dan dimodifikasi oleh AI Agent. Satu-satunya kekurangan utama adalah **ketiadaan berkas instruksi khusus AI (`CLAUDE.md`)** dan ketiadaan otomasi pembuatan *boilerplate* kode (seperti Mason), serta adanya compile error *RadioGroup* yang dapat membingungkan agen AI yang baru bergabung ke dalam proyek.

### Rekomendasi Utama untuk Meningkatkan AI Friendliness

1. 💡 **Buat Berkas `CLAUDE.md` di Root Repositori**:
   Tulis panduan ringkas berisi instruksi perintah analisis (`melos run analyze`), formatting (`melos run format`), dan testing (`melos run test`) beserta aturan impor dan arsitektur dalam 1 berkas kompak untuk referensi instan AI Agent.
2. 💡 **Sediakan Mason CLI Bricks**:
   Buat template Mason CLI untuk membuat satu set folder dan file Clean Architecture per fitur secara otomatis.
3. 💡 **Perbaiki Compile Error Secepatnya**:
   Compile error yang ada di proyek saat ini (seperti `RadioGroup`) dapat membuat agen AI mengambil kesimpulan yang salah tentang kesiapan sistem.
