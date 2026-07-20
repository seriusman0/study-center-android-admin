# 📋 PRD — Study Center Admin Android App
## Product Requirements Document (Versi 2.0 — Full Feature Parity)

> **Proyek:** `study_center_admin` (Flutter)
> **Backend:** `study-center-nias` (Laravel) — `http://100.67.79.94` via Tailscale
> **Tanggal:** Juli 2026
> **Status:** In Development

## 0. Log Perubahan (Changelog)
- **[Update 1 - Juli 2026]**: Fase 1 (Foundation & Bug Fixes) telah diselesaikan. Boilerplate screen untuk Fase 2-5 telah digenerate dan disambungkan ke navigasi. Dashboard dikonfigurasi untuk menampilkan semua widget fitur.
- **[Update 2 - Juli 2026]**: Fase 2 (Core Admin Features) SELESAI. Fitur Cabang, Mata Pelajaran, Kelas Master, dan Presensi telah memiliki UI CRUD lengkap dan terhubung dengan struktur Provider. Status saat ini beralih ke Fase 3 (Jurnal & Laporan).
- **[Update 3 - Juli 2026]**: Fase 3 (Jurnal & Laporan) SELESAI. Fitur Life Items, Bible Schedules, Weekly Verses sudah terintegrasi CRUD, serta UI Laporan Siswa & Mentor selesai dengan dummy data. Target API di-pointing ke `studycenter.seriusman.shop`. Status saat ini beralih ke Fase 4.
- **[Update 4 - Juli 2026]**: Fase 4 (Approval & Master Data Lainnya) SELESAI. Pendaftaran Siswa (UI Simulasi), Role & Permission (CRUD API), dan Nametag Generator (API terhubung) sudah diimplementasikan penuh.
- **[Update 5 - Juli 2026]**: Fase 5 (Optimization & Polishing) SELESAI. Layar sertifikat, jurnal kuliah, dan ekspor data ditambahkan sebagai fitur *UI readiness*. Aplikasi siap untuk *build* final kapan saja. *Catatan Penting: Mulai dari titik ini, setiap pembaruan atau progres implementasi harus dicatatkan ke dalam PRD ini.*

---

## 1. Latar Belakang & Tujuan

Aplikasi **Study Center Admin** adalah mobile admin panel berbasis Flutter yang mengelola seluruh operasional platform Study Center Nias. Backend yang ada di `study-center-nias` (Laravel) memiliki fitur admin yang sangat lengkap, namun Android baru mencakup ~40% dari fitur tersebut.

**Tujuan dokumen ini:**
- Mendefinisikan seluruh fitur admin yang harus diimplementasi di Android
- Menjadi referensi gap analysis antara web dan Android
- Menjadi panduan pengembangan screen-by-screen

---

## 2. Status Fitur Saat Ini (Gap Analysis)

| Modul | Web (Laravel) | Android (Flutter) | Status |
|-------|--------------|-------------------|--------|
| Dashboard statistik | ✅ | ✅ Partial | ⚠️ Perlu cabang chart |
| User Management - List | ✅ | ✅ | ✅ |
| User Management - Create | ✅ | ❌ | 🔴 Missing |
| User Management - Edit lengkap | ✅ | ⚠️ Partial | 🟡 Partial |
| User Management - Role assign | ✅ | ❌ | 🔴 Missing |
| User Management - Toggle aktif | ✅ | ✅ | ✅ |
| User Management - Delete | ✅ | ✅ | ✅ |
| User QR Print | ✅ | ❌ | 🔴 Missing |
| Cabang CRUD | ✅ | ✅ | ✅ |
| Mata Pelajaran CRUD | ✅ | ❌ | 🔴 Missing |
| Blog List & Delete (admin) | ✅ | ⚠️ Partial | 🟡 Partial |
| Blog Write + Upload Foto | ✅ | ⚠️ Partial | 🟡 Missing upload |
| Roles CRUD | ✅ | ❌ | 🔴 Missing |
| Permissions CRUD | ✅ | ❌ | 🔴 Missing |
| Role-Permission Sync | ✅ | ❌ | 🔴 Missing |
| Kelas Master CRUD | ✅ | ✅ | ✅ |
| Presensi Siswa - Create+QR Scan | ✅ | ⚠️ Partial | 🟡 Missing foto upload |
| Presensi Siswa - Report | ✅ | ❌ | 🔴 Missing |
| Jurnal Life Items CRUD | ✅ | ✅ | ✅ |
| Jurnal Bible Schedules CRUD | ✅ | ❌ | 🔴 Missing |
| Jurnal Weekly Verses CRUD | ✅ | ❌ | 🔴 Missing |
| Jurnal Student Sync Life Items | ✅ | ❌ | 🔴 Missing |
| Jurnal Reports + Export | ✅ | ❌ | 🔴 Missing |
| Mentor Presensi - Self | ✅ | ✅ | ✅ |
| Mentor Presensi - Admin Reports | ✅ | ❌ | 🔴 Missing |
| Mentor Presensi - Export Excel/PDF | ✅ | ❌ | 🔴 Missing |
| Pendaftaran - List & Validasi | ✅ | ❌ | 🔴 Missing |
| Certificate Templates CRUD | ✅ | ❌ | 🔴 Missing |
| Issued Certificates | ✅ | ❌ | 🔴 Missing |
| Name Tags - Generate | ✅ | ❌ | 🔴 Missing |
| College Jurnal Admin | ✅ | ❌ | 🔴 Missing |
| College Bible Config | ✅ | ❌ | 🔴 Missing |
| Profile Edit | ✅ | ✅ | ✅ |
| CV | ✅ | ❌ | 🔴 Missing |

