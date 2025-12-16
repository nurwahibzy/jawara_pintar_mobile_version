import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../repositories/pemasukan_repository.dart';

class CreatePemasukan {
  final PemasukanRepository repository;

  CreatePemasukan(this.repository);

  Future<Either<Failure, void>> call({
    required String judul,
    required int kategoriTransaksiId,
    required double nominal,
    required String tanggalTransaksi,
    String? buktiFoto,
    required String keterangan,
  }) {
    return repository.createPemasukan(
      judul: judul,
      kategoriTransaksiId: kategoriTransaksiId,
      nominal: nominal,
      tanggalTransaksi: tanggalTransaksi,
      buktiFoto: buktiFoto,
      keterangan: keterangan,
    );
  }
}
