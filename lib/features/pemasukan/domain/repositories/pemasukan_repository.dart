import 'dart:io';

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/pemasukan.dart';

abstract class PemasukanRepository {
  Future<Either<Failure, List<Pemasukan>>> getPemasukanList({
    String? kategoriFilter,
  });
  Future<Either<Failure, Pemasukan>> getPemasukanDetail(int id);
  Future<Either<Failure, void>> createPemasukan({
    required String judul,
    required int kategoriTransaksiId,
    required double nominal,
    required String tanggalTransaksi,
    String? buktiFoto,
    required String keterangan,
  });
  Future<Either<Failure, void>> updatePemasukan({
    required int id,
    required String judul,
    required int kategoriTransaksiId,
    required double nominal,
    required String tanggalTransaksi,
    String? buktiFoto,
    required String keterangan,
  });
  Future<Either<Failure, void>> deletePemasukan(int id);
  Future<String?> uploadBukti(File file, {String? oldUrl});
}
