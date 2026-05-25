# 📋 Rencana Aksi & Daftar TODO — Kesiapan Flutter Starter

Dokumen ini adalah **cetak biru teknis** dan **master dashboard** untuk menyempurnakan **Flutter Starter Project** agar siap produksi. Setiap fase dirinci secara modular di folder `docs/sprints/` dan dirancang agar dapat dieksekusi oleh AI Agent secara independen.

---

## 📊 Scorecard Keseluruhan (Sebelum Perbaikan)

| Kategori | Skor | Status |
| :--- | :---: | :---: |
| Kesiapan sebagai Starter | 5.5 / 10 | ⚠️ Cukup |
| AI Agent Friendliness | 7.5 / 10 | ✅ Baik |
| Best Practice Flutter/Riverpod | 6.0 / 10 | ⚠️ Cukup |
| Kelengkapan Dokumentasi | 7.5 / 10 | ✅ Baik |
| Kelengkapan Fitur Generic | 5.0 / 10 | ❌ Kurang |
| **TOTAL RATA-RATA** | **6.3 / 10** | ⚠️ **Perlu Perhatian** |

---

## 🚀 Ringkasan Status Fase

- [ ] [🔥 Fase 00: Temuan Kritis (Segera)](sprints/00_critical.md) — `0/3 Terselesaikan`
- [ ] [🏗️ Fase 01: Sprint 1 — Fondasi & Core](sprints/01_sprint_1.md) — `0/3 Terselesaikan`
- [ ] [🎨 Fase 02: Sprint 2 — UX & Security](sprints/02_sprint_2.md) — `0/3 Terselesaikan`
- [ ] [📝 Fase 03: Dokumentasi & AI Agent](sprints/03_documentation.md) — `0/2 Terselesaikan`
- [ ] [📦 Fase 04: Backlog (Nice-to-Have)](sprints/04_backlog.md) — `0/3 Terselesaikan`

**Total: 0 / 14 Tugas Terselesaikan**

---

## 🔥 Detail Temuan Kritis (Fase 00)

| # | Temuan | Dampak | Estimasi |
| :-: | :--- | :--- | :---: |
| 0.1 | Compile Error widget `RadioGroup` di Settings | Kegagalan kompilasi total `apps/main` | `S` |
| 0.2 | File `AppLocalizations` (L10n) belum di-generate | 37 error analisis statis di seluruh workspace | `S` |
| 0.3 | `.gitignore` tidak mengecualikan file kredensial | Potensi kebocoran `.env`, `google-services.json` | `S` |

→ Detail: [docs/sprints/00_critical.md](sprints/00_critical.md)

---

## 🏗️ Sprint 1 — Fondasi & Core (Fase 01)

| # | Item | Prioritas | Estimasi |
| :-: | :--- | :---: | :---: |
| 1.1 | Migrasi ke Riverpod Generator (`@riverpod`) | Tinggi | `M` |
| 1.2 | Integrasi Riil Firebase Core & FCM | Tinggi | `L` |
| 1.3 | Integrasi Database Offline Isar | Tinggi | `L` |

→ Detail: [docs/sprints/01_sprint_1.md](sprints/01_sprint_1.md)

---

## 🎨 Sprint 2 — UX & Security (Fase 02)

| # | Item | Prioritas | Estimasi |
| :-: | :--- | :---: | :---: |
| 2.1 | Auto-Refresh Token (401 Interceptor) | Tinggi | `M` |
| 2.2 | Premium Splash Screen & Onboarding UI | Sedang | `M` |
| 2.3 | Autentikasi Biometrik (Sidik Jari/Wajah) | Sedang | `M` |

→ Detail: [docs/sprints/02_sprint_2.md](sprints/02_sprint_2.md)

---

## 📝 Dokumentasi & AI Agent (Fase 03)

