import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../repositories/mutasi_keluarga_repository.dart';

class GetFormDataOptions {
  final MutasiKeluargaRepository mutasiKeluargaRepository;

  const GetFormDataOptions(this.mutasiKeluargaRepository);

  Future<Either<Failure, Map<String, List<dynamic>>>> execute() async {
    return await mutasiKeluargaRepository.getFormDataOptions();
  }
}
