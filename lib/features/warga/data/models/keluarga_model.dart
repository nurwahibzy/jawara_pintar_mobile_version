import 'package:jawara_pintar_mobile_version/features/warga/domain/entities/keluarga.dart';

class AnggotaKeluargaModel extends AnggotaKeluarga {
  const AnggotaKeluargaModel({
    required super.id,
    required super.nik,
    required super.nama,
    required super.jenisKelamin,
    super.tanggalLahir,
    required super.statusKeluarga,
    required super.statusHidup,
  });

  factory AnggotaKeluargaModel.fromJson(Map<String, dynamic> json) {
    return AnggotaKeluargaModel(
      id: json['id'] as int,
      nik: json['nik'] ?? '-',
      nama: json['nama_lengkap'] ?? '-',
      jenisKelamin: json['jenis_kelamin'] ?? '-',
      tanggalLahir: json['tanggal_lahir'] != null
          ? DateTime.tryParse('${json['tanggal_lahir']}')
          : null,
      statusKeluarga: json['status_keluarga'] ?? '-',
      statusHidup: json['status_hidup'] ?? 'Hidup',
    );
  }

  static List<AnggotaKeluargaModel> fromJsonList(List<dynamic>? data) {
    if (data == null || data.isEmpty) return [];
    return data
        .map(
          (json) => AnggotaKeluargaModel.fromJson(json as Map<String, dynamic>),
        )
        .toList();
  }
}

class RumahInfoModel extends RumahInfo {
  const RumahInfoModel({
    required super.id,
    required super.alamat,
    required super.statusRumah,
  });

  factory RumahInfoModel.fromJson(Map<String, dynamic> json) {
    return RumahInfoModel(
      id: json['id'] as int,
      alamat: json['alamat'] ?? '-',
      statusRumah: json['status_rumah'] ?? '-',
    );
  }
}

class KeluargaModel extends Keluarga {
  const KeluargaModel({
    required super.id,
    required super.nomorKk,
    super.rumahId,
    required super.statusHunian,
    super.tanggalTerdaftar,
    super.createdAt,
    super.rumah,
    super.anggota,
  });

  factory KeluargaModel.fromJson(Map<String, dynamic> json) {
    // Parse relasi rumah jika ada
    RumahInfoModel? rumahInfo;
    if (json['rumah'] != null && json['rumah'] is Map<String, dynamic>) {
      rumahInfo = RumahInfoModel.fromJson(
        json['rumah'] as Map<String, dynamic>,
      );
    }

    // Parse anggota keluarga (warga) jika ada
    List<AnggotaKeluargaModel> anggotaList = [];
    if (json['warga'] != null && json['warga'] is List) {
      anggotaList = AnggotaKeluargaModel.fromJsonList(
        json['warga'] as List<dynamic>,
      );
    }

    return KeluargaModel(
      id: json['id'] as int,
      nomorKk: json['nomor_kk'] ?? '-',
      rumahId: json['rumah_id'] as int?,
      statusHunian: json['status_hunian'] ?? 'Aktif',
      tanggalTerdaftar: json['tanggal_terdaftar'] != null
          ? DateTime.tryParse('${json['tanggal_terdaftar']}')
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse('${json['created_at']}')
          : null,
      rumah: rumahInfo,
      anggota: anggotaList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nomor_kk': nomorKk,
      'rumah_id': rumahId,
      'status_hunian': statusHunian,
      'tanggal_terdaftar': tanggalTerdaftar?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
    };
  }

  static List<KeluargaModel> fromJsonList(List<dynamic>? data) {
    if (data == null || data.isEmpty) return [];
    return data
        .map((json) => KeluargaModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
