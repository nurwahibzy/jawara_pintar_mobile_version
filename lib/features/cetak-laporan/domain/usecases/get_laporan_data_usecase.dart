import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/laporan_cetak_entity.dart';
import '../repositories/cetak_laporan_repository.dart';

class GetLaporanDataUseCase {
  final CetakLaporanRepository repository;

  GetLaporanDataUseCase(this.repository);

  Future<Either<Failure, LaporanCetakEntity>> call({
    required DateTime tanggalMulai,
    required DateTime tanggalAkhir,
    required String jenisLaporan,
  }) async {
    return await repository.getLaporanData(
      tanggalMulai: tanggalMulai,
      tanggalAkhir: tanggalAkhir,
      jenisLaporan: jenisLaporan,
    );
  }
}
