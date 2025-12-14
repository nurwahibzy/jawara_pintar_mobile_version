import 'package:dartz/dartz.dart';
import 'package:jawara_pintar_mobile_version/core/errors/failure.dart';
import 'package:jawara_pintar_mobile_version/features/warga/domain/entities/warga.dart';
import 'package:jawara_pintar_mobile_version/features/warga/domain/entities/keluarga.dart';
import 'package:jawara_pintar_mobile_version/features/warga/domain/usecases/filter_warga.dart';

abstract class WargaRepository {
  Future<Either<Failure, List<Warga>>> getAllWarga();
  Future<Either<Failure, Warga>> getWarga(int id);
  Future<Either<Failure, bool>> createWarga(Warga warga);
  Future<Either<Failure, bool>> updateWarga(Warga warga);
  Future<Either<Failure, List<Warga>>> filterWarga(FilterWargaParams params);
  Future<Either<Failure, List<Keluarga>>> getAllKeluarga();
  Future<Either<Failure, List<Keluarga>>> searchKeluarga(String query);
  Future<Either<Failure, List<Keluarga>>> getAllKeluargaWithRelations();
  Future<Either<Failure, Keluarga>> getKeluargaById(int id);
  Future<Either<Failure, int>> createKeluarga(Keluarga keluarga);
  Future<Either<Failure, bool>> updateKeluarga(Keluarga keluarga);
  Future<Either<Failure, List<Map<String, dynamic>>>> getAllRumahSimple();
  Future<Either<Failure, List<Map<String, dynamic>>>> searchRumah(String query);
  Future<Either<Failure, List<Warga>>> getWargaTanpaKeluarga();
  Future<Either<Failure, bool>> updateWargaKeluargaId(
    List<int> wargaIds,
    int keluargaId,
  );
}
