import 'package:dartz/dartz.dart';
import '../entities/kegiatan_entity.dart';
import '../repositories/dashboard_repository.dart';
import '../../../../core/errors/failure.dart';

/// Use Case untuk mendapatkan dashboard kegiatan summary
class GetDashboardKegiatanUseCase {
  final DashboardKegiatanRepository repository;

  GetDashboardKegiatanUseCase(this.repository);

  Future<Either<Failure, DashboardKegiatanEntity>> call() async {
    return await repository.getDashboardKegiatan();
  }
}
