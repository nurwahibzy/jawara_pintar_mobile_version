import 'package:dartz/dartz.dart';
import 'package:jawara_pintar_mobile_version/core/errors/failure.dart';
import 'package:jawara_pintar_mobile_version/features/rumah/domain/repositories/rumah_repository.dart';

class DeleteRumah {
  final RumahRepository repository;

  const DeleteRumah(this.repository);

  Future<Either<Failure, bool>> execute(int id) async {
    return await repository.deleteRumah(id);
  }
}
