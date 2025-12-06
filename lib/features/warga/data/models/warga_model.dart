
import 'package:jawara_pintar_mobile_version/features/warga/domain/entities/warga.dart';

class WargaModel extends Warga {
  const WargaModel({
    required super.keluargaId,
    required super.idWarga,
    required super.nik,
    required super.nama,
    required super.nomorTelepon,
    required super.tempatLahir,
    required super.tanggalLahir,
    required super.jenisKelamin,
    required super.agama,
    required super.golonganDarah,
    required super.statusKeluarga,
    required super.pendidikanTerakhir,
    required super.pekerjaan,
    required super.statusPenduduk,
    required super.statusHidup,
    required super.createdAt,
    required super.updatedAt,
  });

  /// Create model from server JSON
  factory WargaModel.fromJson(Map<String, dynamic> json) {
    return WargaModel(
      idWarga: json['id'],
      nama: json['nama_lengkap'] ?? '-',
      nik: json['nik'] ?? '-',
      nomorTelepon: json['no_hp'] ?? '-',
      tempatLahir: json['tempat_lahir'] ?? '-',
      tanggalLahir: json['tanggal_lahir'] != null
          ? DateTime.tryParse('${json['tanggal_lahir']}')
          : null,
      jenisKelamin: json['jenis_kelamin'] ?? 'L',
      agama: json['agama'] ?? '-',
      golonganDarah: json['golongan_darah'] ?? '-',
      statusKeluarga: json['status_keluarga'] ?? '-',
      pendidikanTerakhir: json['pendidikan_terakhir'] ?? '-',
      pekerjaan: json['pekerjaan'] ?? '-',
      statusPenduduk: json['status_penduduk'] ?? 'Aktif',
      statusHidup: json['status_hidup'] ?? 'Hidup',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse('${json['created_at']}')
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse('${json['updated_at']}')
          : null,
      keluargaId: json['keluarga_id'] is int
          ? json['keluarga_id'] as int
          : int.tryParse('${json['keluarga_id']}') ?? 0,
    );
  }

  /// Convert model to JSON suitable for repository/network
  Map<String, dynamic> toJson() {
    return {
      'id': idWarga,
      'keluarga_id': keluargaId,
      'nama_lengkap': nama,
      'nik': nik,
      'no_hp': nomorTelepon,
      'tempat_lahir': tempatLahir,
      'tanggal_lahir': tanggalLahir?.toIso8601String(),
      'jenis_kelamin': jenisKelamin,
      'agama': agama,
      'golongan_darah': golonganDarah,
      'status_keluarga': statusKeluarga,
      'pendidikan_terakhir': pendidikanTerakhir,
      'pekerjaan': pekerjaan,
      'status_penduduk': statusPenduduk,
      'status_hidup': statusHidup,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  /// Convert an entity into a model (useful for repository/local data)
  factory WargaModel.fromEntity(Warga warga) {
    return WargaModel(
      keluargaId: warga.keluargaId,
      idWarga: warga.idWarga,
      nik: warga.nik,
      nama: warga.nama,
      nomorTelepon: warga.nomorTelepon,
      tempatLahir: warga.tempatLahir,
      tanggalLahir: warga.tanggalLahir,
      jenisKelamin: warga.jenisKelamin,
      agama: warga.agama,
      golonganDarah: warga.golonganDarah,
      statusKeluarga: warga.statusKeluarga,
      pendidikanTerakhir: warga.pendidikanTerakhir,
      pekerjaan: warga.pekerjaan,
      statusPenduduk: warga.statusPenduduk,
      statusHidup: warga.statusHidup,
      createdAt: warga.createdAt,
      updatedAt: warga.updatedAt,
    );
  }

  /// Convert model to entity (repository returns domain entities)
  Warga toEntity() {
    return Warga(
      keluargaId: keluargaId,
      idWarga: idWarga,
      nik: nik,
      nama: nama,
      nomorTelepon: nomorTelepon,
      tempatLahir: tempatLahir,
      tanggalLahir: tanggalLahir,
      jenisKelamin: jenisKelamin,
      agama: agama,
      golonganDarah: golonganDarah,
      statusKeluarga: statusKeluarga,
      pendidikanTerakhir: pendidikanTerakhir,
      pekerjaan: pekerjaan,
      statusPenduduk: statusPenduduk,
      statusHidup: statusHidup,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  static List<WargaModel> fromJsonList(List<dynamic>? data) {
    if (data == null || data.isEmpty) return [];
    return data.map((json) => WargaModel.fromJson(json as Map<String, dynamic>)).toList();
  }
}