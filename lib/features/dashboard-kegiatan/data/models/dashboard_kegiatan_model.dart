import '../../domain/entities/kegiatan_entity.dart';

/// Model untuk Dashboard Kegiatan
class DashboardKegiatanModel extends DashboardKegiatanEntity {
  const DashboardKegiatanModel({
    required int totalKegiatan,
    required Map<String, int> kegiatanPerKategori,
    required Map<String, int> kegiatanBerdasarkanWaktu,
    required List<PenanggungJawabEntity> penanggungJawabTerbanyak,
    required List<int> kegiatanPerBulan,
  }) : super(
          totalKegiatan: totalKegiatan,
          kegiatanPerKategori: kegiatanPerKategori,
          kegiatanBerdasarkanWaktu: kegiatanBerdasarkanWaktu,
          penanggungJawabTerbanyak: penanggungJawabTerbanyak,
          kegiatanPerBulan: kegiatanPerBulan,
        );

  /// Factory constructor dari aggregated data
  factory DashboardKegiatanModel.fromAggregatedData({
    required int totalKegiatan,
    required Map<String, int> kegiatanPerKategori,
    required Map<String, int> kegiatanBerdasarkanWaktu,
    required List<PenanggungJawabEntity> penanggungJawabTerbanyak,
    required List<int> kegiatanPerBulan,
  }) {
    return DashboardKegiatanModel(
      totalKegiatan: totalKegiatan,
      kegiatanPerKategori: kegiatanPerKategori,
      kegiatanBerdasarkanWaktu: kegiatanBerdasarkanWaktu,
      penanggungJawabTerbanyak: penanggungJawabTerbanyak,
      kegiatanPerBulan: kegiatanPerBulan,
    );
  }

  /// Convert to entity
  DashboardKegiatanEntity toEntity() {
    return DashboardKegiatanEntity(
      totalKegiatan: totalKegiatan,
      kegiatanPerKategori: kegiatanPerKategori,
      kegiatanBerdasarkanWaktu: kegiatanBerdasarkanWaktu,
      penanggungJawabTerbanyak: penanggungJawabTerbanyak,
      kegiatanPerBulan: kegiatanPerBulan,
    );
  }
}
