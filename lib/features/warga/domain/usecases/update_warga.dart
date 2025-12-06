import 'package:dartz/dartz.dart';
import 'package:jawara_pintar_mobile_version/core/errors/failure.dart';
import 'package:jawara_pintar_mobile_version/features/warga/domain/entities/warga.dart';
import 'package:jawara_pintar_mobile_version/features/warga/domain/repositories/warga_repository.dart';

class UpdateWarga {
  final WargaRepository repository;

  UpdateWarga(this.repository);

  Future<Either<Failure, bool>> execute(Warga warga) async {
    return await repository.updateWarga(warga);
  }
}
