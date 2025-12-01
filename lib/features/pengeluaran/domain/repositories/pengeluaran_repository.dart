import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/pengeluaran.dart';
import '../../domain/entities/kategori_transaksi.dart';

abstract class PengeluaranRepository {
  // Pengeluaran CRUD
  Future<Either<Failure, List<Pengeluaran>>> getAllPengeluaran();
  Future<Either<Failure, Pengeluaran>> getPengeluaranById(int id);
  Future<Either<Failure, bool>> createPengeluaran(Pengeluaran pengeluaran);
  Future<Either<Failure, bool>> updatePengeluaran(Pengeluaran pengeluaran);
  Future<Either<Failure, bool>> deletePengeluaran(int id);

  // Kategori khusus untuk Pengeluaran
  Future<Either<Failure, List<KategoriEntity>>> getKategoriPengeluaran();
}
