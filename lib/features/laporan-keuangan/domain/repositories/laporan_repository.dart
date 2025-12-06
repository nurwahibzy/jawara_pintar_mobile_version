import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/pemasukan_detail_entity.dart';
import '../entities/pengeluaran_detail_entity.dart';
import '../entities/laporan_summary_entity.dart';

abstract class LaporanRepository {
  /// Get all pemasukan with optional filters
  Future<Either<Failure, List<PemasukanDetailEntity>>> getAllPemasukan({
    String? kategori,
    DateTime? tanggalMulai,
    DateTime? tanggalAkhir,
  });

  /// Get all pengeluaran with optional filters
  Future<Either<Failure, List<PengeluaranDetailEntity>>> getAllPengeluaran({
    String? kategori,
    DateTime? tanggalMulai,
    DateTime? tanggalAkhir,
  });

  /// Get laporan summary for PDF generation
  Future<Either<Failure, LaporanSummaryEntity>> getLaporanSummary({
    DateTime? tanggalMulai,
    DateTime? tanggalAkhir,
    String? jenisList, // 'semua', 'pemasukan', 'pengeluaran'
  });

  /// Generate PDF laporan and return the file
  Future<Either<Failure, File>> generatePdfLaporan({
    required LaporanSummaryEntity laporan,
  });
}
