import 'package:jawara_pintar_mobile_version/manajemen-pengguna/domain/entities/users.dart';

class UsersModel extends Users {
  const UsersModel({
    required super.id,
    required super.wargaId,
    required super.nama,
    required super.role,
    required super.status,
    required super.authId,
    required super.createdAt,
  });

  /// Convert Map ke Model
  factory UsersModel.fromMap(Map<String, dynamic> map) {
    String extractedName = '-';

    if (map['warga'] != null && map['warga'] is Map) {
      extractedName = map['warga']['nama_lengkap'] ?? '-';
    } else {
      extractedName = map['nama_lengkap'] ?? '-';
    }

    return UsersModel(
      id: map['id'],
      wargaId: map['warga_id'],
      nama: extractedName,
      role: map['role'],
      status: map['status_user'],
      authId: map['auth_id'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  /// Convert JSON ke Model
  factory UsersModel.fromJson(Map<String, dynamic> json) {
    return UsersModel.fromMap(json);
  }

  /// Convert Model ke Map
  Map<String, dynamic> toMap({bool forUpdate = false}) {
    final map = {
      'id': id,
      'warga_id': wargaId,
      'role': role,
      // 'nama_lengkap': nama,
      'status_user': status,
      'auth_id': authId,
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
  factory UsersModel.fromEntity(Users entity) {
    return UsersModel(
      id: entity.id,
      wargaId: entity.wargaId,
      nama: entity.nama,
      role: entity.role,
      status: entity.status,
      authId: entity.authId,
      createdAt: entity.createdAt,
    );
  }

  Map<String, dynamic> toMapForInsert() {
    return {
      'id': id,
      'warga_id': wargaId,
      'nama_lengkap': nama,
      'role': role,
      'status_user': status,
      'auth_id': authId,
      'created_at': createdAt.toIso8601String(),
    };
  }

  @override
  UsersModel copyWith({
    int? id,
    int? wargaId,
    String? nama,
    String? role,
    String? status,
    String? authId,
    DateTime? createdAt,
  }) {
    return UsersModel(
      id: id ?? this.id,
      wargaId: wargaId ?? this.wargaId,
      nama: nama ?? this.nama,
      role: role ?? this.role,
      status: status ?? this.status,
      authId: authId ?? this.authId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Convert Model -> Entity
  Users toEntity() {
    return Users(
      id: id,
      wargaId: wargaId,
      nama: nama,
      role: role,
      status: status,
      authId: authId,
      createdAt: createdAt,
    );
  }
}
