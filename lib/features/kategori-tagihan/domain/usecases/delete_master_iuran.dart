import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../repositories/master_iuran_repository.dart';

class DeleteMasterIuran {
  final MasterIuranRepository repository;

  DeleteMasterIuran(this.repository);

  Future<Either<Failure, void>> call(int id) async {
    return await repository.deleteMasterIuran(id);
  }
}
