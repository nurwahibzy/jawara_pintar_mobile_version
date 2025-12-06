import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/pemasukan_detail_entity.dart';
import '../repositories/laporan_repository.dart';

class GetAllPemasukanUseCase {
  final LaporanRepository repository;

  GetAllPemasukanUseCase(this.repository);

  Future<Either<Failure, List<PemasukanDetailEntity>>> call({
    String? kategori,
    DateTime? tanggalMulai,
    DateTime? tanggalAkhir,
  }) async {
    return await repository.getAllPemasukan(
      kategori: kategori,
      tanggalMulai: tanggalMulai,
      tanggalAkhir: tanggalAkhir,
    );
  }
}
