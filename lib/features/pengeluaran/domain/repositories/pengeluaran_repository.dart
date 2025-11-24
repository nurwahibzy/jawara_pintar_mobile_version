import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/pengeluaran.dart';

abstract class PengeluaranRepository {
  Future<Either<Failure, List<Pengeluaran>>> getAllPengeluaran();
  Future<Either<Failure, Pengeluaran>> getPengeluaranById(int id);
  Future<Either<Failure, bool>> createPengeluaran(Pengeluaran pengeluaran);
  Future<Either<Failure, bool>> updatePengeluaran(Pengeluaran pengeluaran);
  Future<Either<Failure, bool>> deletePengeluaran(int id);
}
