import 'package:dartz/dartz.dart';
import 'package:jawara_pintar_mobile_version/core/errors/failure.dart';
import 'package:jawara_pintar_mobile_version/features/warga/domain/entities/warga.dart';
import 'package:jawara_pintar_mobile_version/features/warga/domain/repositories/warga_repository.dart';

class GetWarga {
  final WargaRepository wargaRepository;

  const GetWarga(this.wargaRepository);

  Future<Either<Failure, Warga>> execute(int id) async {
    return await wargaRepository.getWarga(id);
  }
}
