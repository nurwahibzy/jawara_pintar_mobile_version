import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../repositories/pemasukan_repository.dart';

class UpdatePemasukan {
  final PemasukanRepository repository;

  UpdatePemasukan(this.repository);

  Future<Either<Failure, void>> call({
    required int id,
    required String judul,
    required int kategoriTransaksiId,
    required double nominal,
    required String tanggalTransaksi,
    String? buktiFoto,
    required String keterangan,
  }) {
    return repository.updatePemasukan(
      id: id,
      judul: judul,
      kategoriTransaksiId: kategoriTransaksiId,
      nominal: nominal,
      tanggalTransaksi: tanggalTransaksi,
      buktiFoto: buktiFoto,
      keterangan: keterangan,
    );
  }
}
