# Audit Kesiapan sebagai Starter Project

Dokumen ini mengevaluasi kegunaan dan kesiapan repositori ini untuk digunakan sebagai *starter project* untuk pengembangan aplikasi SaaS mobile baru. Penilaian dibagi menjadi beberapa aspek utama: *onboarding*, konfigurasi/lingkungan, aset & tema, serta keamanan dasar.

---

## A. Setup & Onboarding

- **[⚠️ Perlu Perhatian] Penjelasan README & Setup**:
  Dokumentasi utama di `README.md` dan `docs/STARTER_GUIDE.md` sangat detail dan menjelaskan alur fork, pergantian identitas aplikasi, serta inisialisasi awal. Namun, **ketiadaan langkah eksplisit untuk menjalankan `flutter gen-l10n`** setelah melakukan `melos bootstrap` adalah hambatan besar. Developer baru akan langsung dihadapkan pada 37 compile error karena berkas `AppLocalizations` belum terbentuk secara lokal.
  
- **[⚠️ Perlu Perhatian] Penggunaan FVM (Flutter Version Management)**:
  Dokumen arsitektur menyebutkan prasyarat FVM, namun di dalam seluruh repositori **tidak ditemukan berkas konfigurasi `.fvmrc`** maupun folder `.fvm`. Hal ini membuat deklarasi FVM hanya bersifat instruksi tekstual tanpa adanya penegakan (*enforcement*) versi SDK Dart/Flutter yang seragam antar kontributor.

- **[⚠️ Perlu Perhatian] Skrip Helper / Makefile**:
  Proyek ini mengandalkan skrip Melos di root `pubspec.yaml` (seperti `melos run dev`, `melos run analyze`, dan `melos run test`) yang sangat baik untuk monorepo. Namun, ketiadaan `Makefile` membuat developer harus mengetik skrip Melos yang relatif panjang (`dart run melos run ...`) secara manual jika tidak menggunakan pintasan IDE.

- **[❌ Masalah] Keamanan Berkas `.gitignore`**:
  Berkas `.gitignore` standar Flutter sudah ada, namun **tidak mengecualikan file kredensial penting** seperti berkas konfigurasi `.env` atau `google-services.json` (Android) / `GoogleService-Info.plist` (iOS). Ini meningkatkan risiko kebocoran kunci API rahasia ke publik jika proyek dihosting di repositori terbuka.

- **[⚠️ Perlu Perhatian] Linting & Analisis**:
  Berkas `analysis_options.yaml` di root tidak ada, sementara di paket `core` dan `features_shared` hanya menggunakan aturan dasar `package:flutter_lints/flutter.yaml` yang sangat permissive. Proyek starter SaaS premium seharusnya menyertakan aturan linting yang jauh lebih ketat (seperti `very_good_analysis` atau lints kustom) untuk memastikan kualitas kode sejak hari pertama.

---

## B. Konfigurasi & Environment

- **[✅ Baik] Mekanisme Environment Variable**:
  Mekanisme pembacaan konfigurasi environment menggunakan `--dart-define=ENV=...` sudah terimplementasi secara cerdas melalui `AppConfig` di `core` serta `MainConfig` & `VariantConfig` di aplikasi masing-masing. Ini adalah pendekatan modern dan aman yang tidak bergantung pada paket pihak ketiga untuk pembacaan variabel lingkungan dasar.

- **[✅ Baik] Konfigurasi Base URL Dinamis**:
  URL API dasar (`baseUrl`) dapat berganti secara otomatis berdasarkan environment (`dev`, `staging`, `prod`) dengan menggunakan ekspresi `switch-case` Dart yang bersih.

- **[❌ Masalah] Firebase Multi-Environment**:
  Meskipun dokumentasi mengklaim kesiapan multi-environment untuk Firebase, **tidak ada implementasi konfigurasi Firebase per flavor/environment** di dalam kode. File konfigurasi platform Google Services sama sekali tidak ditemukan di folder Android maupun iOS.