---

## 3. Arsitektur Teknis Flutter

### 3.1 Struktur Direktori Target

```
lib/
├── main.dart
├── constants/
│   ├── app_colors.dart
│   └── api_constants.dart
├── models/
│   ├── user_model.dart ✅
│   ├── blog_model.dart ✅
│   ├── cabang_model.dart ✅
│   ├── role_model.dart ✅
│   ├── dashboard_stats.dart ✅
│   ├── mata_pelajaran_model.dart 🆕
│   ├── kelas_master_model.dart 🆕
│   ├── presensi_model.dart 🆕
│   ├── jurnal_life_item_model.dart 🆕
│   ├── jurnal_bible_schedule_model.dart 🆕
│   ├── jurnal_weekly_verse_model.dart 🆕
│   ├── jurnal_report_model.dart 🆕
│   ├── mentor_presensi_model.dart 🆕
│   ├── pendaftaran_model.dart 🆕
│   ├── certificate_model.dart 🆕
│   ├── nametag_model.dart 🆕
│   └── college_jurnal_model.dart 🆕
├── providers/
│   ├── auth_provider.dart ✅
│   ├── blog_provider.dart ✅
│   ├── user_provider.dart ✅
│   ├── cabang_provider.dart 🆕
│   ├── mata_pelajaran_provider.dart 🆕
│   ├── kelas_master_provider.dart 🆕
│   ├── presensi_provider.dart 🆕
│   ├── jurnal_provider.dart 🆕
│   ├── mentor_presensi_provider.dart 🆕
│   ├── pendaftaran_provider.dart 🆕
│   ├── certificate_provider.dart 🆕
│   └── role_permission_provider.dart 🆕
├── services/
│   └── api_service.dart ✅ (extend)
└── screens/
    ├── login_screen.dart ✅
    ├── main_shell.dart ✅ (extend tabs + drawer)
    ├── home_tab.dart ✅ (extend)
    ├── profile_tab.dart ✅
    ├── blog/
    │   ├── blog_tab.dart ✅ (extend)
    │   ├── blog_detail_screen.dart ✅
    │   └── write_blog_screen.dart ✅ (fix foto upload)
    ├── user/
    │   ├── user_tab.dart ✅
    │   ├── user_detail_screen.dart ✅
    │   ├── edit_user_screen.dart ✅ (fix)
    │   └── create_user_screen.dart 🆕
    ├── cabang/
    │   └── cabang_screen.dart 🆕
    ├── mata_pelajaran/
    │   └── mata_pelajaran_screen.dart 🆕
    ├── kelas_master/
    │   └── kelas_master_screen.dart 🆕
    ├── presensi/
    │   ├── presensi_list_screen.dart 🆕
    │   ├── presensi_create_screen.dart 🆕 (fix)
    │   ├── presensi_detail_screen.dart 🆕
    │   └── presensi_report_screen.dart 🆕
    ├── jurnal/
    │   ├── jurnal_life_items_screen.dart 🆕
    │   ├── jurnal_bible_schedule_screen.dart 🆕
    │   ├── jurnal_weekly_verse_screen.dart 🆕
    │   ├── jurnal_reports_screen.dart 🆕
    │   └── student_life_item_assign_screen.dart 🆕
    ├── mentor_presensi/
    │   ├── mentor_presensi_list_screen.dart 🆕
    │   └── mentor_presensi_report_screen.dart 🆕
    ├── pendaftaran/
    │   ├── pendaftaran_list_screen.dart 🆕
    │   └── pendaftaran_detail_screen.dart 🆕
    ├── certificate/
    │   ├── certificate_template_screen.dart 🆕
    │   └── issued_certificate_screen.dart 🆕
    ├── nametag/
    │   └── nametag_screen.dart 🆕
    ├── roles_permissions/
    │   ├── roles_screen.dart 🆕
    │   └── permissions_screen.dart 🆕
    └── college_jurnal/
        └── college_jurnal_admin_screen.dart 🆕
```

