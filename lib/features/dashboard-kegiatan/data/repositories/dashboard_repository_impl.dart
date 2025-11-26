import 'package:dartz/dartz.dart';
import '../../domain/entities/kegiatan_entity.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/dashboard_remote_datasource.dart';
import '../models/dashboard_kegiatan_model.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/errors/exceptions.dart';

/// Implementation dari Dashboard Kegiatan Repository
class DashboardKegiatanRepositoryImpl implements DashboardKegiatanRepository {
  final DashboardKegiatanRemoteDataSource remoteDataSource;

  DashboardKegiatanRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, DashboardKegiatanEntity>> getDashboardKegiatan() async {
    try {
      // Fetch semua data secara parallel
      final results = await Future.wait([
        remoteDataSource.getTotalKegiatan(),
        remoteDataSource.getKegiatanPerKategori(),
        remoteDataSource.getKegiatanBerdasarkanWaktu(),
        remoteDataSource.getPenanggungJawabTerbanyak(),
        remoteDataSource.getKegiatanPerBulan(),
      ]);

      // Extract results
      final totalKegiatan = results[0] as int;
      final kegiatanPerKategori = results[1] as Map<String, int>;
      final kegiatanBerdasarkanWaktu = results[2] as Map<String, int>;
      final penanggungJawabTerbanyak = results[3] as List<PenanggungJawabEntity>;
      final kegiatanPerBulan = results[4] as List<int>;

      // Buat model
      final model = DashboardKegiatanModel.fromAggregatedData(
        totalKegiatan: totalKegiatan,
        kegiatanPerKategori: kegiatanPerKategori,
        kegiatanBerdasarkanWaktu: kegiatanBerdasarkanWaktu,
        penanggungJawabTerbanyak: penanggungJawabTerbanyak,
        kegiatanPerBulan: kegiatanPerBulan,
      );

      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }
}
