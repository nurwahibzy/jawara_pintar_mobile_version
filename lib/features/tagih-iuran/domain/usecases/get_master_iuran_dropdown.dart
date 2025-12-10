import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/master_iuran_dropdown.dart';
import '../repositories/tagih_iuran_repository.dart';

class GetMasterIuranDropdown {
  final TagihIuranRepository repository;

  GetMasterIuranDropdown(this.repository);

  Future<Either<Failure, List<MasterIuranDropdown>>> call() async {
    return await repository.getMasterIuranDropdown();
  }
}