### 3.2 Navigasi — Bottom Navigation Bar + Drawer

**Bottom Nav Tabs (4 utama):**
1. 🏠 **Dashboard** — statistik + aksi cepat
2. 📝 **Blog** — manajemen artikel
3. 👥 **Users** — manajemen pengguna
4. 👤 **Profile** — profil & logout

**Navigation Drawer (fitur lanjutan):**
- 📚 Kelas Master
- 🏫 Cabang
- 📖 Mata Pelajaran
- ✅ Presensi Siswa
- 📋 Jurnal (Life Items, Bible Schedule, Weekly Verse, Reports)
- 👨‍🏫 Mentor Presensi
- 📝 Pendaftaran
- 🏆 Sertifikat
- 🪪 Name Tags
- 🔐 Roles & Permissions
- 🎓 College Jurnal

---

## 4. Spesifikasi Fitur Per Modul

### 4.1 Dashboard

**Layar:** `HomeTab`
**API:** `GET /api/admin/dashboard`

**Yang harus ada:**
- Kartu selamat datang dengan nama user
- Metric card: Total User, Total Blog, Total Komentar, Total Cabang
- Distribusi role user (progress bar)
- Chart blog per cabang (bar chart sederhana)
- Quick actions: Tulis Blog, Tambah User, Catat Presensi, Generate Name Tag

---

### 4.2 User Management

**Layar:** `UserTab`, `UserDetailScreen`, `EditUserScreen`, `CreateUserScreen`

#### 4.2.1 Daftar User

**API:** `GET /api/admin/users?page=&q=&role=&cabang_id=`

- List user dengan pagination
- Search by nama/email/username
- Filter by role dan cabang
- Badge status aktif/nonaktif
- Swipe action: Edit, Delete
- Tombol "Tambah User"

#### 4.2.2 Buat User Baru (MISSING — Harus Dibuat)

**API:** `POST /api/admin/users`
**Layar:** `CreateUserScreen`

**Form fields:**
- Nama (required)
- Email (optional)
- Password (optional, default: 12345)
- Pilih Role (multi-select: admin, mentor, student, fulltimer, college, guest)
- Pilih Cabang (dropdown)
- Upload Avatar (image picker)

**Profil tambahan (conditional berdasarkan role):**

*role = student:*
- Nomor siswa, Tanggal lahir (DatePicker), Tempat lahir
- Jenis kelamin (dropdown L/P/Lainnya)
- Alamat, Nama wali/HP wali
- Nama sekolah, Kelas, Tahun masuk

*role = mentor:*
- Keahlian, Bio, Pendidikan
- Tahun pengalaman, Tarif per jam
- Status tersedia (toggle)

*role = admin:*
- Nomor pegawai, Departemen, Jabatan

#### 4.2.3 Edit User (Perlu Fix)

**API:** `PUT /api/admin/users/{id}`

**Perbaikan:**
- Semua field dari Create harus ada di Edit
- Dapat mengubah role user (multi-select)
- Upload avatar berfungsi
- Toggle aktif dari edit screen

#### 4.2.4 Print QR User (MISSING)

- Dialog/modal QR Code berisi username user
- Tombol share/screenshot QR

---

### 4.3 Blog Management

**Layar:** `BlogTab`, `WriteBlogScreen`, `BlogDetailScreen`

#### 4.3.1 List Blog Admin

**API:** `GET /api/admin/blogs?search=`

- List blog dengan search
- Tampilkan penulis & cabang
- Status published/draft

