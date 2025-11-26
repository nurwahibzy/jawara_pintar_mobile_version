import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/pengeluaran.dart';
import '../repositories/pengeluaran_repository.dart';

class UpdatePengeluaran {
  final PengeluaranRepository repository;

  UpdatePengeluaran(this.repository);

  Future<Either<Failure, bool>> call(Pengeluaran pengeluaran) async {
    return await repository.updatePengeluaran(pengeluaran);
  }
}
