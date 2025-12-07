import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/master_iuran.dart';
import '../repositories/master_iuran_repository.dart';

class GetMasterIuranList {
  final MasterIuranRepository repository;

  GetMasterIuranList(this.repository);

  Future<Either<Failure, List<MasterIuran>>> call() async {
    return await repository.getMasterIuranList();
  }
}
