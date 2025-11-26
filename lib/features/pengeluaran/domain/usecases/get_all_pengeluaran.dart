import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/pengeluaran.dart';
import '../repositories/pengeluaran_repository.dart';

class GetPengeluaranList {
  final PengeluaranRepository repository;

  GetPengeluaranList(this.repository);

  Future<Either<Failure, List<Pengeluaran>>> call() async {
    return await repository.getAllPengeluaran();
  }
}
