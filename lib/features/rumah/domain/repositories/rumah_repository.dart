import 'package:jawara_pintar_mobile_version/features/rumah/domain/usecases/filter_rumah.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/rumah.dart';

abstract interface class RumahRepository {
  Future<Either<Failure, List<Rumah>>> getAllRumah();
  Future<Either<Failure, Rumah>> getRumahDetail(int id);
  Future<Either<Failure, bool>> createRumah(Rumah rumah);
  Future<Either<Failure, bool>> updateRumah(Rumah rumah);
  Future<Either<Failure, bool>> deleteRumah(int id);
  Future<Either<Failure, List<Rumah>>> filterRumah(FilterRumahParams params);
}
