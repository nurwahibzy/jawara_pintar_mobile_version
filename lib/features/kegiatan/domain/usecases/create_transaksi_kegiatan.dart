import 'package:dartz/dartz.dart';
import 'package:jawara_pintar_mobile_version/core/errors/failure.dart';
import '../entities/transaksi_kegiatan.dart';
import '../repositories/kegiatan_repository.dart';

class CreateTransaksiKegiatan {
  final KegiatanRepository repository;

  CreateTransaksiKegiatan({required this.repository});

  Future<Either<Failure, void>> call(TransaksiKegiatan transaksi) async {
    return await repository.createTransaksi(transaksi);
  }
}