- **[⚠️ Perlu Perhatian] Localization (`l10n`) Setup**:
  Konfigurasi `l10n.yaml` di `packages/core` sudah terkonfigurasi dengan benar untuk meletakkan hasil *generate* langsung di `lib/src/l10n`. Namun, ketiadaan proses otomatisasi *generating* pada instalasi awal memicu error analisis masif di seluruh workspace.

---

## C. Assets & Theme

- **[❌ Masalah] Struktur Aset (Fonts, Images, Icons)**:
  Sama sekali **tidak ada folder `assets/`** baik di tingkat monorepo root maupun di dalam masing-masing aplikasi (`apps/main` atau `apps/variant`). Proyek starter tidak menyediakan placeholder gambar default atau panduan meletakkan aset media bersama.

- **[✅ Baik] Desain Sistem & Tema (Material 3)**:
  Penerapan Material 3 di `AppTheme` (`packages/core/lib/src/theme/app_theme.dart`) sangat baik. Penggunaan skema warna dinamis berbasis `ColorScheme.fromSeed` dengan warna dasar `AppColors.primary` memberikan estetika yang premium dan modern.

- **[✅ Baik] Konsistensi Spasi & Tipografi**:
  Tipografi terpusat di `AppTextStyles` dan warna di `AppColors` dikonfigurasi secara profesional, memudahkan kustomisasi UI secara global.

- **[✅ Baik] Dukungan Dark Mode**:
  Dukungan tema gelap (*dark mode*) terintegrasi secara dinamis di tingkat *router* dan *notifier* (`themeNotifierProvider`), berjalan lancar secara real-time tanpa memerlukan restart aplikasi.

---

## D. Keamanan Dasar

- **[✅ Baik] Penyimpanan Token Aman**:
  Penyimpanan token autentikasi sensitif disalurkan secara benar melalui `SecureStorageService` yang membungkus `flutter_secure_storage`. Ini mencegah penyimpanan data sensitif di `SharedPreferences` yang rentan terhadap akses tidak sah.
  
- **[✅ Baik] Ketiadaan Kredensial Hardcoded**:
  Sejauh ini tidak ditemukan adanya kunci API (*API Keys*) atau kredensial yang ditulis secara keras (*hardcoded*) di dalam berkas kode sumber. Konfigurasi API murni bersandar pada *environment config*.

- **[❌ Masalah] Pengaburan Kode & Obfuscation**:
  Tidak ada dokumentasi maupun konfigurasi build script (seperti opsi `--obfuscate` dan `--split-debug-info` pada build command Melos) untuk mengamankan APK/IPA rilis dari upaya rekayasa balik (*reverse engineering*).

---

## Kesimpulan & Skor Kesiapan

> [!WARNING]
> **Skor Akhir Kesiapan Starter: 5.5 / 10**
> 
> **Justifikasi**: 
> Proyek ini memiliki desain sistem tema (Material 3), manajemen konfigurasi lingkungan (`--dart-define`), dan arsitektur monorepo Melos yang luar biasa kokoh dan profesional. Namun, proyek ini belum bisa dikatakan "siap pakai" sebagai *starter* karena mengalami **kegagalan build awal** akibat ketiadaan file l10n ter-generate, *compile error* fatal pada komponen `RadioGroup` di main app, serta tidak adanya aset bawaan dan konfigurasi pengamanan `.gitignore` untuk data kredensial.

### Ringkasan Status Evaluasi Kesiapan

| Komponen | Status | Rekomendasi Perbaikan Segera |
| :--- | :---: | :--- |
| **Setup README** | ⚠️ Perlu Perhatian | Tambahkan langkah `cd packages/core && flutter gen-l10n` setelah bootstrap. |
| **Integrasi FVM** | ⚠️ Perlu Perhatian | Buat file `.fvmrc` di root repositori dengan versi Flutter terkunci (misal `3.24.3`). |
| **Keamanan Git** | ❌ Masalah | Perbarui `.gitignore` root untuk mengecualikan `.env`, `*.jks`, `google-services.json`, dll. |
| **Aset Bawaan** | ❌ Masalah | Buat direktori `assets/images` dan `assets/fonts` di paket `core` dengan ekspor terpadu. |
| **Skrip Rilis** | ❌ Masalah | Tambahkan argumen pengaburan kode (*obfuscation*) di skrip build Melos. |
