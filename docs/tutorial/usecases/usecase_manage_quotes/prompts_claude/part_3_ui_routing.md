# 📋 Bagian 3: UI Design, Routing, L10n & Integrasi Dashboard

> [!IMPORTANT]
> **MANDATORY / WAJIB SEBELUM MEMULAI:**
> Sebelum Anda mengimplementasikan antarmuka UI, navigasi, dan melokalkan teks, Anda **HARUS** membaca dan mematuhi panduan pada **`docs/ADD_FEATURE.md`**:
> * **Bagian 6 (Tambah Route)**: Mendefinisikan konstanta rute di `AppRoutes` (`packages/core`) dan daftarkan di GoRouter `app_router.dart`.
> * **Bagian 7 (Tambah Navigasi Dari UI)**: Gunakan `context.push()` untuk navigasi stack dan `context.go()` untuk replace.
> * **Bagian 8 (Tambah L10n Jika Ada Teks Baru)**: Anda **WAJIB** melokalkan seluruh string/teks UI (Bahasa Indonesia & Bahasa Inggris) di file `.arb` (`packages/core/lib/src/l10n/app_id.arb` & `app_en.arb`) lalu jalankan `flutter gen-l10n` di folder `packages/core`. **Dilarang melakukan hardcode teks pada file UI!**
> * **Bagian 10 (Tambah Test)**: Anda **WAJIB** membuat minimal test suite (Widget & Unit) untuk memastikan layar dan notifiers berjalan dengan benar sesuai standar cakupan test.
> * **Bagian 11 & 12 (Verifikasi & Checklist PR)**: Jalankan `dart analyze` dan `flutter test` dari root sebelum menyatakan pekerjaan selesai.
>
> Baca juga **`CLAUDE.md`** di root project untuk memahami konvensi navigasi GoRouter, error handling (`AsyncValue.when`), dan fitur UX yang tersedia.

Pekerjaan bagian akhir ini berfokus pada perancangan antarmuka pengguna (UI) yang menawan, intuitif, dan premium, serta integrasi navigasi menggunakan GoRouter dan integrasi menu di Halaman Beranda.

---

## 🛠️ Langkah-Langkah yang Harus Dikerjakan

### 1. Desain Halaman Daftar Quotes (`QuotesScreen`)
Buat file `apps/main/lib/features/quotes/presentation/screens/quotes_screen.dart`:

**Desain Header Premium**:
* Gunakan `SliverAppBar` dengan efek gradasi warna lembut yang berpadu dengan tema gelap/terang.
* Judul halaman harus dilokalkan (bukan hardcode).

**Status Indikator Offline**:
* Tampilkan banner kecil "Bekerja Offline" jika koneksi terputus.
* Setiap kartu quote harus memiliki indikator visual status sinkronisasi:
  * Jika `isSynced == false` dan `syncAction == 'create'`: tampilkan ikon awan-loading (cloud_upload) atau tulisan lokal "Menunggu Sinkronisasi".
  * Jika `isSynced == false` dan `syncAction == 'update'`: tampilkan ikon "Mengedit Offline" (cloud_sync).
  * Jika `isSynced == false` dan `syncAction == 'delete'`: item ini **tidak ditampilkan** di list (sudah di-filter di local data source).
  * Jika data sudah sinkron (`isSynced == true`): tampilkan ikon awan-centang (cloud_done) yang halus.

**Fitur Pencarian & Pengurutan**:
* Tambahkan search bar di bagian atas list untuk menyaring data berdasarkan teks kutipan atau penulis.
* Tambahkan opsi filter cepat (All, Active, Inactive) serta pengurutan (A-Z Author, Terbaru).
* Filter dan sort dilakukan secara lokal terhadap data yang sudah dimuat di state.

**Pull to Refresh**:
* Integrasikan `RefreshIndicator` untuk memicu sinkronisasi manual:
  ```dart
  ref.read(quotesNotifierProvider.notifier).refreshQuotes()
  ```

**Interaksi Kartu Quote**:
* Setiap kartu menampilkan: ikon kutipan, teks kutipan (italic), nama penulis, sumber (jika ada), status aktif/nonaktif, dan indikator sinkronisasi.
* Pengguna bisa mengetuk kartu untuk **mengedit** (navigasi ke form edit).
* Pengguna bisa mengusap kartu (`Dismissible`) atau menekan tombol hapus dengan **konfirmasi dialog** untuk menghapus kutipan.
* Saat menghapus, tampilkan dialog konfirmasi: "Apakah Anda yakin ingin menghapus kutipan ini?" dengan opsi "Batal" dan "Hapus".

**Empty State & Error State**:
* Jika belum ada data: tampilkan ilustrasi/ikon menarik dengan teks "Belum ada kutipan. Mulai tambahkan inspirasi Anda!".
* Jika error: tampilkan pesan error dengan tombol "Coba Lagi" menggunakan pola `AsyncValue.when()`.

**FAB (Floating Action Button)**:
* FAB untuk navigasi ke halaman tambah quote baru.
* Gunakan ikon `Icons.add_rounded` dengan label "Tambah Kutipan".
* Navigasi ke rute `/quotes/create` via `context.push()`.

