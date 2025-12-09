import '../../domain/entities/master_iuran_dropdown.dart';

class MasterIuranDropdownModel extends MasterIuranDropdown {
  const MasterIuranDropdownModel({
    required super.id,
    required super.namaIuran,
    required super.nominalStandar,
    required super.statusTagihan,
  });

  factory MasterIuranDropdownModel.fromJson(Map<String, dynamic> json) {
    // Ambil nama kategori dari join table
    final kategoriIuran = json['kategori_iuran'];
    String namaKategori = '';

    if (kategoriIuran != null && kategoriIuran is Map<String, dynamic>) {
      namaKategori = kategoriIuran['nama_kategori'] as String? ?? '';
    }

    return MasterIuranDropdownModel(
      id: json['id'] as int,
      namaIuran: json['nama_iuran'] as String,
      nominalStandar: (json['nominal_standar'] as num).toDouble(),
      statusTagihan: namaKategori, // Isi dengan nama kategori
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_iuran': namaIuran,
      'nominal_standar': nominalStandar,
      'status_tagihan': statusTagihan,
    };
  }

  MasterIuranDropdown toEntity() {
    return MasterIuranDropdown(
      id: id,
      namaIuran: namaIuran,
      nominalStandar: nominalStandar,
      statusTagihan: statusTagihan,
    );
  }
}
