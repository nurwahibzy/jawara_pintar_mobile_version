import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/pengeluaran_detail_entity.dart';
import '../repositories/laporan_repository.dart';

class GetAllPengeluaranUseCase {
  final LaporanRepository repository;

  GetAllPengeluaranUseCase(this.repository);

  Future<Either<Failure, List<PengeluaranDetailEntity>>> call({
    String? kategori,
    DateTime? tanggalMulai,
    DateTime? tanggalAkhir,
  }) async {
    return await repository.getAllPengeluaran(
      kategori: kategori,
      tanggalMulai: tanggalMulai,
      tanggalAkhir: tanggalAkhir,
    );
  }
}
