import 'package:dartz/dartz.dart';
import 'package:jawara_pintar_mobile_version/core/errors/failure.dart';
import '../entities/kegiatan.dart';
import '../entities/transaksi_kegiatan.dart';

abstract class KegiatanRepository {
  Future<Either<Failure, List<Kegiatan>>> getKegiatanList();
  Future<Either<Failure, Kegiatan>> getKegiatanDetail(int id);
  Future<Either<Failure, void>> createKegiatan(Kegiatan kegiatan);
  Future<Either<Failure, void>> updateKegiatan(Kegiatan kegiatan);

  // Transaksi methods
  Future<Either<Failure, List<TransaksiKegiatan>>> getTransaksiByKegiatan(
    int kegiatanId,
  );
  Future<Either<Failure, void>> createTransaksi(TransaksiKegiatan transaksi);
  Future<Either<Failure, void>> deleteTransaksi(int transaksiId);
}
