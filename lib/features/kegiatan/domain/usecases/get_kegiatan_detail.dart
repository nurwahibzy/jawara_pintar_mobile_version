import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/kegiatan.dart';
import '../repositories/kegiatan_repository.dart';

class GetKegiatanDetail {
  final KegiatanRepository repository;

  GetKegiatanDetail(this.repository);

  Future<Either<Failure, Kegiatan>> call(int id) async {
    return await repository.getKegiatanDetail(id);
  }
}
