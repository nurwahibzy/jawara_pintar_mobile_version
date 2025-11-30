import 'package:dartz/dartz.dart';
import '../../domain/entities/keuangan_entity.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/dashboard_remote_datasource.dart';
import '../models/dashboard_summary_model.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/errors/exceptions.dart';

/// Implementation dari Dashboard Repository
/// Menggunakan remote data source untuk akses Supabase
class DashboardKeuanganRepositoryImpl implements DashboardKeuanganRepository {
  final DashboardRemoteDataSource remoteDataSource;

  DashboardKeuanganRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, DashboardSummaryEntity>> getDashboardSummary(
    String year,
  ) async {
    try {
      // Fetch semua data secara parallel
      final results = await Future.wait([
        remoteDataSource.getTotalPemasukanByYear(year),
        remoteDataSource.getTotalPengeluaranByYear(year),
        remoteDataSource.getMonthlyPemasukan(year),
        remoteDataSource.getMonthlyPengeluaran(year),
        remoteDataSource.getKategoriPemasukanSummary(year),
        remoteDataSource.getKategoriPengeluaranSummary(year),
        remoteDataSource.getAvailableYears(),
      ]);

      // Extract results
      final totalPemasukan = results[0] as double;
      final totalPengeluaran = results[1] as double;
      final monthlyPemasukan = results[2] as List<double>;
      final monthlyPengeluaran = results[3] as List<double>;
      final kategoriPemasukan = results[4] as Map<String, double>;
      final kategoriPengeluaran = results[5] as Map<String, double>;
      final availableYears = results[6] as List<String>;

      // Buat model
      final model = DashboardSummaryModel.fromAggregatedData(
        year: year,
        totalPemasukan: totalPemasukan,
        totalPengeluaran: totalPengeluaran,
        monthlyPemasukan: monthlyPemasukan,
        monthlyPengeluaran: monthlyPengeluaran,
        kategoriPemasukan: kategoriPemasukan,
        kategoriPengeluaran: kategoriPengeluaran,
        availableYears: availableYears,
      );

      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getAvailableYears() async {
    try {
      final years = await remoteDataSource.getAvailableYears();
      return Right(years);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }
}
