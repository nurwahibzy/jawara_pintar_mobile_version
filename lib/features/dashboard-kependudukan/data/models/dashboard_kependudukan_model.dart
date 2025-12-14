import '../../domain/entities/kependudukan_entity.dart';

/// Model untuk Dashboard Kependudukan
class DashboardKependudukanModel extends DashboardKependudukanEntity {
  const DashboardKependudukanModel({
    required super.totalKeluarga,
    required super.totalPenduduk,
    required super.statusPenduduk,
    required super.jenisKelamin,
    required super.pekerjaanPenduduk,
    required super.peranDalamKeluarga,
    required super.agama,
    required super.pendidikan,
  });

  /// Factory constructor dari aggregated data
  factory DashboardKependudukanModel.fromAggregatedData({
    required int totalKeluarga,
    required int totalPenduduk,
    required Map<String, int> statusPenduduk,
    required Map<String, int> jenisKelamin,
    required Map<String, int> pekerjaanPenduduk,
    required Map<String, int> peranDalamKeluarga,
    required Map<String, int> agama,
    required Map<String, int> pendidikan,
  }) {
    return DashboardKependudukanModel(
      totalKeluarga: totalKeluarga,
      totalPenduduk: totalPenduduk,
      statusPenduduk: statusPenduduk,
      jenisKelamin: jenisKelamin,
      pekerjaanPenduduk: pekerjaanPenduduk,
      peranDalamKeluarga: peranDalamKeluarga,
      agama: agama,
      pendidikan: pendidikan,
    );
  }

  /// Convert to entity
  DashboardKependudukanEntity toEntity() {
    return DashboardKependudukanEntity(
      totalKeluarga: totalKeluarga,
      totalPenduduk: totalPenduduk,
      statusPenduduk: statusPenduduk,
      jenisKelamin: jenisKelamin,
      pekerjaanPenduduk: pekerjaanPenduduk,
      peranDalamKeluarga: peranDalamKeluarga,
      agama: agama,
      pendidikan: pendidikan,
    );
  }
}
