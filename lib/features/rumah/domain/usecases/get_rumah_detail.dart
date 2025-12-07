import 'package:dartz/dartz.dart';
import 'package:jawara_pintar_mobile_version/core/errors/failure.dart';
import 'package:jawara_pintar_mobile_version/features/rumah/domain/entities/rumah.dart';
import 'package:jawara_pintar_mobile_version/features/rumah/domain/repositories/rumah_repository.dart';

class GetRumahDetail {
  final RumahRepository repository;

  const GetRumahDetail(this.repository);

  Future<Either<Failure, Rumah>> execute(int id) async {
    return await repository.getRumahDetail(id);
  }
}
