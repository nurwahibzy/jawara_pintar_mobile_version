import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../repositories/cetak_laporan_repository.dart';

class SharePdfUseCase {
  final CetakLaporanRepository repository;

  SharePdfUseCase(this.repository);

  Future<Either<Failure, bool>> call({required File pdfFile}) async {
    return await repository.sharePdfLaporan(pdfFile: pdfFile);
  }
}
