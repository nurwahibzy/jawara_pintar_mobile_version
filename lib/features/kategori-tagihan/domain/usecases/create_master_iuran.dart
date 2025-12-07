import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/master_iuran.dart';
import '../repositories/master_iuran_repository.dart';

class CreateMasterIuran {
  final MasterIuranRepository repository;

  CreateMasterIuran(this.repository);

  Future<Either<Failure, MasterIuran>> call(MasterIuran masterIuran) async {
    return await repository.createMasterIuran(masterIuran);
  }
}
