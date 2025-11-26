import 'package:equatable/equatable.dart';

/// Entity untuk Dashboard Summary Kegiatan
class DashboardKegiatanEntity extends Equatable {
  final int totalKegiatan;
  final Map<String, int> kegiatanPerKategori; // nama_kategori -> jumlah
  final Map<String, int> kegiatanBerdasarkanWaktu; // status -> jumlah
  final List<PenanggungJawabEntity> penanggungJawabTerbanyak;
  final List<int> kegiatanPerBulan; // 12 bulan

  const DashboardKegiatanEntity({
    required this.totalKegiatan,
    required this.kegiatanPerKategori,
    required this.kegiatanBerdasarkanWaktu,
    required this.penanggungJawabTerbanyak,
    required this.kegiatanPerBulan,
  });

  @override
  List<Object?> get props => [
        totalKegiatan,
        kegiatanPerKategori,
        kegiatanBerdasarkanWaktu,
        penanggungJawabTerbanyak,
        kegiatanPerBulan,
      ];
}

/// Entity untuk Penanggung Jawab
class PenanggungJawabEntity extends Equatable {
  final String nama;
  final int jumlah;

  const PenanggungJawabEntity({
    required this.nama,
    required this.jumlah,
  });

  @override
  List<Object?> get props => [nama, jumlah];
}