### 2. Desain Formulir Tambah/Edit (`QuoteFormScreen`)
Buat file `apps/main/lib/features/quotes/presentation/screens/quote_form_screen.dart`:

**Form Unified (Tambah & Edit)**:
* Gunakan form yang sama untuk Tambah dan Edit.
* Jika parameter `localId` dikirim via route, muat data quote dari local database dan isi form secara otomatis (mode Edit).
* Jika `localId` tidak dikirim, form kosong untuk mode Tambah.

**Field Input & Validasi**:
* **Isi Kutipan** (TextFormField, multiline):
  * Label: lokal "Isi Kutipan"
  * Validasi: minimal 5 karakter (sesuai API), tidak boleh kosong
* **Penulis** (TextFormField):
  * Label: lokal "Nama Penulis / Tokoh"
  * Validasi: tidak boleh kosong, maksimal 255 karakter
  * Prefix icon: `Icons.person_outline_rounded`
* **Sumber** (TextFormField, opsional):
  * Label: lokal "Sumber (opsional)"
  * Hint: "Contoh: Buku, Pidato, Wawancara"
  * Validasi: maksimal 255 karakter (tidak wajib)
* **Status Aktif** (Switch):
  * Toggle untuk mengaktifkan/menonaktifkan kutipan (`isActive`).
  * Default: aktif (true) untuk mode tambah.

**Aksi Simpan**:
* Saat mode Tambah: panggil `quotesNotifier.addQuote(...)`.
* Saat mode Edit: panggil `quotesNotifier.updateQuote(...)`.
* Setelah berhasil simpan: tampilkan SnackBar sukses dan `context.pop()` kembali ke list.
* Jika gagal: tampilkan SnackBar error.
* Gunakan `LoadingOverlay` bawaan proyek atau mekanisme loading yang elegan saat proses penyimpanan.

**Judul AppBar**:
* Mode Tambah: lokal "Buat Kutipan Baru"
* Mode Edit: lokal "Edit Kutipan"

### 3. Integrasi Navigasi GoRouter

**Tambahkan konstanta path** di `packages/core/lib/src/router/app_routes.dart`:
```dart
abstract final class AppRoutes {
  // ... rute yang sudah ada ...
  
  static const String quotes = '/quotes';
  static const String createQuote = '/quotes/create';
  static const String editQuote = '/quotes/edit'; // akan ditambah /:localId
}
```

**Daftarkan rute** di `apps/main/lib/router/app_router.dart`:
```dart
// Rute manajemen quotes
GoRoute(
  path: AppRoutes.quotes,
  builder: (context, state) => const QuotesScreen(),
),
GoRoute(
  path: '${AppRoutes.createQuote}',
  builder: (context, state) => const QuoteFormScreen(),
),
GoRoute(
  path: '${AppRoutes.editQuote}/:localId',
  builder: (context, state) {
    final localId = int.parse(state.pathParameters['localId']!);
    return QuoteFormScreen(localId: localId);
  },
),
```

### 4. Integrasi Menu Beranda
Buka file-file home screen dan menu grid di `apps/main/lib/features/home/presentation/`:

* Ganti salah satu placeholder menu (misalnya `'Menu 01'`) menjadi **'Kutipan'** (atau gunakan key l10n) dengan ikon `Icons.format_quote_rounded` dan warna Indigo/Premium.
* Hubungkan tap event menu tersebut untuk menavigasikan pengguna ke rute `/quotes` via `context.push(AppRoutes.quotes)`.

### 5. Lokalisasi (L10n)
Tambahkan semua string UI baru ke file ARB:

**`packages/core/lib/src/l10n/app_id.arb`** (Bahasa Indonesia):
```json
{
  "quotesTitle": "Manajemen Kutipan",
  "quotesEmpty": "Belum ada kutipan. Mulai tambahkan inspirasi Anda!",
  "quotesAdd": "Tambah Kutipan",
  "quotesCreate": "Buat Kutipan Baru",
  "quotesEdit": "Edit Kutipan",
  "quotesDelete": "Hapus Kutipan",
  "quotesDeleteConfirm": "Apakah Anda yakin ingin menghapus kutipan ini?",
  "quotesDeleteSuccess": "Kutipan berhasil dihapus",
  "quotesSaveSuccess": "Kutipan berhasil disimpan",
  "quotesUpdateSuccess": "Kutipan berhasil diperbarui",
  "quotesTextLabel": "Isi Kutipan",
  "quotesTextHint": "Tulis isi kutipan di sini...",
  "quotesTextValidation": "Isi kutipan minimal 5 karakter",
  "quotesAuthorLabel": "Nama Penulis / Tokoh",
  "quotesAuthorHint": "Contoh: Ir. Soekarno",
  "quotesAuthorValidation": "Nama penulis wajib diisi",
  "quotesSourceLabel": "Sumber (opsional)",
  "quotesSourceHint": "Contoh: Buku, Pidato, Wawancara",
  "quotesIsActive": "Status Aktif",
  "quotesMenuLabel": "Kutipan",
  "quotesSyncPending": "Menunggu Sinkronisasi",
  "quotesSyncOfflineEdit": "Diedit Offline",
  "quotesSynced": "Tersinkronisasi",
  "quotesWorkingOffline": "Bekerja Offline",
  "quotesFilterAll": "Semua",
  "quotesFilterActive": "Aktif",
  "quotesFilterInactive": "Nonaktif",
  "quotesSortAZ": "A-Z Penulis",
  "quotesSortNewest": "Terbaru",
  "quotesSearchHint": "Cari kutipan atau penulis...",
  "quotesRetry": "Coba Lagi",
  "quotesLoadError": "Gagal Memuat Data",
  "quotesSave": "Simpan Kutipan",
  "quotesCancel": "Batal",
  "quotesConfirmDelete": "Hapus"
}
```

