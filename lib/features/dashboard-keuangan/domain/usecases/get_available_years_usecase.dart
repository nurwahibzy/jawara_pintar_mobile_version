import 'package:dartz/dartz.dart';
import '../repositories/dashboard_repository.dart';
import '../../../../core/errors/failure.dart';

/// Use Case untuk mendapatkan daftar tahun yang tersedia
class GetAvailableYearsUseCase {
  final DashboardKeuanganRepository repository;

  GetAvailableYearsUseCase(this.repository);

  Future<Either<Failure, List<String>>> call() async {
    return await repository.getAvailableYears();
  }
}
