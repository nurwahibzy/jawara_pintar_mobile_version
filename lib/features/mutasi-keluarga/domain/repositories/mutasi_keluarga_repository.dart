import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/mutasi_keluarga.dart';

abstract class MutasiKeluargaRepository {
  Future<Either<Failure, List<MutasiKeluarga>>> getAllMutasiKeluarga();
  Future<Either<Failure, MutasiKeluarga>> getMutasiKeluarga(int id);
  Future<Either<Failure, bool>> createMutasiKeluarga(MutasiKeluarga mutasi);
  Future<Either<Failure, Map<String, List<dynamic>>>> getFormDataOptions();
}
