import '../../domain/entities/transaksi_kegiatan.dart';

class TransaksiKegiatanModel extends TransaksiKegiatan {
  const TransaksiKegiatanModel({
    required super.id,
    required super.kegiatanId,
    required super.jenisTransaksi,
    super.pemasukanId,
    super.pengeluaranId,
    required super.createdBy,
    required super.createdAt,
    // Optional dari JOIN
    super.judul,
    super.nominal,
    super.tanggalTransaksi,
    super.keterangan,
    super.buktiFoto,
    super.namaKategori,
    super.namaCreatedBy,
  });

  factory TransaksiKegiatanModel.fromJson(Map<String, dynamic> json) {
    // Parse dari JOIN dengan pemasukan_lain atau pengeluaran
    final jenisTransaksi = json['jenis_transaksi'] as String;
    final isPemasukan = jenisTransaksi.toLowerCase() == 'pemasukan';

    // Ambil data dari pemasukan atau pengeluaran
    final transaksiData = isPemasukan
        ? json['pemasukan_lain']
        : json['pengeluaran'];

    return TransaksiKegiatanModel(
      id: json['id'] as int,
      kegiatanId: json['kegiatan_id'] as int,
      jenisTransaksi: jenisTransaksi,
      pemasukanId: json['pemasukan_id'] as int?,
      pengeluaranId: json['pengeluaran_id'] as int?,
      createdBy: json['created_by'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      // Data dari JOIN (optional)
      judul: transaksiData?['judul'] as String?,
      nominal: transaksiData != null
          ? (transaksiData['nominal'] as num?)?.toDouble()
          : null,
      tanggalTransaksi: transaksiData?['tanggal_transaksi'] != null
          ? DateTime.parse(transaksiData['tanggal_transaksi'] as String)
          : null,
      keterangan: transaksiData?['keterangan'] as String?,
      buktiFoto: transaksiData?['bukti_foto'] as String?,
      namaKategori:
          transaksiData?['kategori_transaksi']?['nama_kategori'] as String?,
      namaCreatedBy:
          json['created_by_user']?['warga']?['nama_lengkap'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != 0) 'id': id,
      'kegiatan_id': kegiatanId,
      'jenis_transaksi': jenisTransaksi,
      'pemasukan_id': pemasukanId,
      'pengeluaran_id': pengeluaranId,
      'created_by': createdBy,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory TransaksiKegiatanModel.fromEntity(TransaksiKegiatan entity) {
    return TransaksiKegiatanModel(
      id: entity.id,
      kegiatanId: entity.kegiatanId,
      jenisTransaksi: entity.jenisTransaksi,
      pemasukanId: entity.pemasukanId,
      pengeluaranId: entity.pengeluaranId,
      createdBy: entity.createdBy,
      createdAt: entity.createdAt,
      judul: entity.judul,
      nominal: entity.nominal,
      tanggalTransaksi: entity.tanggalTransaksi,
      keterangan: entity.keterangan,
      buktiFoto: entity.buktiFoto,
      namaKategori: entity.namaKategori,
      namaCreatedBy: entity.namaCreatedBy,
    );
  }
}
