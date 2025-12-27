import 'package:flutter_test/flutter_test.dart';
import 'package:jawara_pintar_mobile_version/features/dashboard-kependudukan/data/models/dashboard_kependudukan_model.dart';
import 'package:jawara_pintar_mobile_version/features/dashboard-kependudukan/domain/entities/kependudukan_entity.dart';

void main() {
  const tDashboardKependudukanModel = DashboardKependudukanModel(
    totalKeluarga: 10,
    totalPenduduk: 40,
    statusPenduduk: {'Aktif': 40},
    jenisKelamin: {'Laki-laki': 20, 'Perempuan': 20},
    pekerjaanPenduduk: {'PNS': 5},
    peranDalamKeluarga: {'Kepala Keluarga': 10},
    agama: {'Islam': 40},
    pendidikan: {'S1': 10},
  );

  test('should be a subclass of DashboardKependudukanEntity', () async {
    expect(tDashboardKependudukanModel, isA<DashboardKependudukanEntity>());
  });

  group('fromAggregatedData', () {
    test('should return a valid model from aggregated data', () {
      final result = DashboardKependudukanModel.fromAggregatedData(
        totalKeluarga: 10,
        totalPenduduk: 40,
        statusPenduduk: {'Aktif': 40},
        jenisKelamin: {'Laki-laki': 20, 'Perempuan': 20},
        pekerjaanPenduduk: {'PNS': 5},
        peranDalamKeluarga: {'Kepala Keluarga': 10},
        agama: {'Islam': 40},
        pendidikan: {'S1': 10},
      );

      expect(result, tDashboardKependudukanModel);
    });
  });

  group('toEntity', () {
    test('should return a valid entity', () {
      final result = tDashboardKependudukanModel.toEntity();
      expect(result, isA<DashboardKependudukanEntity>());
      expect(result.totalKeluarga, tDashboardKependudukanModel.totalKeluarga);
    });
  });
}
