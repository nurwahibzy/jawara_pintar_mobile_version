import 'package:dartz/dartz.dart';
import 'package:jawara_pintar_mobile_version/core/errors/failure.dart';
import '../repositories/kegiatan_repository.dart';

class DeleteTransaksiKegiatan {
  final KegiatanRepository repository;

  DeleteTransaksiKegiatan({required this.repository});

  Future<Either<Failure, void>> call(int transaksiId) async {
    return await repository.deleteTransaksi(transaksiId);
  }
}
