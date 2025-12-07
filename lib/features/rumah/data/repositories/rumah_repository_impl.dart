import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:jawara_pintar_mobile_version/core/errors/failure.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:jawara_pintar_mobile_version/features/rumah/domain/entities/rumah.dart';
import 'package:jawara_pintar_mobile_version/features/rumah/data/models/rumah_model.dart';
import 'package:jawara_pintar_mobile_version/features/rumah/domain/usecases/filter_rumah.dart';
import 'package:jawara_pintar_mobile_version/features/rumah/domain/repositories/rumah_repository.dart';
import 'package:jawara_pintar_mobile_version/features/rumah/data/datasources/rumah_remote_datasource.dart';

class RumahRepositoryImpl implements RumahRepository {
  final RumahRemoteDataSource remoteDataSource;

  RumahRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, bool>> createRumah(Rumah rumah) async {
    try {
      final rumahModel = RumahModel.fromEntity(rumah);
      await remoteDataSource.createRumah(rumahModel);
      return Right(true);
    } on PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } on SocketException catch (_) {
      return Left(const NetworkFailure('Tidak ada koneksi internet'));
    } on Exception catch (e) {
      if (e.toString().toLowerCase().contains('connection failed') ||
          e.toString().toLowerCase().contains('failed host lookup') ||
          e.toString().toLowerCase().contains('timeout')) {
        return Left(const NetworkFailure('Tidak ada koneksi internet'));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Rumah>>> filterRumah(
    FilterRumahParams params,
  ) async {
    try {
      final result = await remoteDataSource.filterRumah(params);
      return Right(result);
    } on PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } on SocketException catch (_) {
      return Left(const NetworkFailure('Tidak ada koneksi internet'));
    } on Exception catch (e) {
      if (e.toString().toLowerCase().contains('connection failed') ||
          e.toString().toLowerCase().contains('failed host lookup') ||
          e.toString().toLowerCase().contains('timeout')) {
        return Left(const NetworkFailure('Tidak ada koneksi internet'));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Rumah>>> getAllRumah() async {
    try {
      final result = await remoteDataSource.getAllRumah();
      return Right(result);
    } on PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } on SocketException catch (_) {
      return Left(const NetworkFailure('Tidak ada koneksi internet'));
    } on Exception catch (e) {
      if (e.toString().toLowerCase().contains('connection failed') ||
          e.toString().toLowerCase().contains('failed host lookup') ||
          e.toString().toLowerCase().contains('timeout')) {
        return Left(const NetworkFailure('Tidak ada koneksi internet'));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Rumah>> getRumahDetail(int id) async {
    try {
      final result = await remoteDataSource.getRumahById(id);
      return Right(result);
    } on PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } on SocketException catch (_) {
      return Left(const NetworkFailure('Tidak ada koneksi internet'));
    } on Exception catch (e) {
      if (e.toString().toLowerCase().contains('connection failed') ||
          e.toString().toLowerCase().contains('failed host lookup') ||
          e.toString().toLowerCase().contains('timeout')) {
        return Left(const NetworkFailure('Tidak ada koneksi internet'));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> updateRumah(Rumah rumah) async {
    try {
      final rumahModel = RumahModel.fromEntity(rumah);
      await remoteDataSource.updateRumah(rumahModel);
      return Right(true);
    } on PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } on SocketException catch (_) {
      return Left(const NetworkFailure('Tidak ada koneksi internet'));
    } on Exception catch (e) {
      if (e.toString().toLowerCase().contains('connection failed') ||
          e.toString().toLowerCase().contains('failed host lookup') ||
          e.toString().toLowerCase().contains('timeout')) {
        return Left(const NetworkFailure('Tidak ada koneksi internet'));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteRumah(int id) async {
    try {
      await remoteDataSource.deleteRumah(id);
      return Right(true);
    } on PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } on SocketException catch (_) {
      return Left(const NetworkFailure('Tidak ada koneksi internet'));
    } on Exception catch (e) {
      if (e.toString().toLowerCase().contains('hanya bisa dihapus')) {
        return Left(
          ServerFailure('Rumah hanya bisa dihapus jika statusnya Kosong'),
        );
      }
      if (e.toString().toLowerCase().contains('connection failed') ||
          e.toString().toLowerCase().contains('failed host lookup') ||
          e.toString().toLowerCase().contains('timeout')) {
        return Left(const NetworkFailure('Tidak ada koneksi internet'));
      }
      return Left(ServerFailure(e.toString()));
    }
  }
}
