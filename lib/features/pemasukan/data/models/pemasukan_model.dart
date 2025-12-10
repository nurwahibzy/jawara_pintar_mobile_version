import '../../domain/entities/pemasukan.dart';

class PemasukanModel extends Pemasukan {
  const PemasukanModel({
    required super.id,
    required super.judul,
    required super.kategoriTransaksiId,
    required super.nominal,
    required super.tanggalTransaksi,
    super.buktiFoto,
    required super.keterangan,
    required super.createdBy,
    super.verifikatorId,
    super.tanggalVerifikasi,
    required super.createdAt,
    super.namaKategori,
  });

  factory PemasukanModel.fromJson(Map<String, dynamic> json) {
    return PemasukanModel(
      id: json['id'] as int,
      judul: json['judul'] as String,
      kategoriTransaksiId: json['kategori_transaksi_id'] as int,
      nominal: (json['nominal'] as num).toDouble(),
      tanggalTransaksi: json['tanggal_transaksi'] as String,
      buktiFoto: json['bukti_foto'] as String?,
      keterangan: json['keterangan'] as String,
      createdBy: json['created_by'] as int,
      verifikatorId: json['verifikator_id'] as int?,
      tanggalVerifikasi: json['tanggal_verifikasi'] != null
          ? DateTime.parse(json['tanggal_verifikasi'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      namaKategori: json['kategori_transaksi'] != null
          ? json['kategori_transaksi']['nama_kategori'] as String?
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'judul': judul,
      'kategori_transaksi_id': kategoriTransaksiId,
      'nominal': nominal,
      'tanggal_transaksi': tanggalTransaksi,
      'bukti_foto': buktiFoto,
      'keterangan': keterangan,
      'created_by': createdBy,
      'verifikator_id': verifikatorId,
      'tanggal_verifikasi': tanggalVerifikasi?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}
