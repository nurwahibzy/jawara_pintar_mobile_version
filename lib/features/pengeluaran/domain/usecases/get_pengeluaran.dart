import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/pengeluaran.dart';
import '../repositories/pengeluaran_repository.dart';

class GetPengeluaranById {
  final PengeluaranRepository repository;

  GetPengeluaranById(this.repository);

  Future<Either<Failure, Pengeluaran>> call(int id) async {
    return await repository.getPengeluaranById(id);
  }
}
