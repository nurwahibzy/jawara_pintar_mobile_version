import '../../domain/entities/rumah.dart';
import 'riwayat_penghuni_model.dart';

class RumahModel extends Rumah {
  const RumahModel({
    required super.id,
    required super.alamat,
    required super.statusRumah,
    super.createdAt,
    super.riwayatPenghuni,
  });

  factory RumahModel.fromJson(Map<String, dynamic> json) {
    return RumahModel(
      id: json['id'] as int,
      alamat: json['alamat'] ?? '-',
      statusRumah: json['status_rumah'] ?? 'Kosong',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse('${json['created_at']}')
          : null,
      riwayatPenghuni: json['riwayat_penghuni'] != null
          ? (json['riwayat_penghuni'] as List<dynamic>)
                .map(
                  (e) =>
                      RiwayatPenghuniModel.fromJson(e as Map<String, dynamic>),
                )
                .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {'alamat': alamat, 'status_rumah': statusRumah};
  }

  Map<String, dynamic> toJsonWithId() {
    return {'id': id, 'alamat': alamat, 'status_rumah': statusRumah};
  }

  factory RumahModel.fromEntity(Rumah rumah) {
    return RumahModel(
      id: rumah.id,
      alamat: rumah.alamat,
      statusRumah: rumah.statusRumah,
      createdAt: rumah.createdAt,
      riwayatPenghuni: rumah.riwayatPenghuni,
    );
  }

  Rumah toEntity() {
    return Rumah(
      id: id,
      alamat: alamat,
      statusRumah: statusRumah,
      createdAt: createdAt,
      riwayatPenghuni: riwayatPenghuni,
    );
  }

  static List<RumahModel> fromJsonList(List<dynamic>? data) {
    if (data == null || data.isEmpty) return [];
    return data
        .map((json) => RumahModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
