# 📋 Bagian 2: State Management & Auto-Synchronization Logic

> [!IMPORTANT]
> **MANDATORY / WAJIB SEBELUM MEMULAI:**
> Sebelum menulis state management dan logika sinkronisasi, Anda **HARUS** menganalisis kembali **`docs/ADD_FEATURE.md`** khususnya pada **Bagian 2 (Pilih Bentuk Struktur)** dan **Bagian 10 (Tambah Test)**. 
> Semua notifier dan providers **WAJIB** menggunakan **Riverpod Generator** (`@riverpod` annotation) seperti yang didefinisikan dalam panduan arsitektur workspace. Pastikan berkas generator (`*.g.dart`) digenerate menggunakan build_runner/Melos.

Pekerjaan bagian kedua ini berfokus pada **State Management menggunakan Riverpod** serta logika sinkronisasi data offline-to-online otomatis. Ketika terjadi perubahan status koneksi (atau saat aplikasi dibuka kembali), aplikasi harus memindai SQLite lokal untuk mendeteksi data yang belum tersinkronisasi (`isSynced = false`), lalu mengirimkannya ke server secara bertahap sesuai aksi yang tertunda ('create', 'update', 'delete').

---

## 🛠️ Langkah-Langkah yang Harus Dikerjakan

### 1. Registrasi Providers di Presentation Layer
Buat file `apps/main/lib/features/quotes/presentation/quotes_providers.dart`:
* Deklarasikan provider untuk DataSource, Repository, dan UseCases menggunakan Riverpod Generator.
* Contoh cara mendapatkan instance `AppDatabase` dari core package:
  ```dart
  @riverpod
  QuotesLocalDataSource quotesLocalDataSource(Ref ref) {
    final db = ref.watch(appDatabaseProvider);
    return QuotesLocalDataSource(db);
  }
  ```

### 2. Implementasi Notifier Utama (`QuotesNotifier`)
Buat kelas `QuotesNotifier` di `apps/main/lib/features/quotes/presentation/quotes_notifier.dart` yang meng-extend `_$QuotesNotifier` (generated):
* **`build()`**: 
  1. Jalankan sinkronisasi data latar belakang terlebih dahulu secara asinkron (panggil method `syncData()`).
  2. Ambil data quotes dari lokal SQLite database sebagai source of truth utama.
* **`syncData()`**:
  Logika sinkronisasi offline-first otomatis:
  1. Cek apakah server backend dapat dihubungi dengan memanggil endpoint `/v1/health` menggunakan `Dio`.
  2. Jika server aktif, cari semua data di SQLite lokal yang memiliki bendera `isSynced = false`.
  3. Lakukan sinkronisasi ke server bertahap berdasarkan `syncAction`:
     * **'create'**: Kirim `POST /v1/quotes` dengan isi teks dan author. Setelah berhasil, perbarui kolom `id` dengan ID yang didapat dari server, lalu set `isSynced = true` dan `syncAction = null`.
     * **'update'**: Kirim `PUT /v1/quotes/{id}`. Setelah sukses, set `isSynced = true` dan `syncAction = null`.
     * **'delete'**: Kirim `DELETE /v1/quotes/{id}`. Setelah sukses, hapus baris tersebut dari SQLite lokal.
  4. Jika terjadi error di salah satu sinkronisasi (misal validasi server gagal), tandai atau abaikan agar tidak terjadi infinite loop.
  5. Setelah sinkronisasi selesai, lakukan fetch data terbaru dari server (jika online) untuk memperbarui data SQLite lokal, lalu muat ulang state list UI.

### 3. Aksi CRUD di Notifier (Optimistic UI Update)
Tambahkan method berikut di `QuotesNotifier` untuk dipanggil dari UI:
* **`addQuote(text, author, source, isActive)`**:
  1. Lakukan *Optimistic Update*: Buat data `QuoteEntity` dengan ID temporer, simpan ke SQLite lokal dengan status `isSynced = false` dan `syncAction = 'create'`.
  2. Rebuild state list lokal secara instan agar pengguna dapat melihat quote baru secara langsung tanpa menunggu loading server.
  3. Pemicu Sinkronisasi: Jalankan `syncData()` di background untuk langsung mengirim data ke server.
* **`updateQuote(localId, text, author, source, isActive)`**:
  1. Update data di SQLite lokal secara langsung, set `isSynced = false` dan `syncAction = 'update'`.
  2. Perbarui state list lokal secara instan.
  3. Jalankan `syncData()` di background.
* **`deleteQuote(localId)`**:
  1. Set data lokal ke status `isSynced = false` dan `syncAction = 'delete'` (atau langsung hapus dari SQLite jika data tersebut belum pernah dikirim ke server sebelumnya).
  2. Perbarui state list lokal secara instan.
  3. Jalankan `syncData()` di background.

---

## 🔍 Hasil Yang Diharapkan
1. File `quotes_notifier.dart` berhasil dibuat dan lolos kompilasi generator Riverpod (`codegen`).
2. Logika sinkronisasi tangguh yang mampu menangani transisi offline-to-online secara mulus.
3. State UI selalu tersinkronisasi secara reaktif dengan SQLite lokal sebagai single source of truth.
