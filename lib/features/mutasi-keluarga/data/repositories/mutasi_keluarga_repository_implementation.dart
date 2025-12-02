import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../domain/entities/mutasi_keluarga.dart';
import '../../domain/repositories/mutasi_keluarga_repository.dart';
import '../datasources/mutasi_keluarga_datasource.dart';
import '../models/mutasi_keluarga_models.dart';

class MutasiKeluargaRepositoryImplementation extends MutasiKeluargaRepository {
  final MutasiKeluargaDatasource datasource;

  MutasiKeluargaRepositoryImplementation({required this.datasource});

  @override
  Future<Either<Failure, bool>> createMutasiKeluarga(
    MutasiKeluarga mutasi,
  ) async {
    try {
      await datasource.createMutasiKeluarga(
        MutasiKeluargaModel.fromEntity(mutasi),
      );
      return Right(true);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MutasiKeluarga>>> getAllMutasiKeluarga() async {
    try {
      final result = await datasource.getAllMutasiKeluarga();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, MutasiKeluarga>> getMutasiKeluarga(int id) async {
    try {
      final result = await datasource.getMutasiKeluarga(id);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, List<dynamic>>>>
  getFormDataOptions() async {
    try {
      // Panggil kedua API secara paralel agar cepat
      final results = await Future.wait([
        datasource.getOptionKeluarga(),
        datasource.getOptionRumah(),
        datasource.getOptionWarga(),
      ]);
      return Right({'keluarga': results[0], 'rumah': results[1],'warga': results[2]});
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
