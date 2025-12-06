import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../domain/entities/kategori_transaksi.dart';
import '../entities/pengeluaran.dart';

abstract class PengeluaranRepository {
  // Pengeluaran CRUD
  Future<Either<Failure, List<Pengeluaran>>> getAllPengeluaran();
  Future<Either<Failure, Pengeluaran>> getPengeluaranById(int id);
  Future<Either<Failure, bool>> createPengeluaran(Pengeluaran pengeluaran, {String? buktiFoto,});
  Future<Either<Failure, bool>> updatePengeluaran(Pengeluaran pengeluaran);
  Future<Either<Failure, bool>> deletePengeluaran(int id);
  Future<String?> uploadBukti(File file, {String? oldUrl});
  Future<void> deleteBukti(String url);
  // Kategori khusus untuk Pengeluaran
  Future<Either<Failure, List<KategoriEntity>>> getKategoriPengeluaran();
}
