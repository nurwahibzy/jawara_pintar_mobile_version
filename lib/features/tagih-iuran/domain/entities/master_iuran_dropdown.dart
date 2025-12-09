import 'package:equatable/equatable.dart';

class MasterIuranDropdown extends Equatable {
  final int id;
  final String namaIuran;
  final double nominalStandar;
  final String statusTagihan;

  const MasterIuranDropdown({
    required this.id,
    required this.namaIuran,
    required this.nominalStandar,
    required this.statusTagihan,
  });

  // Helper method untuk cek apakah tagihan bulanan
  bool get isBulanan => statusTagihan == 'Bulanan';

  @override
  List<Object?> get props => [id, namaIuran, nominalStandar, statusTagihan];
}
