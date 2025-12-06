import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/laporan_summary_entity.dart';
import '../repositories/laporan_repository.dart';

class GeneratePdfLaporanUseCase {
  final LaporanRepository repository;

  GeneratePdfLaporanUseCase(this.repository);

  Future<Either<Failure, File>> call({
    required LaporanSummaryEntity laporan,
  }) async {
    return await repository.generatePdfLaporan(laporan: laporan);
  }
}
