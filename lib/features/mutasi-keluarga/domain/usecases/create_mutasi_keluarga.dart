import 'package:dartz/dartz.dart';
import 'package:jawara_pintar_mobile_version/features/mutasi-keluarga/domain/entities/mutasi_keluarga.dart';

import '../../../../core/errors/failure.dart';
import '../repositories/mutasi_keluarga_repository.dart';

class CreateMutasiKeluarga {
  final MutasiKeluargaRepository repository;

  CreateMutasiKeluarga(this.repository);

  Future<Either<Failure, bool>> execute(MutasiKeluarga mutasi) {
    return repository.createMutasiKeluarga(mutasi);
  }
}
