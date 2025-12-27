import 'package:flutter_test/flutter_test.dart';
import 'package:jawara_pintar_mobile_version/features/dashboard-kegiatan/domain/entities/kegiatan_entity.dart';

void main() {
  const tDashboardKegiatanEntity = DashboardKegiatanEntity(
    totalKegiatan: 10,
    kegiatanPerKategori: {'Rapat': 5},
    kegiatanBerdasarkanWaktu: {'Hari Ini': 2},
    penanggungJawabTerbanyak: [],
    kegiatanPerBulan: [],
  );

  test('should support value equality', () {
    const tDashboardKegiatanEntity2 = DashboardKegiatanEntity(
      totalKegiatan: 10,
      kegiatanPerKategori: {'Rapat': 5},
      kegiatanBerdasarkanWaktu: {'Hari Ini': 2},
      penanggungJawabTerbanyak: [],
      kegiatanPerBulan: [],
    );

    expect(tDashboardKegiatanEntity, equals(tDashboardKegiatanEntity2));
  });
}
