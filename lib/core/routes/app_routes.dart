class AppRoutes {
  static const String login = '/login';
  static const String profil = '/profil';
  static const daftarPengeluaran = '/daftar-pengeluaran';
  static const tambahPengeluaran = '/tambah-pengeluaran';
  static const editPengeluaran = '/edit-pengeluaran';
  static const hapusPengeluaran = '/hapus-pengeluaran';
  
  // Kependudukan & Warga
  static const String kependudukan = '/kependudukan';
  static const String tambahWarga = '/tambah_warga';
  static const String daftarWarga = '/daftar_warga';
  static const String detailWarga = '/detail_warga';
  static const String editWarga = '/edit_warga';
  static const String pesanWarga = '/pesan_warga';
  static const String daftarKeluarga = '/daftar_keluarga';

// Rumah & Aset
  static const String tambahRumah = '/tambah_rumah';
  static const String daftarRumah = '/daftar_rumah';

// Keuangan & Iuran
  static const String keuangan = '/keuangan';
  static const String pemasukanLain = '/pemasukan_lain';
  static const String tambahPemasukan = '/tambah_pemasukan';
  // static const String daftarPengeluaran = '/daftar_pengeluaran';
  // static const String tambahPengeluaran = '/tambah_pengeluaran';
  // static const String editPengeluaran = '/edit_pengeluaran';
  static const String daftarTagihan = '/daftar_tagihan';
  static const String detailTagihan = '/detail_tagihan';
  static const String daftarTagihanRumah = '/daftar_tagihan_rumah';
  static const String daftarKategoriIuran = '/daftar_kategori_iuran';
  static const String tambahKategoriIuran = '/tambah_kategori_iuran';

// Kegiatan & Log
  static const String kegiatan = '/kegiatan';
  static const String daftarKegiatan = '/daftar-kegiatan'; // Perhatikan ini pakai hypen (-)
  static const String broadcast = '/broadcast';
  static const String logAktivitas = '/log-aktivitas';

// Pengguna (User Biasa)
  static const String penggunaDaftar = '/pengguna/daftar_pengguna';
  static const String penggunaTambah = '/pengguna/tambah_pengguna';

// Manajemen Pengguna (Admin)
  static const String manPenggunaDaftar = '/manajemen_pengguna/daftar_pengguna';
  static const String manPenggunaTambah = '/manajemen_pengguna/tambah_pengguna';
  static const String manPenggunaEdit = '/manajemen_pengguna/edit_pengguna';
}