import 'package:flutter_test/flutter_test.dart';
import 'package:jawara_pintar_mobile_version/features/dashboard-kegiatan/data/models/dashboard_kegiatan_model.dart';
import 'package:jawara_pintar_mobile_version/features/dashboard-kegiatan/domain/entities/kegiatan_entity.dart';

void main() {
  const tDashboardKegiatanModel = DashboardKegiatanModel(
    totalKegiatan: 10,
    kegiatanPerKategori: {'Rapat': 5, 'Kerja Bakti': 5},
    kegiatanBerdasarkanWaktu: {'Hari Ini': 2, 'Akan Datang': 8},
    penanggungJawabTerbanyak: [],
    kegiatanPerBulan: [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0],
  );

  test('should be a subclass of DashboardKegiatanEntity', () async {
    expect(tDashboardKegiatanModel, isA<DashboardKegiatanEntity>());
  });

  group('fromAggregatedData', () {
    test('should return a valid model from aggregated data', () {
      final result = DashboardKegiatanModel.fromAggregatedData(
        totalKegiatan: 10,
        kegiatanPerKategori: {'Rapat': 5, 'Kerja Bakti': 5},
        kegiatanBerdasarkanWaktu: {'Hari Ini': 2, 'Akan Datang': 8},
        penanggungJawabTerbanyak: [],
        kegiatanPerBulan: [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0],
      );

      expect(result, tDashboardKegiatanModel);
    });
  });

  group('toEntity', () {
    test('should return a valid entity', () {
      final result = tDashboardKegiatanModel.toEntity();
      expect(result, isA<DashboardKegiatanEntity>());
      expect(result.totalKegiatan, tDashboardKegiatanModel.totalKegiatan);
    });
  });
}
