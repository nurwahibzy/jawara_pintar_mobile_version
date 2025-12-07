import 'package:equatable/equatable.dart';
import 'kategori_iuran.dart';

class MasterIuran extends Equatable {
  final int id;
  final int kategoriIuranId;
  final String namaIuran;
  final double nominalStandar;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // Relasi ke Kategori Iuran
  final KategoriIuran? kategoriIuran;

  const MasterIuran({
    required this.id,
    required this.kategoriIuranId,
    required this.namaIuran,
    required this.nominalStandar,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
    this.kategoriIuran,
  });

  // Getter untuk nama kategori (untuk display di UI)
  String get namaKategori => kategoriIuran?.namaKategori ?? '-';

  // Getter untuk jenis kategori (untuk display di UI)
  String get jenisKategori {
    if (kategoriIuran == null) return '-';

    switch (kategoriIuran!.namaKategori) {
      case 'Iuran Bulanan':
        return 'Iuran Bulanan';
      case 'Iuran Khusus':
        return 'Iuran Khusus';
      default:
        return kategoriIuran!.namaKategori;
    }
  }

  // Format nominal ke Rupiah
  String get formattedNominal {
    final formatter = nominalStandar.toStringAsFixed(2);
    final parts = formatter.split('.');
    final intPart = parts[0].replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
    return 'Rp $intPart,${parts[1]}';
  }

  // Status aktif dalam bentuk text
  String get statusText => isActive ? 'Aktif' : 'Tidak Aktif';

  @override
  List<Object?> get props => [
    id,
    kategoriIuranId,
    namaIuran,
    nominalStandar,
    isActive,
    createdAt,
    updatedAt,
    kategoriIuran,
  ];

  // CopyWith untuk immutability
  MasterIuran copyWith({
    int? id,
    int? kategoriIuranId,
    String? namaIuran,
    double? nominalStandar,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    KategoriIuran? kategoriIuran,
  }) {
    return MasterIuran(
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

  @override
  String toString() {
    return 'MasterIuran(id: $id, namaIuran: $namaIuran, kategori: $namaKategori, nominal: $formattedNominal, isActive: $isActive)';
  }
}
