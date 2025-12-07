import '../../domain/entities/pengeluaran_detail_entity.dart';

class PengeluaranDetailModel extends PengeluaranDetailEntity {
  const PengeluaranDetailModel({
    required super.id,
    required super.judul,
    required super.kategori,
    required super.nominal,
    required super.tanggalTransaksi,
    super.buktiFoto,
    super.keterangan,
    required super.createdBy,
    super.tanggalVerifikasi,
  });

  factory PengeluaranDetailModel.fromJson(Map<String, dynamic> json) {
    return PengeluaranDetailModel(
      id: json['id'] as int,
      judul: json['judul'] as String,
      kategori: json['kategori_transaksi']?['nama_kategori'] as String? ?? '-',
      nominal: (json['nominal'] as num).toDouble(),
      tanggalTransaksi: DateTime.parse(json['tanggal_transaksi'] as String),
      buktiFoto: json['bukti_foto'] as String?,
      keterangan: json['keterangan'] as String?,
      createdBy: json['created_by'] as String? ?? '-',
      tanggalVerifikasi: json['tanggal_verifikasi'] != null
          ? DateTime.parse(json['tanggal_verifikasi'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'judul': judul,
      'kategori': kategori,
      'nominal': nominal,
      'tanggal_transaksi': tanggalTransaksi.toIso8601String(),
      'bukti_foto': buktiFoto,
      'keterangan': keterangan,
      'created_by': createdBy,
      'tanggal_verifikasi': tanggalVerifikasi?.toIso8601String(),
    };
  }

  PengeluaranDetailEntity toEntity() {
    return PengeluaranDetailEntity(
      id: id,
      judul: judul,
      kategori: kategori,
      nominal: nominal,
      tanggalTransaksi: tanggalTransaksi,
      buktiFoto: buktiFoto,
      keterangan: keterangan,
      createdBy: createdBy,
      tanggalVerifikasi: tanggalVerifikasi,
    );
  }
}
