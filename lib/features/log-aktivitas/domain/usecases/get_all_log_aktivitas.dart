import 'package:dartz/dartz.dart';
import '../entities/log_aktivitas.dart';
import '../repositories/log_aktivitas_repository.dart';

import '../../../../core/errors/failure.dart';

class GetAllLogAktivitas {
  final LogAktivitasRepository logAktivitasRepository;

  const GetAllLogAktivitas(this.logAktivitasRepository);

  Future<Either<Failure, List<LogAktivitas>>> execute() async {
    return await logAktivitasRepository.getAllLogAktivitas();
  }
}
