import 'package:dartz/dartz.dart';
import '../entities/keuangan_entity.dart';
import '../../../../core/errors/failure.dart';

abstract class DashboardKeuanganRepository {
  Future<Either<Failure, DashboardSummaryEntity>> getDashboardSummary(String year);
  
  Future<Either<Failure, List<String>>> getAvailableYears();
}
