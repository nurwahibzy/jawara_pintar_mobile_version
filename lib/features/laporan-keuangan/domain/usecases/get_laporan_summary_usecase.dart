import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/laporan_summary_entity.dart';
import '../repositories/laporan_repository.dart';

class GetLaporanSummaryUseCase {
  final LaporanRepository repository;

  GetLaporanSummaryUseCase(this.repository);

  Future<Either<Failure, LaporanSummaryEntity>> call({
    DateTime? tanggalMulai,
    DateTime? tanggalAkhir,
    String? jenisList, // 'semua', 'pemasukan', 'pengeluaran'
  }) async {
    return await repository.getLaporanSummary(
      tanggalMulai: tanggalMulai,
      tanggalAkhir: tanggalAkhir,
      jenisList: jenisList,
    );
  }
}
