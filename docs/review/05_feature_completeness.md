# Audit Kelengkapan Fitur Generic SaaS Mobile

Sebuah *starter project* untuk aplikasi SaaS (Software-as-a-Service) mobile modern diharapkan menyediakan fungsionalitas generik yang lengkap sejak awal (seperti sistem login, verifikasi email, notifikasi push, penanganan luring, serta dukungan multi-tenant). Dokumen ini mengevaluasi status kelengkapan fitur-fitur tersebut dalam repositori ini.

---

## Tabel Kelengkapan Fitur

Status Kode:
- **`✅ Lengkap`**: Berfungsi penuh menggunakan logika riil.
- **`⚠️ Sebagian`**: Baru berupa antarmuka, menggunakan simulasi (*fake/stub*), atau diimplementasikan secara parsial.
- **`❌ Belum Ada`**: Tidak ada dependensi pustaka maupun kode implementasi sama sekali.
- **`🔲 Tidak Relevan`**: Tidak diperlukan untuk lingkup proyek ini.

### A. Autentikasi & User

| Fitur | Status | Catatan / Lokasi File |
| :--- | :---: | :--- |
| **Login (Email/Password)** | `⚠️ Sebagian` | Logika diatur di `authNotifierProvider` dengan `FakeAuthRepository` di mode debug `apps/main`. Belum terhubung ke endpoint API riil. |
| **Register** | `⚠️ Sebagian` | Panggilan murni simulasi ke REST API lokal di `AuthRemoteDataSource`. |
| **Forgot Password** | `❌ Belum Ada` | Tidak ada rute, tampilan layar, maupun fungsi API-nya. |
| **Email Verification** | `❌ Belum Ada` | Alur verifikasi setelah pendaftaran belum diakomodasi. |
| **Social Login (Google)** | `❌ Belum Ada` | Tidak ada integrasi Google Sign-In bawaan. |
| **Biometric Login** | `❌ Belum Ada` | Tidak ada paket `local_auth` untuk pemindaian sidik jari/wajah. |
| **Edit Profile** | `❌ Belum Ada` | Tombol edit profil di HomeScreen hanya menampilkan SnackBar stub "Edit profil belum tersedia". |
| **Ubah Password** | `❌ Belum Ada` | Fitur pengubahan kata sandi dari dalam pengaturan belum ada. |
| **Upload Foto Profil** | `❌ Belum Ada` | Tidak ada image picker maupun endpoint upload media. |
| **Logout** | `✅ Lengkap` | Mengosongkan data user & token di local secure storage, mereset state, dan mengarahkan kembali ke `/login`. |
| **Auto-Logout Expired** | `⚠️ Sebagian` | `DioClient` menangkap status 401 dan melemparkan `UnauthorizedException`, namun tidak ada penanganan otomatis untuk melogout pengguna secara paksa di tingkat UI global. |

### B. Multi-tenancy (SaaS Tenant)

| Fitur | Status | Catatan / Lokasi File |
| :--- | :---: | :--- |
| **Tenant Selection / Switcher** | `❌ Belum Ada` | Belum ada UI untuk memilih organisasi atau tenant ID. |
| **Tenant Context per Request** | `⚠️ Sebagian` | Struktur folder monorepo memisahkan aset aplikasi secara fisik, namun pengiriman `tenant-id` atau subdomain dinamis di header HTTP `DioClient` belum ada. |
| **Tenant-Aware Routing** | `❌ Belum Ada` | Rute navigasi tidak membawa pengidentifikasi tenant dalam path rute. |
| **Onboarding Tenant Baru** | `❌ Belum Ada` | Pendaftaran akun tenant/organisasi baru dari dalam aplikasi belum diakomodasi. |

### C. Notifikasi (Push Notifications)

| Fitur | Status | Catatan / Lokasi File |
| :--- | :---: | :--- |
| **FCM Setup (Android/iOS)** | `❌ Belum Ada` | Tidak ada SDK Firebase Messaging maupun konfigurasi berkas Google Services. |
| **Foreground Notification** | `❌ Belum Ada` | Penanganan notifikasi lokal saat aplikasi terbuka belum diatur. |
| **Background Notification** | `❌ Belum Ada` | Pemicu notifikasi saat aplikasi ditutup belum terimplementasi. |
| **Deep Link dari Notifikasi** | `❌ Belum Ada` | Logika parsing rute dari payload notifikasi kosong. |
| **Notification History / Inbox** | `❌ Belum Ada` | Layar `NotificationsScreen` di `features_shared` murni bertuliskan "coming soon". |
| **Notification Preferences** | `❌ Belum Ada` | Menu untuk mengaktifkan/mematikan jenis notifikasi belum ada. |

### D. Offline & Data

