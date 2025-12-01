import 'package:dartz/dartz.dart';
import '../entities/kependudukan_entity.dart';
import '../../../../core/errors/failure.dart';

/// Repository interface untuk Dashboard Kependudukan (READ-ONLY)
abstract class DashboardKependudukanRepository {
  /// Get dashboard kependudukan summary
  Future<Either<Failure, DashboardKependudukanEntity>> getDashboardKependudukan();
}
