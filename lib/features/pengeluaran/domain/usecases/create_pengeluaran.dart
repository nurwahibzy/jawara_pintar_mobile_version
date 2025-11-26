import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/pengeluaran.dart';
import '../repositories/pengeluaran_repository.dart';

class CreatePengeluaran {
  final PengeluaranRepository repository;

  CreatePengeluaran(this.repository);

  Future<Either<Failure, bool>> call(Pengeluaran pengeluaran) async {
    return await repository.createPengeluaran(pengeluaran);
  }
}