import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/master_iuran.dart';
import '../repositories/master_iuran_repository.dart';

class GetMasterIuranById {
  final MasterIuranRepository repository;

  GetMasterIuranById(this.repository);

  Future<Either<Failure, MasterIuran>> call(int id) async {
    return await repository.getMasterIuranById(id);
  }
}
