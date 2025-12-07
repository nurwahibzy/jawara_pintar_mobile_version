import 'package:equatable/equatable.dart';

class KategoriIuran extends Equatable {
  final int id;
  final String namaKategori;

  const KategoriIuran({required this.id, required this.namaKategori});

  @override
  List<Object?> get props => [id, namaKategori];

  KategoriIuran copyWith({int? id, String? namaKategori}) {
    return KategoriIuran(
      id: id ?? this.id,
      namaKategori: namaKategori ?? this.namaKategori,
    );
  }

  @override
  String toString() {
    return 'KategoriIuran(id: $id, namaKategori: $namaKategori)';
  }
}