| Fitur | Status | Catatan / Lokasi File |
| :--- | :---: | :--- |
| **Deteksi Koneksi Internet** | `❌ Belum Ada` | Tidak ada pemantauan status koneksi (seperti pustaka `connectivity_plus`). |
| **Cache Data untuk Offline** | `❌ Belum Ada` | Tidak ada database lokal seperti Isar/Hive. Penyimpanan SharedPreferences hanya merekam pengaturan preferensi aplikasi dasar. |
| **Retry saat Kembali Online** | `❌ Belum Ada` | Logika antrean *offline write* untuk disinkronkan kembali belum tersedia. |
| **Loading State Konsisten** | `✅ Lengkap` | Terdistribusi rapi melalui riverpod `AsyncValue` dan `LoadingOverlay` bawaan `core`. |
| **Empty State Konsisten** | `⚠️ Sebagian` | Contoh layar kosong tersedia di UI Gallery, namun komponen global belum distandarisasi di paket `core`. |
| **Error State Konsisten** | `✅ Lengkap` | Dio Client memetakan kesalahan jaringan ke dalam kelas `AppException` yang dikelola secara terpusat. |
| **Pull-to-Refresh** | `⚠️ Sebagian` | Terdapat demo di UI Gallery, namun implementasi riil pada pemuatan data data-source belum dipasang. |
| **Infinite Scroll / Pagination** | `⚠️ Sebagian` | Ada implementasi manual di UI Gallery (kategori lists), belum didekstrak ke komponen helper global. |

### E. UI & UX Generic

| Fitur | Status | Catatan / Lokasi File |
| :--- | :---: | :--- |
| **Splash Screen** | `❌ Belum Ada` | Boot langsung melompati frame callback ke login tanpa adanya layar splash branding. |
| **Onboarding Screens** | `❌ Belum Ada` | Halaman intro/pengenalan aplikasi pertama kali belum tersedia. |
| **Bottom Navigation** | `✅ Lengkap` | Terpasang rapi di home screen utama main app. |
| **Drawer / Side Menu** | `❌ Belum Ada` | Navigasi samping opsional belum dipasang. |
| **Dark Mode** | `✅ Lengkap` | Sinkronisasi tema terang/gelap real-time tersimpan persisten via notifier. |
| **Loading Skeleton (Shimmer)** | `✅ Lengkap` | Shimmer premium terintegrasi manual via `ShaderMask` di UI Gallery tanpa dependensi eksternal. |
| **Toast / Snackbar** | `✅ Lengkap` | Snackbar dinamis sudah terintegrasi di presentasi fitur. |
| **Konfirmasi Dialog** | `✅ Lengkap` | Contoh demo popup dialog terintegrasi dengan baik di UI Gallery. |
| **Image Picker & Preview** | `❌ Belum Ada` | Tidak ada interaksi galeri/kamera untuk pemilihan gambar. |
| **In-App Update Prompt** | `❌ Belum Ada` | Notifikasi paksa pembaruan aplikasi belum tersedia. |

### F. Developer Experience (DX)

| Fitur | Status | Catatan / Lokasi File |
| :--- | :---: | :--- |
| **Flavors (Multi-App)** | `✅ Lengkap` | Terintegrasi sempurna lewat skrip Melos dan konfigurasi debugging VS Code. |
| **Crash Reporting** | `❌ Belum Ada` | Crashlytics belum dikonfigurasi. |
| **Analytics Setup** | `❌ Belum Ada` | Firebase Analytics belum dipasang. |
| **Performance Monitoring** | `❌ Belum Ada` | Pemantauan kinerja memori/CPU di latar belakang belum ada. |
| **Unit Tests** | `✅ Lengkap` | Tersedia berkas tes unit yang representatif untuk logika bisnis inti. |
| **Widget Tests** | `✅ Lengkap` | Tersedia berkas widget test untuk memverifikasi fungsionalitas UI settings. |
| **Integration Tests** | `❌ Belum Ada` | Pengujian end-to-end terotomatisasi belum dibuat. |

---

## Kesimpulan & Rekomendasi Fitur Prioritas

> [!WARNING]
> **Skor Akhir Kelengkapan Fitur Generic: 5.0 / 10**
> 
> **Justifikasi**:
> Proyek ini memiliki pondasi developer experience (skrip Melos workspace, pengujian unit/widget, multi-app flavor setup) dan UI/UX generik (Material 3 theme, loading overlay, shimmer) yang sangat baik dan premium. Namun, status fungsionalitas dasarnya sebagian besar masih bersifat **stub/simulasi**, dan ketiadaan fitur krusial penunjang SaaS seperti Firebase Messaging, Database Offline, dan manajemen multi-tenant riil membuat developer harus membangun banyak fitur dasar dari awal.

### 💡 Rekomendasi Fitur Paling Mendesak untuk Ditambahkan:

1. **Integrasi Firebase Riil**: Pasang Firebase SDK untuk mengaktifkan Push Notifications (FCM), Crashlytics (Pelaporan error produksi), dan Analytics (Pelacakan pengguna).
2. **Penyediaan Database Offline Terstruktur**: Tambahkan pustaka **Isar** atau **Drift** pada paket `core` sebagai modul caching data offline-first terintegrasi.
3. **Penyempurnaan Autentikasi**: Lengkapi sistem pendaftaran dengan verifikasi email, fitur lupa kata sandi (*Forgot Password*), dan integrasi autentikasi biometrik (*Local Authentication*).
