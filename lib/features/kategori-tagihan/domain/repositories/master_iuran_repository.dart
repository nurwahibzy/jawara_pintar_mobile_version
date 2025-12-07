import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/master_iuran.dart';

abstract class MasterIuranRepository {
  Future<Either<Failure, List<MasterIuran>>> getMasterIuranList();
  Future<Either<Failure, MasterIuran>> getMasterIuranById(int id);
  Future<Either<Failure, MasterIuran>> createMasterIuran(
    MasterIuran masterIuran,
  );
  Future<Either<Failure, MasterIuran>> updateMasterIuran(
    MasterIuran masterIuran,
  );
  Future<Either<Failure, void>> deleteMasterIuran(int id);
  Future<Either<Failure, List<MasterIuran>>> getMasterIuranByKategori(
    int kategoriId,
  );
}
