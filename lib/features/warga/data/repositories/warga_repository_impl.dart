import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:jawara_pintar_mobile_version/core/errors/failure.dart';
import 'package:jawara_pintar_mobile_version/features/warga/domain/entities/warga.dart';
import 'package:jawara_pintar_mobile_version/features/warga/domain/entities/keluarga.dart';
import 'package:jawara_pintar_mobile_version/features/warga/data/models/warga_model.dart';
import 'package:jawara_pintar_mobile_version/features/warga/data/models/keluarga_model.dart';
import 'package:jawara_pintar_mobile_version/features/warga/domain/usecases/filter_warga.dart';
import 'package:jawara_pintar_mobile_version/features/warga/data/datasources/warga_remote_datasource.dart';
import 'package:jawara_pintar_mobile_version/features/warga/domain/repositories/warga_repository.dart';

class WargaRepositoryImpl implements WargaRepository {
  final WargaRemoteDataSource remoteDataSource;

  WargaRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<WargaModel>>> getAllWarga() async {
    try {
      final result = await remoteDataSource.getAllWarga();
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
  Future<Either<Failure, Warga>> getWarga(int id) async {
    try {
      final result = await remoteDataSource.getWargaById(id);
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
  Future<Either<Failure, bool>> createWarga(Warga warga) async {
    try {
      final wargaModel = WargaModel.fromEntity(warga);
      await remoteDataSource.createWarga(wargaModel);
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
  Future<Either<Failure, bool>> updateWarga(Warga warga) async {
    try {
      final wargaModel = WargaModel.fromEntity(warga);
      await remoteDataSource.updateWarga(wargaModel);
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
  Future<Either<Failure, List<Warga>>> filterWarga(
    FilterWargaParams params,
  ) async {
    try {
      final result = await remoteDataSource.filterWarga(params);
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
  Future<Either<Failure, List<Keluarga>>> getAllKeluarga() async {
    try {
      final result = await remoteDataSource.getAllKeluarga();
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
  Future<Either<Failure, List<Keluarga>>> searchKeluarga(String query) async {
    try {
      final result = await remoteDataSource.searchKeluarga(query);
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
  Future<Either<Failure, List<Keluarga>>> getAllKeluargaWithRelations() async {
    try {
      final result = await remoteDataSource.getAllKeluargaWithRelations();
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
  Future<Either<Failure, Keluarga>> getKeluargaById(int id) async {
    try {
      final result = await remoteDataSource.getKeluargaById(id);
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
  Future<Either<Failure, List<Map<String, dynamic>>>>
  getAllRumahSimple() async {
    try {
      final result = await remoteDataSource.getAllRumahSimple();
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
  Future<Either<Failure, List<Map<String, dynamic>>>> searchRumah(
    String query,
  ) async {
    try {
      final result = await remoteDataSource.searchRumah(query);
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
  Future<Either<Failure, int>> createKeluarga(Keluarga keluarga) async {
    try {
      final keluargaModel = KeluargaModel.fromEntity(keluarga);
      final keluargaId = await remoteDataSource.createKeluarga(keluargaModel);
      return Right(keluargaId);
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
  Future<Either<Failure, bool>> updateKeluarga(Keluarga keluarga) async {
    try {
      final keluargaModel = KeluargaModel.fromEntity(keluarga);
      await remoteDataSource.updateKeluarga(keluargaModel);
      return const Right(true);
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
  Future<Either<Failure, List<Warga>>> getWargaTanpaKeluarga() async {
    try {
      final result = await remoteDataSource.getWargaTanpaKeluarga();
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
  Future<Either<Failure, bool>> updateWargaKeluargaId(
    List<int> wargaIds,
    int keluargaId,
  ) async {
    try {
      await remoteDataSource.updateWargaKeluargaId(wargaIds, keluargaId);
      return const Right(true);
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
}
