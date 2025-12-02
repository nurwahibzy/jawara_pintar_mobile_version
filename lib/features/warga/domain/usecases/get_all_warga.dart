import 'package:dartz/dartz.dart';
import 'package:jawara_pintar_mobile_version/core/errors/failure.dart';
import 'package:jawara_pintar_mobile_version/features/warga/domain/entities/warga.dart';
import 'package:jawara_pintar_mobile_version/features/warga/domain/repositories/warga_repository.dart';

class GetAllWarga {
  final WargaRepository wargaRepository;

  const GetAllWarga(this.wargaRepository);

  Future<Either<Failure, List<Warga>>> execute() async {
    return await wargaRepository.getAllWarga();
  }
}
