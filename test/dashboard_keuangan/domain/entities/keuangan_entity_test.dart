import 'package:flutter_test/flutter_test.dart';
import 'package:jawara_pintar_mobile_version/features/dashboard-keuangan/domain/entities/keuangan_entity.dart';

void main() {
  const tDashboardSummaryEntity = DashboardSummaryEntity(
    year: '2025',
    totalPemasukan: 1200000,
    totalPengeluaran: 600000,
    saldo: 600000,
    monthlyPemasukan: [100000, 100000, 100000, 100000, 100000, 100000, 100000, 100000, 100000, 100000, 100000, 100000],
    monthlyPengeluaran: [50000, 50000, 50000, 50000, 50000, 50000, 50000, 50000, 50000, 50000, 50000, 50000],
    kategoriPemasukan: {'Lainnya': 1200000},
    kategoriPengeluaran: {'Lainnya': 600000},
    availableYears: ['2024', '2025'],
  );

  test('should calculate average pemasukan correctly', () {
    expect(tDashboardSummaryEntity.getAveragePemasukan(), 100000);
  });

  test('should calculate average pengeluaran correctly', () {
    expect(tDashboardSummaryEntity.getAveragePengeluaran(), 50000);
  });

  test('should calculate percentage saldo correctly', () {
    expect(tDashboardSummaryEntity.getPercentageSaldo(), '50.0%');
  });

  test('should return true for hasPositiveBalance when saldo > 0', () {
    expect(tDashboardSummaryEntity.hasPositiveBalance(), true);
  });

  test('should return true for hasData when totalPemasukan or totalPengeluaran > 0', () {
    expect(tDashboardSummaryEntity.hasData(), true);
  });
}
