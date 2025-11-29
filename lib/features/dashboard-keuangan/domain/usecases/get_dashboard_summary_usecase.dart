import 'package:dartz/dartz.dart';
import '../entities/keuangan_entity.dart';
import '../repositories/dashboard_repository.dart';
import '../../../../core/errors/failure.dart';

/// Use Case untuk mendapatkan dashboard summary
/// Menggabungkan data dari pemasukan_lain, pengeluaran, dan tagihan
class GetDashboardSummaryUseCase {
  final DashboardKeuanganRepository repository;

  GetDashboardSummaryUseCase(this.repository);

  /// Execute use case
  /// 
  /// [year] - Tahun yang ingin ditampilkan (format: '2025')
  Future<Either<Failure, DashboardSummaryEntity>> call(String year) async {
    // Validation
    if (year.isEmpty || year.length != 4) {
      return Left(ValidationFailure('Format tahun tidak valid'));
    }

    final yearInt = int.tryParse(year);
    if (yearInt == null || yearInt < 2000 || yearInt > 2100) {
      return Left(ValidationFailure('Tahun harus antara 2000-2100'));
    }

    return await repository.getDashboardSummary(year);
  }
}
