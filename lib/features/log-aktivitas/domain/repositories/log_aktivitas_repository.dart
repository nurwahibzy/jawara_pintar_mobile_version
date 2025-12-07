import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/log_aktivitas.dart';

abstract class LogAktivitasRepository {
  Future<Either<Failure, List<LogAktivitas>>> getAllLogAktivitas();
}
