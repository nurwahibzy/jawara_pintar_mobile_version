import 'package:equatable/equatable.dart';

class RiwayatPenghuni extends Equatable {
  final String namaKeluarga;
  final String namaKepalaKeluarga;
  final DateTime tanggalMasuk;
  final DateTime? tanggalKeluar;

  const RiwayatPenghuni({
    required this.namaKeluarga,
    required this.namaKepalaKeluarga,
    required this.tanggalMasuk,
    this.tanggalKeluar,
  });

  @override
  List<Object?> get props => [namaKeluarga, namaKepalaKeluarga, tanggalMasuk, tanggalKeluar];
}