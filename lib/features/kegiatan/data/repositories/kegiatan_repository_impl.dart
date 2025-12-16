import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/kegiatan.dart';
import '../../domain/entities/transaksi_kegiatan.dart';
import '../../domain/repositories/kegiatan_repository.dart';
import '../datasources/kegiatan_remote_datasource.dart';
import '../models/kegiatan_model.dart';
import '../models/transaksi_kegiatan_model.dart';

class KegiatanRepositoryImpl implements KegiatanRepository {
  final KegiatanRemoteDataSource remoteDataSource;

  KegiatanRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Kegiatan>>> getKegiatanList() async {
    try {
      final result = await remoteDataSource.getKegiatanList();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Kegiatan>> getKegiatanDetail(int id) async {
    try {
      final result = await remoteDataSource.getKegiatanDetail(id);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> createKegiatan(Kegiatan kegiatan) async {
    try {
      final model = KegiatanModel.fromEntity(kegiatan);
      await remoteDataSource.createKegiatan(model);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> updateKegiatan(Kegiatan kegiatan) async {
    try {
      final model = KegiatanModel.fromEntity(kegiatan);
      await remoteDataSource.updateKegiatan(model);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  // ==================== TRANSAKSI METHODS ====================

  @override
  Future<Either<Failure, List<TransaksiKegiatan>>> getTransaksiByKegiatan(
    int kegiatanId,
  ) async {
    try {
      final result = await remoteDataSource.getTransaksiByKegiatan(kegiatanId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> createTransaksi(
    TransaksiKegiatan transaksi,
  ) async {
    try {
      final model = TransaksiKegiatanModel.fromEntity(transaksi);
      await remoteDataSource.createTransaksi(model);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTransaksi(int transaksiId) async {
    try {
      await remoteDataSource.deleteTransaksi(transaksiId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
