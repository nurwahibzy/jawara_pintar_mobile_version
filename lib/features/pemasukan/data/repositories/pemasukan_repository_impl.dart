import 'dart:io';

import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/pemasukan.dart';
import '../../domain/repositories/pemasukan_repository.dart';
import '../datasources/pemasukan_remote_datasource.dart';

class PemasukanRepositoryImpl implements PemasukanRepository {
  final PemasukanRemoteDataSource remoteDataSource;

  PemasukanRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Pemasukan>>> getPemasukanList({
    String? kategoriFilter,
  }) async {
    try {
      final result = await remoteDataSource.getPemasukanList(
        kategoriFilter: kategoriFilter,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Pemasukan>> getPemasukanDetail(int id) async {
    try {
      final result = await remoteDataSource.getPemasukanDetail(id);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> createPemasukan({
    required String judul,
    required int kategoriTransaksiId,
    required double nominal,
    required String tanggalTransaksi,
    String? buktiFoto,
    required String keterangan,
  }) async {
    try {
      await remoteDataSource.createPemasukan(
        judul: judul,
        kategoriTransaksiId: kategoriTransaksiId,
        nominal: nominal,
        tanggalTransaksi: tanggalTransaksi,
        buktiFoto: buktiFoto,
        keterangan: keterangan,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updatePemasukan({
    required int id,
    required String judul,
    required int kategoriTransaksiId,
    required double nominal,
    required String tanggalTransaksi,
    String? buktiFoto,
    required String keterangan,
  }) async {
    try {
      await remoteDataSource.updatePemasukan(
        id: id,
        judul: judul,
        kategoriTransaksiId: kategoriTransaksiId,
        nominal: nominal,
        tanggalTransaksi: tanggalTransaksi,
        buktiFoto: buktiFoto,
        keterangan: keterangan,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deletePemasukan(int id) async {
    try {
      await remoteDataSource.deletePemasukan(id);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<String?> uploadBukti(File file, {String? oldUrl}) async {
    return await remoteDataSource.uploadBukti(file, oldUrl: oldUrl);
  }
}
