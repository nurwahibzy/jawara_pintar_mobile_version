import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/master_iuran.dart';
import '../repositories/master_iuran_repository.dart';

class GetMasterIuranByKategori {
  final MasterIuranRepository repository;

  GetMasterIuranByKategori(this.repository);

  Future<Either<Failure, List<MasterIuran>>> call(int kategoriId) async {
    return await repository.getMasterIuranByKategori(kategoriId);
  }
}
