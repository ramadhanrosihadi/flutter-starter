# 📋 Bagian 3: UI Design, Routing, & Integrasi Dashboard

> [!IMPORTANT]
> **MANDATORY / WAJIB SEBELUM MEMULAI:**
> Sebelum Anda mengimplementasikan antarmuka UI, navigasi, dan melokalkan teks, Anda **HARUS** membaca dan mematuhi panduan pada **`docs/ADD_FEATURE.md`**:
> * **Bagian 6 (Tambah Route)**: Mendefinisikan konstanta rute di `AppRoutes` (`packages/core`) dan daftarkan di GoRouter `app_router.dart`.
> * **Bagian 8 (Tambah L10n Jika Ada Teks Baru)**: Anda **WAJIB** melokalkan seluruh string/teks UI (Bahasa Indonesia & Bahasa Inggris) di file `.arb` (`packages/core/lib/src/l10n/app_id.arb` & `app_en.arb`) lalu jalankan `flutter gen-l10n` di folder `packages/core`. Dilarang melakukan hardcode teks pada file UI!
> * **Bagian 10 (Tambah Test)**: Anda **WAJIB** membuat minimal test suite (Widget & Unit) untuk memastikan layar dan notifiers berjalan dengan benar sesuai standar cakupan test.
> * **Bagian 11 & 12 (Verifikasi & Checklist PR)**: Jalankan `dart analyze` dan `flutter test` dari root sebelum menyatakan pekerjaan selesai.

Pekerjaan bagian akhir ini berfokus pada perancangan antarmuka pengguna (UI) yang sangat menawan, intuitif, premium, serta integrasi navigasi menggunakan GoRouter dan integrasi menu di Halaman Beranda.

---

## 🛠️ Langkah-Langkah yang Harus Dikerjakan

### 1. Desain Halaman Daftar Quotes (`QuotesScreen`)
Buat file `apps/main/lib/features/quotes/presentation/screens/quotes_screen.dart`:
* **Desain Header Premium**: Gunakan `SliverAppBar` dengan efek glassmorphism atau gradasi warna lembut yang berpadu dengan tema gelap/terang.
* **Status Indikator Offline**:
  * Tampilkan banner kecil "Bekerja Offline" jika koneksi terputus.
  * Setiap kartu quote harus memiliki indikator visual status sinkronisasi:
    * Jika `isSynced == false` dan `syncAction == 'create'`, tampilkan ikon awan-loading (cloud syncing) atau tulisan "Menunggu Sinkronisasi".
    * Jika `isSynced == false` dan `syncAction == 'update'`, tampilkan ikon "Mengedit Offline".
    * Jika data sudah sinkron, tampilkan ikon awan-centang (cloud done) yang halus.
* **Fitur Pencarian & Pengurutan**:
  * Tambahkan search bar di bagian atas list untuk menyaring data berdasarkan teks kutipan atau penulis.
  * Tambahkan opsi filter cepat (All, Active, Inactive) serta pengurutan (A-Z, terbaru).
* **Pull to Refresh**: Integrasikan `RefreshIndicator` untuk memicu pembersihan cache dan sinkronisasi manual (`ref.read(quotesNotifierProvider.notifier).syncData()`).
* **Interaksi Swipe & Detail**:
  * Pengguna bisa mengetuk kartu untuk mengedit.
  * Pengguna bisa mengusap kartu (Dismissible) atau menekan tombol hapus dengan konfirmasi dialog untuk menghapus kutipan.

### 2. Desain Formulir Tambah/Edit (`QuoteFormScreen`)
Buat file `apps/main/lib/features/quotes/presentation/screens/quote_form_screen.dart`:
* Gunakan form yang sama untuk Tambah dan Edit (kirim parameter opsional `localId` melalui constructor/route).
* Jika parameter `localId` dikirim, muat data quote dari local database dan isi form secara otomatis.
* Gunakan widget `AppTextField` bawaan `packages/core` dengan validasi:
  * Isi kutipan minimal 10 karakter.
  * Penulis/tokoh tidak boleh kosong.
* Sediakan switch untuk mengaktifkan/menonaktifkan kutipan (`isActive`).
* Efek transisi loading: Gunakan `LoadingOverlay` bawaan proyek agar layar membeku dengan animasi loading yang halus saat proses penyimpanan lokal selesai.

### 3. Integrasi Navigasi GoRouter
* Tambahkan rute berikut ke file `apps/main/lib/router/app_router.dart`:
  * `/quotes` -> mengarah ke `QuotesScreen`.
  * `/quotes/create` -> mengarah ke `QuoteFormScreen` tanpa ID.
  * `/quotes/edit/:localId` -> mengarah ke `QuoteFormScreen` dengan ID lokal.
* Pastikan konstanta path didefinisikan secara rapi di file `packages/core/lib/src/router/app_routes.dart`.

### 4. Integrasi Menu Beranda
Buka file `apps/main/lib/features/home/presentation/widgets/home_menu_grid.dart` dan `home_screen.dart`:
* Ganti salah satu placeholder menu (misalnya `'Menu 01'`) menjadi menu **'Quotes'** dengan ikon `Icons.format_quote_rounded` dan warna Indigo/Premium.
* Hubungkan tap event menu tersebut untuk menavigasikan pengguna ke rute `/quotes` via `context.push(AppRoutes.quotes)`.

---

## 🔍 Hasil Yang Diharapkan
1. Aplikasi berjalan mulus dengan UI CRUD Quotes yang terlihat modern, clean, dan premium.
2. Seluruh string teks UI telah dilokalkan di file `.arb` Bahasa Inggris & Bahasa Indonesia, serta di-generate secara sukses.
3. Minimal test suite (unit & widget tests) telah dibuat di `apps/main/test/features/quotes/` dan lulus semua pengujian (`flutter test`).
4. Logika offline-first terbukti berjalan: mematikan koneksi internet, membuat quote baru -> quote tampil langsung di list dengan status "Offline/Syncing". Mengaktifkan internet kembali -> status quote otomatis berubah menjadi "Synced" (Awan-Centang).
