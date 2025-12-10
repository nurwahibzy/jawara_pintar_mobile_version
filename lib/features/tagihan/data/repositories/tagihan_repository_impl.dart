import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/tagihan_pembayaran.dart';
import '../../domain/repositories/tagihan_repository.dart';
import '../datasources/tagihan_remote_datasource.dart';

class TagihanRepositoryImpl implements TagihanRepository {
  final TagihanRemoteDataSource remoteDataSource;

  TagihanRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<TagihanPembayaran>>> getTagihanPembayaranList({
    String? statusFilter,
    String? metodeFilter,
  }) async {
    try {
      final result = await remoteDataSource.getTagihanPembayaranList(
        statusFilter: statusFilter,
        metodeFilter: metodeFilter,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TagihanPembayaran>> getTagihanPembayaranDetail(
    int id,
  ) async {
    try {
      final result = await remoteDataSource.getTagihanPembayaranDetail(id);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> approveTagihanPembayaran({
    required int id,
    String? keterangan,
  }) async {
    try {
      await remoteDataSource.approveTagihanPembayaran(
        id: id,
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
  Future<Either<Failure, void>> rejectTagihanPembayaran({
    required int id,
    required String keterangan,
  }) async {
    try {
      await remoteDataSource.rejectTagihanPembayaran(
        id: id,
        keterangan: keterangan,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
