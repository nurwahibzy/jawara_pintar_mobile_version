import 'package:dartz/dartz.dart';
import 'package:jawara_pintar_mobile_version/core/errors/failure.dart';
import '../entities/transaksi_kegiatan.dart';
import '../repositories/kegiatan_repository.dart';

class GetTransaksiKegiatan {
  final KegiatanRepository repository;

  GetTransaksiKegiatan({required this.repository});

  Future<Either<Failure, List<TransaksiKegiatan>>> call(int kegiatanId) async {
    return await repository.getTransaksiByKegiatan(kegiatanId);
  }
}
