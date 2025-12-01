import 'package:dartz/dartz.dart';
import '../../domain/entities/kependudukan_entity.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/dashboard_remote_datasource.dart';
import '../models/dashboard_kependudukan_model.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/errors/exceptions.dart';

/// Implementation dari Dashboard Kependudukan Repository
class DashboardKependudukanRepositoryImpl
    implements DashboardKependudukanRepository {
  final DashboardKependudukanRemoteDataSource remoteDataSource;

  DashboardKependudukanRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, DashboardKependudukanEntity>>
      getDashboardKependudukan() async {
    try {
      // Fetch semua data secara parallel
      final results = await Future.wait([
        remoteDataSource.getTotalKeluarga(),
        remoteDataSource.getTotalPenduduk(),
        remoteDataSource.getStatusPenduduk(),
        remoteDataSource.getJenisKelamin(),
        remoteDataSource.getPekerjaanPenduduk(),
        remoteDataSource.getPeranDalamKeluarga(),
        remoteDataSource.getAgama(),
        remoteDataSource.getPendidikan(),
      ]);

      // Extract results
      final totalKeluarga = results[0] as int;
      final totalPenduduk = results[1] as int;
      final statusPenduduk = results[2] as Map<String, int>;
      final jenisKelamin = results[3] as Map<String, int>;
      final pekerjaanPenduduk = results[4] as Map<String, int>;
      final peranDalamKeluarga = results[5] as Map<String, int>;
      final agama = results[6] as Map<String, int>;
      final pendidikan = results[7] as Map<String, int>;

      // Buat model
      final model = DashboardKependudukanModel.fromAggregatedData(
        totalKeluarga: totalKeluarga,
        totalPenduduk: totalPenduduk,
        statusPenduduk: statusPenduduk,
        jenisKelamin: jenisKelamin,
        pekerjaanPenduduk: pekerjaanPenduduk,
        peranDalamKeluarga: peranDalamKeluarga,
        agama: agama,
        pendidikan: pendidikan,
      );

      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }
}
