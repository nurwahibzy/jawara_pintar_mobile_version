## Daftar API Endpoints

### Authentication
- `POST /auth/v1/token?grant_type=password` - Login dengan email dan password

### Warga (Residents)
- `GET /warga?select=*` - Mendapatkan semua data warga
- `GET /warga?select=*&jenis_kelamin=eq.L` - Filter warga berdasarkan jenis kelamin
- `GET /warga?select=*,keluarga:keluarga_id(nomor_kk)` - Warga dengan relasi keluarga
- `GET /warga?select=*&keluarga_id=is.null` - Warga tanpa keluarga
- `GET /warga?select=id,nama_lengkap` - Warga untuk dropdown options

### Keluarga (Family)
- `GET /keluarga?select=*` - Mendapatkan semua data keluarga
- `GET /keluarga?select=*,rumah:rumah_id(alamat),warga(nama_lengkap)` - Keluarga dengan relasi rumah dan warga
- `GET /keluarga?select=*&status_keluarga=eq.Tetap` - Filter keluarga berdasarkan status
- `GET /keluarga?select=id,nomor_kk` - Keluarga untuk dropdown options
- `POST /keluarga` - Membuat keluarga baru
- `PUT /keluarga?id=eq.{id}` - Update data keluarga

### Rumah (Houses)
- `GET /rumah?select=*` - Mendapatkan semua data rumah
- `GET /rumah?select=*&order=id.asc` - Rumah dengan ordering
- `GET /rumah?select=*&status_rumah=eq.Ditempati` - Filter rumah berdasarkan status
- `GET /rumah?select=id,alamat` - Rumah untuk dropdown options
- `POST /rumah` - Membuat rumah baru
- `PUT /rumah?id=eq.{id}` - Update data rumah
- `DELETE /rumah?id=eq.{id}` - Hapus data rumah

### Master Iuran (Fee Master)
- `GET /master_iuran?select=*,kategori_iuran:kategori_iuran_id(id,nama_kategori)&order=id.asc` - List master iuran dengan kategori
- `GET /master_iuran?select=*&id=eq.{id}` - Master iuran by ID
- `GET /master_iuran?select=*&is_active=eq.true` - Master iuran yang aktif
- `GET /master_iuran?select=id,nama_iuran,nominal_standar,kategori_iuran:kategori_iuran_id(nama_kategori)&is_active=eq.true&order=nama_iuran` - Dropdown untuk tagih iuran
- `POST /master_iuran` - Membuat master iuran baru
- `PUT /master_iuran?id=eq.{id}` - Update master iuran
- `DELETE /master_iuran?id=eq.{id}` - Hapus master iuran

### Kategori Iuran
- `GET /kategori_iuran?select=*` - Mendapatkan semua kategori iuran

### Tagihan (Bills)
- `GET /tagihan?select=id,kode_tagihan,keluarga_id,master_iuran_id,periode,nominal,status_tagihan,created_at,master_iuran:master_iuran_id(nama_iuran)&order=created_at.desc` - List tagihan
- `GET /tagihan?select=*&id=eq.{id}` - Tagihan by ID
- `GET /tagihan?select=*,pembayaran_tagihan(id,metode_pembayaran,bukti_bayar,tanggal_bayar,status_verifikasi)` - Detail tagihan dengan pembayaran
- `GET /tagihan?select=*&status_tagihan=eq.Lunas` - Filter tagihan lunas
- `GET /tagihan?select=*&periode=eq.{periode}` - Filter tagihan berdasarkan periode
- `GET /tagihan?select=*,master_iuran(nama_iuran),keluarga(nomor_kk)` - Tagihan dengan relasi
- `GET /tagihan?select=id,kode_tagihan,nominal,created_at,master_iuran(nama_iuran)&status_tagihan=eq.Lunas` - Tagihan untuk laporan
- `PUT /tagihan?id=eq.{id}` - Update status tagihan

