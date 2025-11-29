import 'package:dartz/dartz.dart';

import 'package:jawara_pintar_mobile_version/core/errors/failure.dart';

import '../entities/kategori_transaksi.dart';
import '../repositories/pengeluaran_repository.dart';

class GetKategoriPengeluaran {
  final PengeluaranRepository repository;

  GetKategoriPengeluaran(this.repository);

  Future<Either<Failure, List<KategoriEntity>>> call() async {
    return await repository.getKategoriPengeluaran();
  }
}
