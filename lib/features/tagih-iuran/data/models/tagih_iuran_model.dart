import '../../domain/entities/tagih_iuran.dart';

class TagihIuranModel extends TagihIuran {
  const TagihIuranModel({
    required super.kodeTagihan,
    required super.keluargaId,
    required super.masterIuranId,
    required super.periode,
    required super.nominal,
    required super.statusTagihan,
    super.tanggalBayar,
    super.nominalBayar,
    super.tglStrukFinal,
    required super.createdAt,
    required super.updatedAt,
  });

  factory TagihIuranModel.fromJson(Map<String, dynamic> json) {
    return TagihIuranModel(
      kodeTagihan: json['kode_tagihan'] as String,
      keluargaId: json['keluarga_id'] as int,
      masterIuranId: json['master_iuran_id'] as int,
      periode: json['periode'] as String,
      nominal: (json['nominal'] as num).toDouble(),
      statusTagihan: json['status_tagihan'] as String,
      tanggalBayar: json['tanggal_bayar'] != null
          ? DateTime.parse(json['tanggal_bayar'] as String)
          : null,
      nominalBayar: json['nominal_bayar'] != null
          ? (json['nominal_bayar'] as num).toDouble()
          : null,
      tglStrukFinal: json['tgl_struk_final'] != null
          ? DateTime.parse(json['tgl_struk_final'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kode_tagihan': kodeTagihan,
      'keluarga_id': keluargaId,
      'master_iuran_id': masterIuranId,
      'periode': periode,
      'nominal': nominal,
      'status_tagihan': statusTagihan,
      'tanggal_bayar': tanggalBayar?.toIso8601String(),
      'nominal_bayar': nominalBayar,
      'tgl_struk_final': tglStrukFinal?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  TagihIuran toEntity() {
    return TagihIuran(
      kodeTagihan: kodeTagihan,
      keluargaId: keluargaId,
      masterIuranId: masterIuranId,
      periode: periode,
      nominal: nominal,
      statusTagihan: statusTagihan,
      tanggalBayar: tanggalBayar,
      nominalBayar: nominalBayar,
      tglStrukFinal: tglStrukFinal,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
