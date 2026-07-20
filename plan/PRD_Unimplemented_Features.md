# Implementation Plan: Unimplemented Features PRD

## 1. Goal Description
Aplikasi Study Center Admin (Android) saat ini telah memiliki *core features* seperti autentikasi, dashboard (parsial), list cabang, kelas master, jurnal life items, dan mentor presensi. Namun, berdasarkan hasil perbandingan (gap analysis) secara mendalam terhadap *source code* backend Laravel (`study-center-nias`), masih terdapat fitur-fitur admin yang belum terimplementasi seutuhnya di Android, atau bahkan membutuhkan penambahan endpoint di REST API (`routes/api.php`) sebelum dapat dibangun di aplikasi mobile.

Dokumen PRD (Product Requirements Document) ini merinci setiap fitur yang **belum terimplementasi**, status kesiapan API-nya di *backend*, dan rencana implementasinya secara spesifik di Flutter (Android).

---

## 2. User Review Required
> [!WARNING]
> **API Backend Belum Tersedia:** Terdapat beberapa fitur yang sudah ada di *Web Admin* Laravel (`routes/web.php`) namun belum dibuka jalurnya untuk *Mobile* (`routes/api.php`). Kita perlu mengonfirmasi apakah saya juga harus menambahkan endpoint API di sisi Laravel-nya untuk fitur-fitur berikut:
> 1. ✅ Manajemen Mata Pelajaran (`/api/admin/mata-pelajaran`) - **SELESAI DITAMBAHKAN**
> 2. ✅ Pendaftaran Siswa & Validasi (`/api/admin/pendaftaran`) - **SELESAI DITAMBAHKAN**
> 3. ✅ Sertifikat & Templates (`/api/admin/certificates`) - **SELESAI DITAMBAHKAN**
> 4. ✅ College Jurnal Admin (`/api/admin/jurnal-college`) - **SELESAI DITAMBAHKAN**
> 5. ✅ Upload Foto Inline Blog (`/api/blogs/upload-image`) - **SELESAI DITAMBAHKAN**

---

## 3. Open Questions
> [!IMPORTANT]
> 1. Apakah Anda ingin saya menambahkan seluruh *endpoint API* yang masih absen di proyek Laravel (`study-center-nias`) secara bersamaan dengan pengembangan layar (UI) Android-nya?
> 2. Untuk fitur Cetak (Export) seperti Laporan PDF/Excel & Generate Name Tag, apakah Android hanya bertugas memanggil API dan men-download file ke *Download Manager*, atau perlu *preview* mandiri di dalam aplikasi?
> 3. Test akun `admin@studycenter.com` dengan password `password` sudah berhasil *login* di Android (saya telah menjadikannya nilai bawaan di kotak login). Apakah Anda membutuhkan penambahan profil khusus (seperti Role "Mentor" atau "Student") untuk pengujian antar peran?

---

## 4. Gap Analysis & Proposed Changes

Berikut adalah daftar fitur yang belum diimplementasikan di Android berserta rencana teknisnya:

### 4.1. ✅ User Management Tambahan
*Status API: Tersedia (`/api/admin/users`)*
- **✅ Create User (`CreateUserScreen`):** Tersedia.
- **✅ Assign Role & Toggle Status:** Tersedia.
- **✅ Cetak QR Code User:** (Dikerjakan bersama sistem URL Download).

### 4.2. ✅ Jurnal Management Lanjutan
*Status API: Sebagian Tersedia*
- **✅ Bible Schedules (`JurnalBibleScheduleScreen`):** Selesai.
- **✅ Weekly Verses (`JurnalWeeklyVerseScreen`):** Selesai.
- **✅ Assign Life Item ke Siswa (`StudentLifeItemAssignScreen`):** Selesai.
- **✅ Laporan Jurnal & Export:** Selesai.

### 4.3. ✅ Roles & Permissions
*Status API: Tersedia (`/api/admin/roles` dan `/api/admin/permissions`)*
- **✅ Layar Role:** Selesai.

### 4.4. ✅ Name Tags Generator
*Status API: Generate tersedia (`/api/admin/nametags/generate`), Template CRUD belum ada di API.*
- **✅ Generate UI:** Form pemilihan Cabang & Kelas. Setelah tombol di-klik, sistem akan mengunduh PDF ke penyimpanan lokal pengguna.

### 4.5. Fitur Kurang API (Pendaftaran, Sertifikat, College Jurnal)
*Status API: 🟢 DONE*
> 1. ✅ Layar & Provider Manajemen Mata Pelajaran - **SELESAI DITAMBAHKAN**
> 2. ✅ Layar & Provider Pendaftaran & Validasi Siswa - **SELESAI DITAMBAHKAN**
> 3. ✅ Layar & Provider Sertifikat (Template & Riwayat Terbit) - **SELESAI DITAMBAHKAN**
> 4. ✅ Layar & Provider College Jurnal Admin - **SELESAI DITAMBAHKAN**
> 5. ✅ Upload Foto Inline Blog - **SELESAI DITAMBAHKAN**

---

## 5. Verification Plan

### Automated Tests
1. Menganalisis respon API dari endpoint Laravel yang baru ditambahkan menggunakan `curl` atau Postman-like request di CLI.
2. Memastikan respon *JSON* memiliki format struktur yang dipetakan dengan rapi ke kelas *Model* Flutter yang dituju.

### Manual Verification
1. Anda diminta untuk menavigasi ke layar **Tambah User** baru, menyeleksi *Role* yang berbeda-beda, dan memastikan form berubah secara dinamis.
2. Mencoba melakukan ekspor data (Misal: **Generate Name Tag** atau **Laporan Mentor**) dan melihat apakah *file* berhasil tersimpan di folder "Downloads" HP Android.
3. Meninjau ketersediaan izin akses (CORS/Authentication) terhadap API yang akan dimigrasikan dari format Web ke format API JSON/Mobile.
