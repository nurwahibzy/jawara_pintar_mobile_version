import '../../domain/entities/kategori_iuran.dart';
import '../../domain/entities/master_iuran.dart';
import 'kategori_iuran_model.dart';

class MasterIuranModel extends MasterIuran {
  const MasterIuranModel({
    required super.id,
    required super.kategoriIuranId,
    required super.namaIuran,
    required super.nominalStandar,
    required super.isActive,
    super.createdAt,
    super.updatedAt,
    super.kategoriIuran,
  });

  // From JSON dengan relasi
  factory MasterIuranModel.fromJson(Map<String, dynamic> json) {
    return MasterIuranModel(
      id: json['id'] as int,
      kategoriIuranId: json['kategori_iuran_id'] as int,
      namaIuran: json['nama_iuran'] as String,
      nominalStandar: (json['nominal_standar'] as num).toDouble(),
      isActive: json['is_active'] as bool? ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      kategoriIuran: json['kategori_iuran'] != null
          ? KategoriIuranModel.fromJson(
              json['kategori_iuran'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'kategori_iuran_id': kategoriIuranId,
      'nama_iuran': namaIuran,
      'nominal_standar': nominalStandar,
      'is_active': isActive,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      if (kategoriIuran != null)
        'kategori_iuran': {
          'id': kategoriIuran!.id,
          'nama_kategori': kategoriIuran!.namaKategori,
        },
    };
  }

  // From Entity
  factory MasterIuranModel.fromEntity(MasterIuran entity) {
    return MasterIuranModel(
      id: entity.id,
      kategoriIuranId: entity.kategoriIuranId,
      namaIuran: entity.namaIuran,
      nominalStandar: entity.nominalStandar,
      isActive: entity.isActive,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      kategoriIuran: entity.kategoriIuran,
    );
  }

  // To Entity
  MasterIuran toEntity() {
    return MasterIuran(
      id: id,
      kategoriIuranId: kategoriIuranId,
      namaIuran: namaIuran,
      nominalStandar: nominalStandar,
      isActive: isActive,
      createdAt: createdAt,
      updatedAt: updatedAt,
      kategoriIuran: kategoriIuran,
    );
  }

  @override
  MasterIuranModel copyWith({
    int? id,
    int? kategoriIuranId,
    String? namaIuran,
    double? nominalStandar,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    KategoriIuran? kategoriIuran,
  }) {
    return MasterIuranModel(
      id: id ?? this.id,
      kategoriIuranId: kategoriIuranId ?? this.kategoriIuranId,
      namaIuran: namaIuran ?? this.namaIuran,
      nominalStandar: nominalStandar ?? this.nominalStandar,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      kategoriIuran: kategoriIuran ?? this.kategoriIuran,
    );
  }
}
