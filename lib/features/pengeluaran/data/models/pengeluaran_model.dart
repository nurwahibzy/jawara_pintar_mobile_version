import 'package:jawara_pintar_mobile_version/features/pengeluaran/domain/entities/pengeluaran.dart';

class PengeluaranModel extends Pengeluaran {
  final String? createdByName;

  const PengeluaranModel({
    super.id,
    required super.judul,
    required super.kategoriTransaksiId,
    required super.nominal,
    required super.tanggalTransaksi,
    super.buktiFoto,
    super.keterangan,
    required super.createdBy,
   // super.verifikatorId,
   // super.tanggalVerifikasi,
    required super.createdAt,
    this.createdByName,
  });

  /// Convert Map ke Model
  factory PengeluaranModel.fromMap(Map<String, dynamic> map) {
    return PengeluaranModel(
      id: map['id'],
      judul: map['judul'],
      kategoriTransaksiId: map['kategori_transaksi_id'],
      nominal: (map['nominal'] as num).toDouble(),
      tanggalTransaksi: DateTime.parse(map['tanggal_transaksi']),
      buktiFoto: map['bukti_foto'],
      keterangan: map['keterangan'],
      createdBy: map['created_by'] == null ? '' : map['created_by'].toString(),
     // verifikatorId: map['verifikator_id'],
     // tanggalVerifikasi: map['tanggal_verifikasi'] != null
         // ? DateTime.parse(map['tanggal_verifikasi'])  : null,
      createdAt: DateTime.parse(map['created_at']),
      createdByName: map['created_by_name'],
    );
  }

  /// Convert JSON ke Model
  factory PengeluaranModel.fromJson(Map<String, dynamic> json) {
    return PengeluaranModel.fromMap(json);
  }

  /// Convert Model ke Map 
  Map<String, dynamic> toMap({bool forUpdate = false}) {
    final map = {
      'judul': judul,
      'kategori_transaksi_id': kategoriTransaksiId,
      'nominal': nominal,
      'tanggal_transaksi': tanggalTransaksi.toIso8601String(),
      'bukti_foto': buktiFoto,
      'keterangan': keterangan,
      'created_by': createdBy,
     // 'verifikator_id': verifikatorId,
      //'tanggal_verifikasi': tanggalVerifikasi?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };

    // Masukkan id hanya kalau untuk update
    if (forUpdate && id != null) {
      map['id'] = id;
    }

    return map;
  }

  /// Convert Model ke JSON
  Map<String, dynamic> toJson() => toMap();

  /// Convert Entity ke Model (dipakai di Repository)
  factory PengeluaranModel.fromEntity(Pengeluaran entity) {
    return PengeluaranModel(
      id: entity.id,
      judul: entity.judul,
      kategoriTransaksiId: entity.kategoriTransaksiId,
      nominal: entity.nominal,
      tanggalTransaksi: entity.tanggalTransaksi,
      buktiFoto: entity.buktiFoto,
      keterangan: entity.keterangan,
      createdBy: entity.createdBy,
    //  verifikatorId: entity.verifikatorId,
     // tanggalVerifikasi: entity.tanggalVerifikasi,
      createdAt: entity.createdAt,
      createdByName: entity.createdByName,
    );
  }

  Map<String, dynamic> toMapForInsert() {
    return {
      'judul': judul,
      'kategori_transaksi_id': kategoriTransaksiId,
      'nominal': nominal,
      'tanggal_transaksi': tanggalTransaksi.toIso8601String(),
      'bukti_foto': buktiFoto,
      'keterangan': keterangan,
      'created_by': createdBy,
     // 'verifikator_id': verifikatorId,
     // 'tanggal_verifikasi': tanggalVerifikasi?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }

  PengeluaranModel copyWith({
    int? id,
    String? judul,
    int? kategoriTransaksiId,
    double? nominal,
    DateTime? tanggalTransaksi,
    String? buktiFoto,
    String? keterangan,
    String? createdBy,
    String? createdByName,
    DateTime? createdAt,
  }) {
    return PengeluaranModel(
      id: id ?? this.id,
      judul: judul ?? this.judul,
      kategoriTransaksiId: kategoriTransaksiId ?? this.kategoriTransaksiId,
      nominal: nominal ?? this.nominal,
      tanggalTransaksi: tanggalTransaksi ?? this.tanggalTransaksi,
      buktiFoto: buktiFoto ?? this.buktiFoto,
      keterangan: keterangan ?? this.keterangan,
      createdBy: createdBy ?? this.createdBy,
      createdByName: createdByName,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Convert Model -> Entity 
  Pengeluaran toEntity() {
    return Pengeluaran(
      id: id,
      judul: judul,
      kategoriTransaksiId: kategoriTransaksiId,
      nominal: nominal,
      tanggalTransaksi: tanggalTransaksi,
      buktiFoto: buktiFoto,
      keterangan: keterangan,
      createdBy: createdBy,
      createdByName: null, 
      createdAt: createdAt,
    );
  }

}