#### 4.3.2 Tulis Blog (Perlu Fix Kritis)

**API:** `POST /api/blogs`

**Perbaikan:**
- Upload foto inline (`POST /api/blogs/upload-image` atau multipart)
- Toolbar formatting text (bold, italic, heading, list, link, gambar) — gunakan `flutter_quill`
- Pilih Cabang (dropdown)
- Pilih Tags
- Upload foto cover

---

### 4.4 Cabang Management (MISSING — Screen Baru)

**Layar:** `CabangScreen`
**API:** CRUD `/api/cabangs`, `/api/admin/cabangs`

**Form Cabang:**
- Nama, Alamat, Kontak, WhatsApp Link
- Kelas Min/Max (range 1-12)
- Foto wajib (toggle), Pendaftaran buka (toggle)
- Mata pelajaran (multi-select)

---

### 4.5 Mata Pelajaran Management (MISSING)

**Layar:** `MataPelajaranScreen`
**API:** CRUD `/api/admin/mata-pelajaran`

- List dengan status aktif/nonaktif
- Toggle aktif per item
- Tambah/edit/hapus

---

### 4.6 Kelas Master Management (MISSING Screen)

**Layar:** `KelasMasterScreen`
**API:** CRUD `/api/kelas-master`

- Nama kelas, Cabang, Deskripsi, Toggle aktif

---

### 4.7 Presensi Siswa (Perlu Fix + Screen Baru)

**Layar:** `PresensiListScreen`, `PresensiCreateScreen`, `PresensiDetailScreen`, `PresensiReportScreen`

#### 4.7.1 Catat Presensi (Create — Perlu Fix)

**API:** `POST /api/presensi`

**Form (sesuai web):**
- Tanggal → Android DatePicker (bukan iOS)
- Jam Mulai/Selesai → Android TimePicker (bukan iOS)
- Pilih Kelas → Dropdown dari API (FIX: tidak muncul)
- Pilih Cabang → Dropdown
- Mata Pelajaran → Dropdown/multi-select
- **Foto Kegiatan → ImagePicker** (FIX: belum ada)
- Catatan/Deskripsi

#### 4.7.2 Scan QR Siswa

- Tombol "Scan QR" buka kamera
- Scan QR barcode username siswa
- Tambahkan ke list hadir

#### 4.7.3 Report Presensi (MISSING)

**API:** `GET /api/presensi/report`

- Filter periode, filter student
- Tabel rekap kehadiran

---

### 4.8 Jurnal Management

#### 4.8.1 Life Items (sebagian ada, perlu lengkapi)

**API:** CRUD `/api/admin/jurnal/life-items`

#### 4.8.2 Bible Schedule (MISSING)

**Layar:** `JurnalBibleScheduleScreen`
**API:** CRUD `/api/admin/jurnal/bible-schedules`

- List jadwal baca Alkitab per tanggal
- Tambah satu per satu atau import bulk JSON

#### 4.8.3 Weekly Verse (MISSING)

**Layar:** `JurnalWeeklyVerseScreen`
**API:** CRUD `/api/admin/jurnal/weekly-verses`

- List ayat mingguan per pekan
- Tambah/edit/hapus ayat

#### 4.8.4 Student Life Item Assign (MISSING)

**Layar:** `StudentLifeItemAssignScreen`
**API:** `GET/POST /api/admin/jurnal/students/{id}/life-items`

- Pilih student dari list
- Checklist item yang di-assign
- Simpan assignment

#### 4.8.5 Laporan Jurnal Student (MISSING)

**Layar:** `JurnalReportsScreen`
**API:** `GET /api/admin/jurnal/reports`, `GET /api/admin/jurnal/reports/{id}`

- List semua student dengan summary jurnal
- Detail laporan per student dengan filter periode
- Export laporan (buka via DownloadManager)

---

### 4.9 Mentor Presensi Admin (MISSING)

**Layar:** `MentorPresensiListScreen`, `MentorPresensiReportScreen`
**API:** `/api/admin/mentor-presensi/...`

- List semua presensi mentor lintas user
- Laporan agregasi per mentor
- Export Excel/PDF (DownloadManager)

---

### 4.10 Pendaftaran Siswa (MISSING)

**Layar:** `PendaftaranListScreen`, `PendaftaranDetailScreen`
**API:** Perlu ditambah ke `api.php`

