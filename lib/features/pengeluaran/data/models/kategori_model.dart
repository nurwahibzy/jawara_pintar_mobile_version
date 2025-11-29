import '../../domain/entities/kategori_transaksi.dart';

class KategoriModel extends KategoriEntity {
  KategoriModel({required super.id, required super.jenis, super.nama_kategori});

  factory KategoriModel.fromJson(Map<String, dynamic> json) {
    return KategoriModel(id: json['id'], jenis: json['jenis'], nama_kategori: json['nama_kategori']);
  }
}
