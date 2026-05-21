# Contributing Guide

Panduan git workflow dan aturan kontribusi untuk project ini.

---

## Branching Strategy

Project ini menggunakan **simplified GitFlow**:

```
main
 └── develop
      ├── feature/[nama]
      ├── fix/[nama]
      └── hotfix/[nama]
```

| Branch | Fungsi | Branch asal | Merge ke |
|---|---|---|---|
| `main` | Kode production, selalu stable | — | — |
| `develop` | Integrasi, branch kerja utama | `main` | `main` |
| `feature/[nama]` | Fitur baru | `develop` | `develop` |
| `fix/[nama]` | Bug fix | `develop` | `develop` |
| `hotfix/[nama]` | Perbaikan mendesak di production | `main` | `main` + `develop` |

---

## Branch Naming

```bash
feature/auth-login
feature/profile-edit
fix/crash-on-startup
fix/token-expired-not-handled
hotfix/payment-failure
```

Gunakan **kebab-case**, singkat tapi deskriptif. Hindari nama generik seperti `feature/update` atau `fix/bug`. Maksimal **50 karakter** untuk nama branch.

---

## Commit Convention

Project ini menggunakan [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <deskripsi singkat>
```

### Type

| Type | Digunakan untuk |
|---|---|
| `feat` | Fitur baru |
| `fix` | Bug fix |
| `docs` | Perubahan dokumentasi |
| `style` | Format kode, tanpa perubahan logika |
| `refactor` | Refactor tanpa tambah fitur atau fix bug |
| `test` | Tambah atau update test |
| `chore` | Build process, dependency update, tooling |
| `perf` | Peningkatan performa |

### Scope (opsional)

Nama fitur atau package yang diubah: `auth`, `profile`, `core`, `router`, dll.

### Aturan penulisan

- Deskripsi singkat maksimal **72 karakter**
- Gunakan **imperative mood**: `add`, `fix`, `update`, `remove` — bukan `added`, `fixing`
- Tidak diakhiri tanda titik

### Contoh

```bash
feat(auth): add biometric login support
fix(network): handle 401 response on token expiry
docs: update ARCHITECTURE.md with override rule
refactor(core): simplify ResponsiveLayout widget
chore: upgrade riverpod to 2.6.0
```

---

## Workflow

### Mengerjakan fitur baru

```bash
# 1. Pastikan develop up to date
git checkout develop
git pull origin develop

# 2. Buat branch baru
git checkout -b feature/nama-fitur

# 3. Kerjakan, commit secara incremental
git add <file>
git commit -m "feat(scope): deskripsi"

# 4. Rebase ke develop sebelum push (agar tidak konflik)
git fetch origin
git rebase origin/develop

# 5. Push dan buat Pull Request ke develop
git push origin feature/nama-fitur
```

### Hotfix production

```bash
# 1. Branch dari main
git checkout main
git pull origin main
git checkout -b hotfix/nama-fix

# 2. Fix, commit, push
git commit -m "fix(scope): deskripsi"
git push origin hotfix/nama-fix

# 3. Buat PR ke main DAN develop (dua PR terpisah)
```

---

## Pull Request

### Sebelum submit PR

- [ ] Kode sudah di-format (`dart format .`)
- [ ] Tidak ada warning dari analyzer (`dart analyze`)
- [ ] Sudah test manual di device/emulator
- [ ] Commit message mengikuti convention
- [ ] Sudah rebase ke branch target terbaru

### Judul PR

Ikuti format commit convention:

```
feat(auth): add biometric login support
fix(network): handle 401 response on token expiry
```

### Target branch

| Jenis perubahan | Target branch |
|---|---|
| Fitur, fix, refactor | `develop` |
| Hotfix production | `main` |

### Merge policy

- Minimal **1 approval** dari reviewer sebelum merge
- Yang boleh merge: **author PR sendiri** setelah dapat approval, atau **maintainer**
- Gunakan **Squash and Merge** untuk `feature/*` dan `fix/*` ke `develop`
- Gunakan **Merge Commit** untuk `develop` → `main` dan `hotfix/*` → `main`
- Jangan merge PR yang masih memiliki unresolved comment

---

## Catatan tambahan

### Jika ada konflik saat rebase

```bash
# Selesaikan konflik, lalu lanjutkan
git add <file-yang-konflik>
git rebase --continue
```

### Rilis versi (opsional, jika dibutuhkan nanti)

Jika project berkembang ke tahap rilis versioned, buat branch `release/x.x.x` dari `develop`, lakukan finalisasi, lalu merge ke `main` dan `develop`.
