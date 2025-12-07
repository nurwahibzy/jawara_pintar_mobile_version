import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/rumah.dart';
import '../repositories/rumah_repository.dart';

class CreateRumah {
  final RumahRepository repository;

  CreateRumah(this.repository);

  Future<Either<Failure, bool>> execute(Rumah rumah) async {
    return await repository.createRumah(rumah);
  }
}