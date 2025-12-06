import 'package:dartz/dartz.dart';
import 'package:jawara_pintar_mobile_version/core/errors/failure.dart';
import 'package:jawara_pintar_mobile_version/features/warga/domain/entities/warga.dart';
import 'package:jawara_pintar_mobile_version/features/warga/domain/repositories/warga_repository.dart';

class CreateWarga {
  final WargaRepository repository;

  CreateWarga(this.repository);

  Future<Either<Failure, bool>> execute(Warga warga) async {
    return await repository.createWarga(warga);
  }
}
