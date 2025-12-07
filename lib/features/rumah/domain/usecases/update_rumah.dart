import 'package:dartz/dartz.dart';
import 'package:jawara_pintar_mobile_version/core/errors/failure.dart';
import 'package:jawara_pintar_mobile_version/features/rumah/domain/entities/rumah.dart';
import 'package:jawara_pintar_mobile_version/features/rumah/domain/repositories/rumah_repository.dart';

class UpdateRumah {
  final RumahRepository repository;

  const UpdateRumah(this.repository);

  Future<Either<Failure, bool>> execute(Rumah rumah) async {
    return await repository.updateRumah(rumah);
  }
}
