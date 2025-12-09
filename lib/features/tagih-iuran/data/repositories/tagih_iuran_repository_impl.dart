import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/tagih_iuran.dart';
import '../../domain/entities/master_iuran_dropdown.dart';
import '../../domain/repositories/tagih_iuran_repository.dart';
import '../datasources/tagih_iuran_remote_datasource.dart';

class TagihIuranRepositoryImpl implements TagihIuranRepository {
  final TagihIuranRemoteDataSource remoteDataSource;

  TagihIuranRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<MasterIuranDropdown>>>
  getMasterIuranDropdown() async {
    try {
      final result = await remoteDataSource.getMasterIuranDropdown();
      // Convert models to entities
      final entities = result.map((model) => model.toEntity()).toList();
      return Right(entities);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TagihIuran>>> createTagihIuran({
    required int masterIuranId,
    required String periode,
  }) async {
    try {
      await remoteDataSource.createTagihIuran(
        masterIuranId: masterIuranId,
        periode: periode,
      );

      // Return empty list karena kita hanya perlu tahu berhasil atau tidak
      // Actual data akan di-fetch ulang dari list page
      return const Right([]);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
