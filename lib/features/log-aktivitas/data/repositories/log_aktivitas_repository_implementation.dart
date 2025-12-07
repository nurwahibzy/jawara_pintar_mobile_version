import 'package:dartz/dartz.dart';
import '../datasources/log_aktivitas_datasource.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/log_aktivitas.dart';
import '../../domain/repositories/log_aktivitas_repository.dart';

class LogAktivitasRepositoryImplementation extends LogAktivitasRepository {
  final LogAktivitasDatasource datasource;

  LogAktivitasRepositoryImplementation({required this.datasource});

  @override
  Future<Either<Failure, List<LogAktivitas>>> getAllLogAktivitas() async {
    try {
      final result = await datasource.getAllLogAktivitas();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
