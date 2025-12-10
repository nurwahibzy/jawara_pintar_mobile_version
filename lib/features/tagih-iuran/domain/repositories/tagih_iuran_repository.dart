import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/tagih_iuran.dart';
import '../entities/master_iuran_dropdown.dart';

abstract class TagihIuranRepository {
  Future<Either<Failure, List<MasterIuranDropdown>>> getMasterIuranDropdown();
  Future<Either<Failure, List<TagihIuran>>> createTagihIuran({
    required int masterIuranId,
    required String periode,
  });
}
