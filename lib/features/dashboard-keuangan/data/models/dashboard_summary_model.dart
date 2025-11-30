import '../../domain/entities/keuangan_entity.dart';

/// Model untuk Dashboard Summary
/// Melakukan mapping dari JSON Supabase ke Entity
class DashboardSummaryModel extends DashboardSummaryEntity {
  const DashboardSummaryModel({
    required super.year,
    required super.totalPemasukan,
    required super.totalPengeluaran,
    required super.saldo,
    required super.monthlyPemasukan,
    required super.monthlyPengeluaran,
    required super.kategoriPemasukan,
    required super.kategoriPengeluaran,
    required super.availableYears,
  });

  /// Factory constructor dari aggregated data
  /// Data sudah dihitung di repository implementation
  factory DashboardSummaryModel.fromAggregatedData({
    required String year,
    required double totalPemasukan,
    required double totalPengeluaran,
    required List<double> monthlyPemasukan,
    required List<double> monthlyPengeluaran,
    required Map<String, double> kategoriPemasukan,
    required Map<String, double> kategoriPengeluaran,
    required List<String> availableYears,
  }) {
    return DashboardSummaryModel(
      year: year,
      totalPemasukan: totalPemasukan,
      totalPengeluaran: totalPengeluaran,
      saldo: totalPemasukan - totalPengeluaran,
      monthlyPemasukan: monthlyPemasukan,
      monthlyPengeluaran: monthlyPengeluaran,
      kategoriPemasukan: kategoriPemasukan,
      kategoriPengeluaran: kategoriPengeluaran,
      availableYears: availableYears,
    );
  }

  /// Convert to entity
  DashboardSummaryEntity toEntity() {
    return DashboardSummaryEntity(
      year: year,
      totalPemasukan: totalPemasukan,
      totalPengeluaran: totalPengeluaran,
      saldo: saldo,
      monthlyPemasukan: monthlyPemasukan,
      monthlyPengeluaran: monthlyPengeluaran,
      kategoriPemasukan: kategoriPemasukan,
      kategoriPengeluaran: kategoriPengeluaran,
      availableYears: availableYears,
    );
  }
}
