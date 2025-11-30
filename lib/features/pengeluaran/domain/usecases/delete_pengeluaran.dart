import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../repositories/pengeluaran_repository.dart';

class DeletePengeluaran {
  final PengeluaranRepository repository;

  DeletePengeluaran(this.repository);

  Future<Either<Failure, bool>> call(int id) async {
    return await repository.deletePengeluaran(id);
  }
}
