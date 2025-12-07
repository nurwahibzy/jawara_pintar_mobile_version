import '../../domain/entities/kategori_iuran.dart';

class KategoriIuranModel extends KategoriIuran {
  const KategoriIuranModel({required super.id, required super.namaKategori});

  factory KategoriIuranModel.fromJson(Map<String, dynamic> json) {
    return KategoriIuranModel(
      id: json['id'] as int,
      namaKategori: json['nama_kategori'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'nama_kategori': namaKategori};
  }

  factory KategoriIuranModel.fromEntity(KategoriIuran entity) {
    return KategoriIuranModel(id: entity.id, namaKategori: entity.namaKategori);
  }

  KategoriIuran toEntity() {
    return KategoriIuran(id: id, namaKategori: namaKategori);
  }
}
