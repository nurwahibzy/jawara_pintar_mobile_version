import 'package:equatable/equatable.dart';

/// Entity untuk Dashboard Summary Kependudukan
class DashboardKependudukanEntity extends Equatable {
  final int totalKeluarga;
  final int totalPenduduk;
  final Map<String, int> statusPenduduk; // Aktif, Nonaktif
  final Map<String, int> jenisKelamin; // Laki-laki, Perempuan
  final Map<String, int> pekerjaanPenduduk; // PNS, Swasta, Wiraswasta, Lainnya
  final Map<String, int> peranDalamKeluarga; // Kepala Keluarga, Istri, Anak, Lainnya
  final Map<String, int> agama; // Islam, Kristen, Katolik, Hindu, Buddha
  final Map<String, int> pendidikan; // SD, SMP, SMA, D3, S1, S2

  const DashboardKependudukanEntity({
    required this.totalKeluarga,
    required this.totalPenduduk,
    required this.statusPenduduk,
    required this.jenisKelamin,
    required this.pekerjaanPenduduk,
    required this.peranDalamKeluarga,
    required this.agama,
    required this.pendidikan,
  });

  @override
  List<Object?> get props => [
        totalKeluarga,
        totalPenduduk,
        statusPenduduk,
        jenisKelamin,
        pekerjaanPenduduk,
        peranDalamKeluarga,
        agama,
        pendidikan,
      ];
}
