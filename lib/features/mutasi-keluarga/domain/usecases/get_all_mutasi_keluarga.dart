import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/mutasi_keluarga.dart';
import '../repositories/mutasi_keluarga_repository.dart';

class GetAllMutasiKeluarga {
  final MutasiKeluargaRepository mutasiKeluargaRepository;

  const GetAllMutasiKeluarga(this.mutasiKeluargaRepository);

  Future<Either<Failure,List<MutasiKeluarga>>> execute() async {
    return await mutasiKeluargaRepository.getAllMutasiKeluarga();
  }
}
