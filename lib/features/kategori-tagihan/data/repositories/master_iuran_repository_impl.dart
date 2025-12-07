import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/master_iuran.dart';
import '../../domain/repositories/master_iuran_repository.dart';
import '../datasources/master_iuran_remote_datasource.dart';
import '../models/master_iuran_model.dart';

class MasterIuranRepositoryImpl implements MasterIuranRepository {
  final MasterIuranRemoteDataSource remoteDataSource;

  MasterIuranRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<MasterIuran>>> getMasterIuranList() async {
    try {
      final result = await remoteDataSource.getMasterIuranList();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, MasterIuran>> getMasterIuranById(int id) async {
    try {
      final result = await remoteDataSource.getMasterIuranById(id);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, MasterIuran>> createMasterIuran(
    MasterIuran masterIuran,
  ) async {
    try {
      final model = MasterIuranModel.fromEntity(masterIuran);
      final result = await remoteDataSource.createMasterIuran(model);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, MasterIuran>> updateMasterIuran(
    MasterIuran masterIuran,
  ) async {
    try {
      final model = MasterIuranModel.fromEntity(masterIuran);
      final result = await remoteDataSource.updateMasterIuran(model);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteMasterIuran(int id) async {
    try {
      await remoteDataSource.deleteMasterIuran(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MasterIuran>>> getMasterIuranByKategori(
    int kategoriId,
  ) async {
    try {
      final result = await remoteDataSource.getMasterIuranByKategori(
        kategoriId,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
