import 'package:flutter_test/flutter_test.dart';
import 'package:jawara_pintar_mobile_version/features/dashboard-keuangan/data/models/dashboard_summary_model.dart';
import 'package:jawara_pintar_mobile_version/features/dashboard-keuangan/domain/entities/keuangan_entity.dart';

void main() {
  const tDashboardSummaryModel = DashboardSummaryModel(
    year: '2025',
    totalPemasukan: 1000000,
    totalPengeluaran: 500000,
    saldo: 500000,
    monthlyPemasukan: [100000, 100000, 100000, 100000, 100000, 100000, 100000, 100000, 100000, 100000, 0, 0],
    monthlyPengeluaran: [50000, 50000, 50000, 50000, 50000, 50000, 50000, 50000, 50000, 50000, 0, 0],
    kategoriPemasukan: {'Lainnya': 1000000},
    kategoriPengeluaran: {'Lainnya': 500000},
    availableYears: ['2024', '2025'],
  );

  test('should be a subclass of DashboardSummaryEntity', () async {
    expect(tDashboardSummaryModel, isA<DashboardSummaryEntity>());
  });

  group('fromAggregatedData', () {
    test('should return a valid model from aggregated data', () {
      final result = DashboardSummaryModel.fromAggregatedData(
        year: '2025',
        totalPemasukan: 1000000,
        totalPengeluaran: 500000,
        monthlyPemasukan: [100000, 100000, 100000, 100000, 100000, 100000, 100000, 100000, 100000, 100000, 0, 0],
        monthlyPengeluaran: [50000, 50000, 50000, 50000, 50000, 50000, 50000, 50000, 50000, 50000, 0, 0],
        kategoriPemasukan: {'Lainnya': 1000000},
        kategoriPengeluaran: {'Lainnya': 500000},
        availableYears: ['2024', '2025'],
      );

      expect(result, tDashboardSummaryModel);
      expect(result.saldo, 500000);
    });
  });

  group('toEntity', () {
    test('should return a valid entity', () {
      final result = tDashboardSummaryModel.toEntity();
      expect(result, isA<DashboardSummaryEntity>());
      expect(result.year, tDashboardSummaryModel.year);
    });
  });
}
