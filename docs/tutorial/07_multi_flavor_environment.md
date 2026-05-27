# 🎨 Modul 7: Memahami Multi-Flavor & Multi-Environment

Bagi pemula, istilah **"Flavor"** dan **"Environment"** sering kali dianggap sama. Namun, di starter project kelas dunia ini, keduanya dipisahkan secara bersih untuk mendukung skenario bisnis **SaaS (Software-as-a-Service) / Multi-Tenant / White-Label**.

Mari kita bedah perbedaan keduanya, bagaimana kode proyek memprosesnya, dan cara menjalankannya dengan mudah!

---

## 1. Perbedaan Mendasar: Flavor vs Environment

Untuk memahaminya dengan mudah, bayangkan tabel berikut:

| Konsep | Pertanyaan yang Dijawab | Contoh di Proyek Ini | Lokasi Fisik Folder |
| :--- | :--- | :--- | :--- |
| **Flavor (App)** | **"Aplikasi milik siapa yang sedang di-build?"** (Identitas, nama aplikasi, logo, konfigurasi warna) | `main` (Aplikasi utama) <br> `variant` (Aplikasi white-label klien B) | `apps/main/` <br> `apps/variant/` |
| **Environment** | **"Server database mana yang sedang dihubungkan?"** (Base URL API, debug logs, kunci API dev/prod) | `dev` (Local/Sandbox) <br> `staging` (Uji coba QA) <br> `prod` (Server asli konsumen) | `packages/core/lib/src/config/` |

> [!TIP]
> **Kombinasi Tak Terbatas**:
> Dengan pemisahan ini, Anda bisa menjalankan aplikasi **Main** yang terhubung ke server **Staging**, atau menjalankan aplikasi **Variant** (klien white-label) yang terhubung ke server **Production**.

---

## 2. Bagaimana Environment Dibaca oleh Flutter?

Kita menghindari cara kuno seperti membuat file config terpisah yang di-load saat runtime (lambat dan rentan). Sebagai gantinya, kita menggunakan fitur bawaan Flutter: **`--dart-define`**.

### Alur Pembacaan Environment:
1. Saat menjalankan aplikasi, kita mengirim parameter lingkungan di CLI:
   ```bash
   flutter run --dart-define=ENV=dev
   ```
2. Di dalam kode, kelas `AppConfig` di `packages/core` bertugas mendeteksi nilai `--dart-define` tersebut:
   ```dart
   enum Environment {
     dev,
     staging,
     prod;
     
     static Environment fromString(String value) {
       return values.firstWhere(
         (e) => e.name == value.toLowerCase(),
         orElse: () => Environment.dev,
       );
     }
   }
   ```
3. Masing-masing aplikasi (`apps/main` & `apps/variant`) memiliki kelas konfigurasi konkrit (`MainConfig` dan `VariantConfig`) yang mewarisi `AppConfig` dan menentukan URL API yang dinamis:
   ```dart
   // apps/main/lib/config/main_config.dart
   class MainConfig extends AppConfig {
     @override
     String get baseUrl => switch (environment) {
       Environment.dev => 'https://api-dev.mainproduct.com',
       Environment.staging => 'https://api-staging.mainproduct.com',
       Environment.prod => 'https://api.mainproduct.com',
     };
   }
   ```

---

## 3. Cara Menjalankan Kombinasi Flavor & Environment

Sebagai developer, Anda tidak perlu mengetik perintah yang panjang dan rumit di terminal setiap hari. Melos dan VS Code sudah dikonfigurasi untuk memudahkan hidup Anda!

### Opsi A: Menggunakan CLI Melos (Root Folder)
Melos menyediakan pintasan (*scripts*) di `pubspec.yaml` untuk menjalankan versi *Development*:

```bash
# Menjalankan aplikasi Utama (main app) di lingkungan dev
dart run melos run dev

# Menjalankan aplikasi Varian (variant app) di lingkungan dev
dart run melos run dev:variant
```

### Opsi B: Menggunakan Launch Configurations VS Code (Sangat Direkomendasikan)
Buka menu **Run & Debug (Ctrl+Shift+D)** di VS Code. Anda akan melihat daftar konfigurasi siap pakai:
* `main (dev)` — Menjalankan aplikasi utama dengan server sandbox.
* `main (staging)` — Menjalankan aplikasi utama untuk verifikasi QA.
* `main (prod)` — Menjalankan aplikasi utama versi live.
* `variant (dev)` — Menjalankan aplikasi klien B dengan server sandbox.
* `variant (staging)` — Menjalankan aplikasi klien B versi QA.
* `variant (prod)` — Menjalankan aplikasi klien B versi live.

Cukup klik tombol **Play (F5)** pada pilihan yang diinginkan untuk memulai debug instan!

---

## 4. Keamanan Firebase Per Flavor & Environment

Karena Firebase memerlukan file konfigurasi native (`google-services.json` untuk Android dan `GoogleService-Info.plist` untuk iOS), starter project ini menggunakan teknik **Multi-Folder Configuration** untuk memisahkan Firebase di tingkat native:

```text
apps/main/android/app/src/
├── dev/
│   └── google-services.json       # Firebase untuk Main Dev
├── staging/
│   └── google-services.json       # Firebase untuk Main Staging
└── release/
    └── google-services.json       # Firebase untuk Main Production
```

Gradle Android dan Xcode iOS telah dikonfigurasi secara otomatis untuk menyalin file kustom yang sesuai berdasarkan flavor & environment yang sedang dikompilasi saat proses build berjalan.

> [!NOTE]
> Panduan konfigurasi konsol Firebase dan native secara lengkap dapat dibaca di berkas panduan khusus **[docs/firebase-setup.md](file:///c:/Users/62822/Documents/Work/flutter/flutter-starter/docs/firebase-setup.md)**.

---

## 🌐 Langkah Penutup

Modul berikutnya akan menjelaskan secara lengkap dan detail langkah-demi-langkah mengimplementasikan integrasi API REST baru dari awal hingga UI!

👉 **[Lanjut ke Modul 8: Mengimplementasikan API Baru](file:///c:/Users/62822/Documents/Work/flutter/flutter-starter/docs/tutorial/08_implementasi_api_baru.md)**
