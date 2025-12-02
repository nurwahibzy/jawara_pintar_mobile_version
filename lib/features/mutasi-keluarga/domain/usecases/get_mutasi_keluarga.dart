import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/mutasi_keluarga.dart';
import '../repositories/mutasi_keluarga_repository.dart';

class GetMutasiKeluarga {
  final MutasiKeluargaRepository mutasiKeluargaRepository;

  const GetMutasiKeluarga(this.mutasiKeluargaRepository);

  Future<Either<Failure,MutasiKeluarga>> execute(int id) async {
    return await mutasiKeluargaRepository.getMutasiKeluarga(id);
  }
}
