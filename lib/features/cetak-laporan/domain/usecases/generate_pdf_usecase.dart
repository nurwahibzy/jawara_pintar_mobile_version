import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/laporan_cetak_entity.dart';
import '../repositories/cetak_laporan_repository.dart';

class GeneratePdfUseCase {
  final CetakLaporanRepository repository;

  GeneratePdfUseCase(this.repository);

  Future<Either<Failure, File>> call({
    required LaporanCetakEntity laporan,
  }) async {
    return await repository.generatePdfLaporan(laporan: laporan);
  }
}
