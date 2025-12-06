import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/laporan_cetak_entity.dart';

abstract class CetakLaporanRepository {
  Future<Either<Failure, LaporanCetakEntity>> getLaporanData({
    required DateTime tanggalMulai,
    required DateTime tanggalAkhir,
    required String jenisLaporan,
  });

  Future<Either<Failure, File>> generatePdfLaporan({
    required LaporanCetakEntity laporan,
  });

  Future<Either<Failure, bool>> sharePdfLaporan({required File pdfFile});
}