| # | Item | Prioritas | Estimasi |
| :-: | :--- | :---: | :---: |
| 3.1 | Buat `CLAUDE.md` — Panduan Instan AI Agent | Tinggi | `S` |
| 3.2 | Buat `docs/firebase-setup.md` — Panduan Firebase | Sedang | `S` |

→ Detail: [docs/sprints/03_documentation.md](sprints/03_documentation.md)

---

## 📦 Backlog — Nice-to-Have (Fase 04)

| # | Item | Prioritas | Estimasi |
| :-: | :--- | :---: | :---: |
| 4.1 | Mason CLI Bricks — Otomasi Boilerplate Fitur | Rendah | `M` |
| 4.2 | Firebase Crashlytics & Performance Monitoring | Rendah | `M` |
| 4.3 | Network Certificate Pinning | Rendah | `L` |

→ Detail: [docs/sprints/04_backlog.md](sprints/04_backlog.md)

---

## 📐 Estimasi Total Effort

| Skala | Arti | Jumlah Tugas |
| :---: | :--- | :---: |
| **S** | < 1 hari | 5 tugas |
| **M** | 1-3 hari | 6 tugas |
| **L** | 3-7 hari | 3 tugas |

**Estimasi total pengerjaan: ~3 Minggu Kerja Efektif (Full-time Development)**

---

## 🛠️ Panduan Eksekusi untuk AI Agent

### Urutan Kerja
1. Buka berkas [🔥 Fase 00: Temuan Kritis](sprints/00_critical.md).
2. Kerjakan tugas **satu per satu dari atas ke bawah** di dalam file sprint tersebut.
3. Untuk setiap tugas, ikuti langkah eksekusi dan jalankan verifikasi yang tercantum.
4. Setelah satu tugas selesai dan terverifikasi sukses:
   - Ubah status `[ ]` menjadi `[x]` di berkas detail fase tersebut.
   - Perbarui counter status di master dashboard ini.
5. **Jangan berpindah ke Sprint berikutnya** sebelum Fase sebelumnya terselesaikan 100%.

### Perintah Verifikasi Global
```bash
# Setelah menyelesaikan satu fase, jalankan verifikasi menyeluruh:
dart run melos run analyze    # Harus 0 error
dart run melos run test       # Harus 0 failure
```

### Catatan Penting
- **Fase 03 (Dokumentasi)** bisa dikerjakan paralel dengan Sprint 1 atau Sprint 2.
- **Fase 04 (Backlog)** bersifat opsional dan dapat dikerjakan sesuai kebutuhan bisnis.
- Setiap tugas memiliki **Batasan Arsitektur** yang wajib dipatuhi untuk menjaga integritas monorepo.
- Gunakan **relative import** untuk file di dalam package yang sama, dan **barrel import** untuk akses lintas package.

---

## 📚 Referensi Dokumen Review

Dokumen-dokumen review yang menjadi dasar penyusunan rencana aksi ini tersedia di `docs/review/`:

| Dokumen | Deskripsi |
| :--- | :--- |
| [00_SUMMARY.md](review/00_SUMMARY.md) | Ringkasan Eksekutif & Scorecard |
| [01_starter_readiness.md](review/01_starter_readiness.md) | Analisis Kesiapan Starter |
| [02_ai_agent_friendliness.md](review/02_ai_agent_friendliness.md) | Analisis Keramahan AI Agent |
| [03_best_practice.md](review/03_best_practice.md) | Analisis Praktik Terbaik Flutter/Riverpod |
| [04_documentation_completeness.md](review/04_documentation_completeness.md) | Evaluasi Kelengkapan Dokumentasi |
| [05_feature_completeness.md](review/05_feature_completeness.md) | Evaluasi Kelengkapan Fitur |
| [06_priority_areas.md](review/06_priority_areas.md) | Detail Temuan & Area Prioritas |
| [07_action_plan.md](review/07_action_plan.md) | Peta Jalan Taktis & Roadmap |