- List calon siswa dengan filter status & cabang
- Detail pendaftaran lengkap
- Tombol Validasi → setujui
- Tombol Generate Link Update → kirim link perbaikan

---

### 4.11 Sertifikat (MISSING)

**Layar:** `CertificateTemplateScreen`, `IssuedCertificateScreen`
**API:** `/api/admin/certificates/...`

- CRUD template sertifikat
- Generate & download sertifikat PDF per user

---

### 4.12 Name Tags (MISSING)

**Layar:** `NameTagScreen`
**API:** `GET /api/admin/nametags`, `POST /api/admin/nametags/generate`

- Filter by cabang, kelas, status siswa
- Generate name tags → download PDF

---

### 4.13 Roles & Permissions (MISSING)

**Layar:** `RolesScreen`, `PermissionsScreen`

**Roles:**
- CRUD roles
- Assign permissions ke role (checklist)

**Permissions:**
- CRUD permissions

---

### 4.14 College Jurnal Admin (MISSING)

**Layar:** `CollegeJurnalAdminScreen`
**API:** `/api/admin/jurnal-college/...`

- Dashboard progress college
- Laporan & export per user college
- Konfigurasi Bible items

---

## 5. Bug Fixes Prioritas Tinggi

Berdasarkan `apkplan.yaml`:

| # | Bug | Layar | Solusi |
|---|-----|-------|--------|
| 1 | Dropdown kelas tidak muncul di presensi | PresensiCreate | Fix API endpoint kelas + pastikan data ter-load |
| 2 | Form presensi tidak ada upload foto kegiatan | PresensiCreate | Tambah ImagePicker |
| 3 | DatePicker & TimePicker seperti iOS | PresensiCreate | Gunakan `showDatePicker()` & `showTimePicker()` standard Flutter |
| 4 | Upload foto tidak bisa di blog | WriteBlog | Integrasi `image_picker` + `POST /api/blogs/upload-image` |
| 5 | Formatting text blog tidak lengkap | WriteBlog | Gunakan `flutter_quill` package |
| 6 | Warna font dan background sulit dibaca | Global | Review AppColors, pastikan contrast ratio cukup |
| 7 | Form blog tidak sama dengan web | WriteBlog | Sinkronkan field: judul, konten, cabang, tags, foto cover |

---

## 6. Design System & UX Guidelines

### 6.1 Warna (AppColors)

```dart
static const Color primary = Color(0xFF1E3A5F);      // Navy utama
static const Color primaryLight = Color(0xFF2D5282);  // Navy muda
static const Color accent = Color(0xFFC9A84C);        // Gold accent
static const Color background = Color(0xFFF5F7FA);    // Abu sangat muda
static const Color surface = Color(0xFFFFFFFF);       // Putih
static const Color textPrimary = Color(0xFF1A1D2E);   // Teks utama
static const Color textSecondary = Color(0xFF6B7280); // Teks sekunder
static const Color border = Color(0xFFE5E7EB);        // Border
static const Color error = Color(0xFFDC2626);         // Error merah
static const Color success = Color(0xFF059669);       // Success hijau
static const Color warning = Color(0xFFD97706);       // Warning kuning
```

### 6.2 Komponen UI Standar

- **Card:** `BorderRadius.circular(20)`, shadow tipis
- **Button Primary:** `FilledButton` warna primary, radius 12
- **Input Field:** `OutlineInputBorder`, radius 12
- **AppBar:** Background putih, teks hitam, elevation 0
- **Loading:** `CircularProgressIndicator` warna primary
- **Dialog konfirmasi:** Wajib untuk aksi destructive

### 6.3 Pattern Form

- Validasi real-time dengan error inline
- Loading state di tombol submit
- SnackBar untuk feedback sukses/error
- Konfirmasi dialog untuk aksi tidak bisa dibatalkan
- Back dengan unsaved changes → konfirmasi dialog

---

## 7. API Endpoints Reference

### Auth

| Method | Endpoint | Deskripsi |
|--------|----------|-----------|
| POST | `/api/auth/login` | Login |
| POST | `/api/auth/logout` | Logout |
| GET | `/api/me` | Info user login |

### Admin Users

