import 'package:dartz/dartz.dart';
import '../entities/kependudukan_entity.dart';
import '../repositories/dashboard_repository.dart';
import '../../../../core/errors/failure.dart';

/// Use Case untuk mendapatkan dashboard kependudukan summary
class GetDashboardKependudukanUseCase {
  final DashboardKependudukanRepository repository;

  GetDashboardKependudukanUseCase(this.repository);

  Future<Either<Failure, DashboardKependudukanEntity>> call() async {
    return await repository.getDashboardKependudukan();
  }
}
