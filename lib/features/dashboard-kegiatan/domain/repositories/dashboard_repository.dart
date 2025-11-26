import 'package:dartz/dartz.dart';
import '../entities/kegiatan_entity.dart';
import '../../../../core/errors/failure.dart';

/// Repository interface untuk Dashboard Kegiatan (READ-ONLY)
abstract class DashboardKegiatanRepository {
  /// Get dashboard kegiatan summary
  Future<Either<Failure, DashboardKegiatanEntity>> getDashboardKegiatan();
}