| Method | Endpoint | Deskripsi |
|--------|----------|-----------|
| GET | `/api/admin/users` | List users |
| POST | `/api/admin/users` | Buat user baru |
| GET | `/api/admin/users/{id}` | Detail user |
| PUT | `/api/admin/users/{id}` | Update user |
| PATCH | `/api/admin/users/{id}/role` | Update role |
| PATCH | `/api/admin/users/{id}/toggle-active` | Toggle aktif |
| DELETE | `/api/admin/users/{id}` | Hapus user |

### Cabang

| Method | Endpoint |
|--------|----------|
| GET | `/api/cabangs` |
| POST | `/api/admin/cabangs` |
| PUT | `/api/admin/cabangs/{id}` |
| DELETE | `/api/admin/cabangs/{id}` |

### Kelas Master

| Method | Endpoint |
|--------|----------|
| GET | `/api/kelas-master` |
| POST | `/api/kelas-master` |
| PUT | `/api/kelas-master/{id}` |
| DELETE | `/api/kelas-master/{id}` |

### Presensi Siswa

| Method | Endpoint | Deskripsi |
|--------|----------|-----------|
| GET | `/api/presensi` | List presensi |
| POST | `/api/presensi` | Buat presensi |
| GET | `/api/presensi/{id}` | Detail presensi |
| PUT | `/api/presensi/{id}` | Update presensi |
| DELETE | `/api/presensi/{id}` | Hapus presensi |
| POST | `/api/presensi/{id}/scan` | Scan QR siswa |
| GET | `/api/presensi/students/search` | Cari siswa |

### Jurnal

| Method | Endpoint | Deskripsi |
|--------|----------|-----------|
| GET | `/api/admin/jurnal/life-items` | List life items |
| POST | `/api/admin/jurnal/life-items` | Buat life item |
| PUT | `/api/admin/jurnal/life-items/{id}` | Update |
| DELETE | `/api/admin/jurnal/life-items/{id}` | Hapus |
| GET | `/api/admin/jurnal/students/{id}/life-items` | Life items student |
| POST | `/api/admin/jurnal/students/{id}/life-items` | Sync ke student |
| GET | `/api/admin/jurnal/bible-schedules` | List jadwal Alkitab |
| POST | `/api/admin/jurnal/bible-schedules` | Buat jadwal |
| POST | `/api/admin/jurnal/bible-schedules/bulk` | Import bulk |
| GET | `/api/admin/jurnal/weekly-verses` | List ayat mingguan |
| POST | `/api/admin/jurnal/weekly-verses` | Buat ayat |
| GET | `/api/admin/jurnal/reports` | Laporan semua student |
| GET | `/api/admin/jurnal/reports/{id}` | Laporan per student |
| GET | `/api/admin/jurnal/reports/{id}/export` | Export laporan |

### Mentor Presensi Admin

| Method | Endpoint | Deskripsi |
|--------|----------|-----------|
| GET | `/api/admin/mentor-presensi` | List semua presensi mentor |
| GET | `/api/admin/mentor-presensi/reports` | Laporan agregasi |
| GET | `/api/admin/mentor-presensi/export/excel` | Export Excel |
| GET | `/api/admin/mentor-presensi/export/pdf` | Export PDF |

### Roles & Permissions

| Method | Endpoint |
|--------|----------|
| GET | `/api/admin/roles` |
| POST | `/api/admin/roles` |
| PUT | `/api/admin/roles/{id}` |
| POST | `/api/admin/roles/{id}/permissions` |
| DELETE | `/api/admin/roles/{id}` |
| GET | `/api/admin/permissions` |
| POST | `/api/admin/permissions` |
| PUT | `/api/admin/permissions/{id}` |
| DELETE | `/api/admin/permissions/{id}` |

### Dashboard

| Method | Endpoint |
|--------|----------|
| GET | `/api/admin/dashboard` |

---

## 8. Roadmap Pengembangan

### Fase 1 — Bug Fixes & Foundation (Prioritas TINGGI)
> Estimasi: 1-2 minggu | **Status: SELESAI ✅**

| Task | Status |
|------|--------|
| Fix dropdown kelas di presensi | ✅ |
| Fix DatePicker/TimePicker Android native | ✅ |
| Fix upload foto kegiatan presensi | ✅ |
| Fix upload foto blog | ✅ |
| Fix formatting text blog (flutter_quill) | ✅ |
| Fix kontrast warna global AppColors | ✅ |
| Fix form blog sesuai web | ✅ |
| Fix Edit User lengkap + role assign | ✅ |