### Tagih Iuran (Generate Bills)
- `RPC /generate_tagih_iuran` - Generate tagihan untuk semua keluarga
  - Parameters: `p_master_iuran_id`, `p_periode`

### Pengeluaran (Expenses)
- `GET /pengeluaran?select=*&order=created_at.desc` - List pengeluaran
- `GET /pengeluaran?select=*&id=eq.{id}` - Pengeluaran by ID
- `GET /pengeluaran?select=*&tanggal_transaksi=gte.{date}&tanggal_transaksi=lte.{date}` - Filter by date range
- `GET /pengeluaran?select=id,judul,kategori_transaksi_id,nominal,tanggal_transaksi,bukti_foto,keterangan,created_by,verifikator_id,tanggal_verifikasi,created_at,kategori_transaksi(nama_kategori)` - Untuk laporan
- `POST /pengeluaran` - Membuat pengeluaran baru
- `PUT /pengeluaran?id=eq.{id}` - Update pengeluaran
- `DELETE /pengeluaran?id=eq.{id}` - Hapus pengeluaran

### Pemasukan Lain (Other Income)
- `GET /pemasukan_lain?select=*,kategori_transaksi:kategori_transaksi_id(id,nama_kategori)&order=created_at.desc` - List pemasukan
- `GET /pemasukan_lain?select=*&id=eq.{id}` - Pemasukan by ID
- `GET /pemasukan_lain?select=*&kategori_transaksi_id=eq.{id}` - Filter by kategori
- `GET /pemasukan_lain?select=*&tanggal_transaksi=gte.{date}&tanggal_transaksi=lte.{date}` - Filter by date range
- `GET /pemasukan_lain?select=id,judul,nominal,tanggal_transaksi,keterangan,kategori_transaksi(nama_kategori)` - Untuk cetak laporan
- `GET /pemasukan_lain?select=id,judul,kategori_transaksi_id,nominal,tanggal_transaksi,bukti_foto,keterangan,created_by,verifikator_id,tanggal_verifikasi,created_at,kategori_transaksi(nama_kategori)` - Untuk laporan detail
- `POST /pemasukan_lain` - Membuat pemasukan baru
- `PUT /pemasukan_lain?id=eq.{id}` - Update pemasukan
- `DELETE /pemasukan_lain?id=eq.{id}` - Hapus pemasukan

### Kategori Transaksi
- `GET /kategori_transaksi?select=*` - Semua kategori transaksi
- `GET /kategori_transaksi?select=*&jenis=eq.Pengeluaran` - Kategori pengeluaran
- `GET /kategori_transaksi?select=*&jenis=eq.Pemasukan` - Kategori pemasukan

### Mutasi Keluarga (Family Transfer)
- `GET /mutasi_keluarga?select=*` - List mutasi keluarga
- `GET /mutasi_keluarga?select=*,keluarga:keluarga_id(nomor_kk,warga(nama_lengkap,status_keluarga)),rumah_asal:rumah_asal_id(alamat),rumah_tujuan:rumah_tujuan_id(alamat)` - Mutasi dengan complete relations
- `POST /mutasi_keluarga` - Membuat mutasi keluarga baru

### Aspirasi/Pesan Warga (Citizen Messages)
- `GET /aspirasi?select=id,warga_id,judul,deskripsi,status,tanggapan_admin,updated_by,created_at,warga:warga!aspirasi_warga_id_fkey(nama_lengkap)&order=created_at.desc` - List aspirasi
- `GET /aspirasi?select=*&id=eq.{id}` - Aspirasi by ID
- `GET /aspirasi?select=*&status=eq.Pending` - Filter by status
- `POST /aspirasi` - Membuat aspirasi baru
- `PUT /aspirasi?id=eq.{id}` - Update aspirasi
- `DELETE /aspirasi?id=eq.{id}` - Hapus aspirasi

### Users & Manajemen Pengguna
- `GET /users?select=*,warga(nama_lengkap)` - List users dengan relasi warga
- `GET /users?select=*&id=eq.{id}` - User by ID
- `POST /users` - Membuat user baru
- `PUT /users?id=eq.{id}` - Update user
- `DELETE /users?id=eq.{id}` - Hapus user

