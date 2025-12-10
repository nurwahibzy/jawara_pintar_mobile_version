import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/tagih_iuran.dart';
import '../repositories/tagih_iuran_repository.dart';

class CreateTagihIuran {
  final TagihIuranRepository repository;

  CreateTagihIuran(this.repository);

  Future<Either<Failure, List<TagihIuran>>> call({
    required int masterIuranId,
    required String periode,
  }) async {
    return await repository.createTagihIuran(
      masterIuranId: masterIuranId,
      periode: periode,
    );
  }
}