### Fase 2 — Core Admin Features (Prioritas TINGGI)
> Estimasi: 2-3 minggu | **Status: SELESAI ✅**

| Task | Status |
|------|--------|
| Create User Screen (form lengkap) | ✅ |
| Drawer navigasi untuk fitur lanjutan | ✅ |
| Dashboard - semua fitur bentuk widget | ✅ |
| Cabang Screen (pindah dari home) | ✅ |
| Mata Pelajaran Screen | ✅ |
| Kelas Master Screen | ✅ |
| Presensi - List, Create (fix), Detail | ✅ |

### Fase 3 — Jurnal & Laporan (Prioritas MENENGAH)
> Estimasi: 2-3 minggu | **Status: SELESAI ✅**

| Task | Status |
|------|--------|
| Jurnal Life Items Screen (CRUD) | ✅ |
| Bible Schedule Screen (CRUD) | ✅ |
| Weekly Verse Screen (CRUD) | ✅ |
| Assign Item/Verse ke Siswa Screen | ✅ (Dummy / UI Base) |
| Laporan Siswa Screen (View Only) | ✅ (Dummy / UI Base) |
| Laporan Mentor Screen (View Only) | ✅ (Dummy / UI Base) |

### Fase 4 — Approval & Sistem Blog/Galeri (Prioritas MENENGAH-RENDAH)
> Estimasi: 1-2 minggu | **Status: SELESAI ✅**

| Task | Status |
|------|--------|
| Pendaftaran List & Detail & Validasi | ✅ (Dummy UI) |
| Name Tags Screen | ✅ |
| Roles & Permissions Screen | ✅ |

### Fase 5 — Optimization & Polishing (Prioritas RENDAH)
> Estimasi: 1 minggu | **Status: SELESAI ✅**

| Task | Status |
|------|--------|
| Certificate Templates & Issued | ✅ (Dummy / UI Base) |
| College Jurnal Admin | ✅ (Dummy / UI Base) |
| Export PDF/Excel (DownloadManager) | ✅ (Dummy / UI Base) |

---

## 9. Acceptance Criteria

Fitur dianggap **selesai** jika:

1. Semua field di form sama dengan versi web
2. Validasi input berjalan (field wajib, format email, dll)
3. Loading state muncul saat request API
4. Pesan sukses/error ditampilkan via SnackBar
5. List auto-refresh setelah create/edit/delete
6. Back dengan perubahan belum disimpan → konfirmasi dialog
7. Empty state ditampilkan jika data kosong
8. Error state + tombol retry jika koneksi gagal

---

## 10. Catatan Teknis Penting

### API Authentication
```
Authorization: Bearer {sanctum_token}
```
Token disimpan di `FlutterSecureStorage`.

### Base URL
- Development (Tailscale): `http://100.67.79.94`
- Production: `https://studycenter.overcomer.my.id`
- Konfigurasikan di `lib/constants/api_constants.dart`

### Image Upload
- Format: `multipart/form-data`
- Max ukuran: 2MB per file
- Format: JPG, PNG, WEBP

### Export Files (Excel/PDF)
- Gunakan `DownloadManager` Android atau buka URL di browser
- Sertakan token di `Authorization` header

### Error Handling
| HTTP Status | Penanganan |
|-------------|-----------|
| 401 | Paksa logout → LoginScreen |
| 403 | Tampilkan "Akses ditolak" |
| 422 | Tampilkan error per field |
| 500 | Pesan umum + retry |
| Network Error | "Tidak ada koneksi" + retry |

### Package Dependencies yang Direkomendasikan Ditambah
```yaml
dependencies:
  flutter_quill: ^10.x        # Rich text editor blog
  mobile_scanner: ^5.x        # QR Scanner presensi
  fl_chart: ^0.x              # Chart dashboard
  open_filex: ^4.x            # Buka file download
  path_provider: ^2.x         # Path file lokal
```

---

## 11. Checklist Rilis

- [ ] Semua bug dari `apkplan.yaml` sudah diperbaiki
- [ ] Fase 1 & 2 selesai dan ditest di device nyata
- [ ] Role validation (non-admin ditolak)
- [ ] Token expiry → re-login otomatis
- [ ] App tidak crash di corner cases
- [ ] Logo & assets di resolusi yang benar

---

*Dokumen ini adalah living document. Update setiap ada perubahan requirement atau fitur baru di backend.*

