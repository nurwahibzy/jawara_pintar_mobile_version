import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/kegiatan.dart';
import '../repositories/kegiatan_repository.dart';

class CreateKegiatan {
  final KegiatanRepository repository;

  CreateKegiatan(this.repository);

  Future<Either<Failure, void>> call(Kegiatan kegiatan) async {
    return await repository.createKegiatan(kegiatan);
  }
}