### Broadcast Messages
- `GET /broadcast?select=*` - List broadcast messages
- `POST /broadcast` - Membuat broadcast baru

### Transfer Channels
- `GET /transfer_channels?select=*` - List transfer channels
- `GET /transfer_channels?select=*&id=eq.{id}` - Transfer channel by ID
- `POST /transfer_channels` - Membuat channel baru
- `PUT /transfer_channels?id=eq.{id}` - Update channel
- `DELETE /transfer_channels?id=eq.{id}` - Hapus channel

### Kegiatan (Activities)
- `GET /kegiatan?select=*,kategori_kegiatan(nama_kategori)&order=tanggal_pelaksanaan.desc` - List kegiatan
- `GET /kegiatan?select=*&id=eq.{id}` - Kegiatan by ID
- `GET /kegiatan?select=id` - Count total kegiatan
- `GET /kegiatan?select=kategori_kegiatan_id` - Kegiatan per kategori
- `GET /kegiatan?select=tanggal_pelaksanaan` - Kegiatan berdasarkan waktu
- `GET /kegiatan?select=penanggung_jawab` - Data penanggung jawab
- `POST /kegiatan` - Membuat kegiatan baru
- `PUT /kegiatan?id=eq.{id}` - Update kegiatan
- `DELETE /kegiatan?id=eq.{id}` - Hapus kegiatan

### Kategori Kegiatan
- `GET /kategori_kegiatan?select=*` - Semua kategori kegiatan

### Transaksi Kegiatan
- `GET /transaksi_kegiatan?select=*,pemasukan_lain(judul,nominal,tanggal_transaksi,keterangan,bukti_foto,kategori_transaksi(nama_kategori)),pengeluaran(judul,nominal,tanggal_transaksi,keterangan,bukti_foto,kategori_transaksi(nama_kategori))&kegiatan_id=eq.{id}&order=created_at.desc` - Transaksi by kegiatan

### Log Aktivitas
- `GET /log_aktivitas_view?select=*` - View log aktivitas sistem

### Dashboard Keuangan
- `GET /pemasukan_lain?select=nominal&tanggal_transaksi=gte.{year}-01-01&tanggal_transaksi=lte.{year}-12-31` - Total pemasukan per tahun
- `GET /pengeluaran?select=nominal&tanggal_transaksi=gte.{year}-01-01` - Agregasi pengeluaran
- `GET /tagihan?select=status_tagihan,nominal` - Summary tagihan by status

### Dashboard Kependudukan
- `GET /keluarga?select=id` - Count total keluarga (with Prefer: count=exact)
- `GET /warga?select=id` - Count total penduduk
- `GET /warga?select=jenis_kelamin` - Statistik jenis kelamin
- `GET /warga?select=status_penduduk` - Statistik status penduduk
- `GET /warga?select=pekerjaan` - Statistik pekerjaan
- `GET /warga?select=status_keluarga` - Statistik peran dalam keluarga
- `GET /warga?select=agama` - Statistik agama
- `GET /warga?select=pendidikan_terakhir` - Statistik pendidikan
- `GET /rumah?select=status_rumah` - Statistik rumah

### Dashboard Kegiatan
- `GET /kegiatan?select=id` - Total kegiatan (with Prefer: count=exact)
- `GET /kegiatan?select=kategori_kegiatan_id` - Kegiatan per kategori
- `GET /kegiatan?select=tanggal_pelaksanaan&tanggal_pelaksanaan=gte.{year}-01-01&tanggal_pelaksanaan=lte.{year}-12-31` - Kegiatan per bulan

## Testing

Untuk menjalankan API tests:

```bash
flutter test test/api-test/supabase_api_test.dart --reporter expanded
```

Total: **71 test cases** covering all API endpoints

## Environment Variables

Buat file `.env` di root project dengan isi:

```env
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_supabase_anon_key
```