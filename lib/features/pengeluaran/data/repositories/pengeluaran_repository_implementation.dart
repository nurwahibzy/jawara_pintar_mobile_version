import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/pengeluaran.dart';
import '../../domain/entities/kategori_transaksi.dart';
import '../../domain/repositories/pengeluaran_repository.dart';
import '../datasources/remote_datasource.dart';
import '../models/pengeluaran_model.dart';

class PengeluaranRepositoryImpl implements PengeluaranRepository {
  final PengeluaranRemoteDataSource remote;

  PengeluaranRepositoryImpl(this.remote);

  // ================= Pengeluaran CRUD =================
  @override
  Future<Either<Failure, List<Pengeluaran>>> getAllPengeluaran() async {
    try {
      final result = await remote.getAllPengeluaran();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Pengeluaran>> getPengeluaranById(int id) async {
    try {
      final result = await remote.getPengeluaranById(id);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> createPengeluaran(
    Pengeluaran pengeluaran,
  ) async {
    try {
      await remote.createPengeluaran(PengeluaranModel.fromEntity(pengeluaran));
      return Right(true);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> updatePengeluaran(
    Pengeluaran pengeluaran,
  ) async {
    try {
      await remote.updatePengeluaran(PengeluaranModel.fromEntity(pengeluaran));
      return Right(true);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deletePengeluaran(int id) async {
    try {
      await remote.deletePengeluaran(id);
      return Right(true);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // ================= Kategori untuk Pengeluaran =================
  @override
  Future<Either<Failure, List<KategoriEntity>>> getKategoriPengeluaran() async {
    try {
      final result = await remote
          .getKategoriPengeluaran(); 
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}