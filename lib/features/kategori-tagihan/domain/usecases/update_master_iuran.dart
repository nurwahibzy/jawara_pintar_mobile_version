import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/master_iuran.dart';
import '../repositories/master_iuran_repository.dart';

class UpdateMasterIuran {
  final MasterIuranRepository repository;

  UpdateMasterIuran(this.repository);

  Future<Either<Failure, MasterIuran>> call(MasterIuran masterIuran) async {
    return await repository.updateMasterIuran(masterIuran);
  }
}
