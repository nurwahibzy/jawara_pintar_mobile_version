import 'package:dartz/dartz.dart';
import 'package:jawara_pintar_mobile_version/core/errors/failure.dart';
import 'package:jawara_pintar_mobile_version/features/rumah/domain/entities/rumah.dart';
import 'package:jawara_pintar_mobile_version/features/rumah/domain/repositories/rumah_repository.dart';

class GetAllRumah {
  final RumahRepository repository;

  const GetAllRumah(this.repository);

  Future<Either<Failure, List<Rumah>>> execute() async {
    return await repository.getAllRumah();
  }
}