**`packages/core/lib/src/l10n/app_en.arb`** (Bahasa Inggris):
```json
{
  "quotesTitle": "Quote Management",
  "quotesEmpty": "No quotes yet. Start adding your inspirations!",
  "quotesAdd": "Add Quote",
  "quotesCreate": "Create New Quote",
  "quotesEdit": "Edit Quote",
  "quotesDelete": "Delete Quote",
  "quotesDeleteConfirm": "Are you sure you want to delete this quote?",
  "quotesDeleteSuccess": "Quote deleted successfully",
  "quotesSaveSuccess": "Quote saved successfully",
  "quotesUpdateSuccess": "Quote updated successfully",
  "quotesTextLabel": "Quote Text",
  "quotesTextHint": "Write your quote here...",
  "quotesTextValidation": "Quote text must be at least 5 characters",
  "quotesAuthorLabel": "Author / Figure Name",
  "quotesAuthorHint": "Example: Albert Einstein",
  "quotesAuthorValidation": "Author name is required",
  "quotesSourceLabel": "Source (optional)",
  "quotesSourceHint": "Example: Book, Speech, Interview",
  "quotesIsActive": "Active Status",
  "quotesMenuLabel": "Quotes",
  "quotesSyncPending": "Pending Sync",
  "quotesSyncOfflineEdit": "Edited Offline",
  "quotesSynced": "Synced",
  "quotesWorkingOffline": "Working Offline",
  "quotesFilterAll": "All",
  "quotesFilterActive": "Active",
  "quotesFilterInactive": "Inactive",
  "quotesSortAZ": "A-Z Author",
  "quotesSortNewest": "Newest",
  "quotesSearchHint": "Search quotes or authors...",
  "quotesRetry": "Retry",
  "quotesLoadError": "Failed to Load Data",
  "quotesSave": "Save Quote",
  "quotesCancel": "Cancel",
  "quotesConfirmDelete": "Delete"
}
```

Setelah menambahkan key di kedua file ARB, generate ulang localization:
```bash
cd packages/core
flutter gen-l10n
```

### 6. Buat Minimal Test Suite
Buat file test di `apps/main/test/features/quotes/`:

**Unit Tests**:
* `quote_entity_test.dart` — Test equality, copyWith, properti required.
* `quote_model_test.dart` — Test `fromJson`, `toJson`, parsing null-safe.
* `quotes_notifier_test.dart` — Test state loading, success, error, optimistic update.

**Widget Tests**:
* `quotes_screen_test.dart` — Smoke test: widget muncul, loading state, empty state.
* `quote_form_screen_test.dart` — Smoke test: form tampil, validasi field, mode tambah vs edit.

Gunakan pola mocking yang umum di project (Mockito atau manual mock). Minimal test sesuai tabel risiko di `docs/ADD_FEATURE.md` Bagian 10.

### 7. Verifikasi Akhir
Jalankan perintah berikut dari root repo untuk memastikan semuanya bersih:

```bash
# Generate localization
cd packages/core && flutter gen-l10n && cd ../..

# Generate code
dart run melos run codegen

# Analisis statis
dart run melos run analyze

# Jalankan test
dart run melos run test

# Jalankan aplikasi untuk verifikasi manual
dart run melos run dev
```

---

## 🔍 Hasil Yang Diharapkan
1. Aplikasi berjalan mulus dengan UI CRUD Quotes yang terlihat modern, clean, dan premium.
2. Navigasi dari menu beranda ke halaman daftar quotes, form tambah, dan form edit berjalan sempurna.
3. Seluruh string teks UI telah dilokalkan di file `.arb` Bahasa Inggris & Bahasa Indonesia, serta di-generate secara sukses.
4. Minimal test suite (unit & widget tests) telah dibuat di `apps/main/test/features/quotes/` dan lulus semua pengujian (`flutter test`).
5. Logika offline-first terbukti berjalan:
   * Mematikan koneksi internet → membuat quote baru → quote tampil langsung di list dengan status "Menunggu Sinkronisasi".
   * Mengaktifkan internet kembali → tarik refresh → status quote otomatis berubah menjadi "Tersinkronisasi" (awan-centang).
6. `dart analyze` bersih tanpa error.
7. `flutter test` lulus semua test.
