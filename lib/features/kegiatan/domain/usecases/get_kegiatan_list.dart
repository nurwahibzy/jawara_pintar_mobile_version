import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/kegiatan.dart';
import '../repositories/kegiatan_repository.dart';

class GetKegiatanList {
  final KegiatanRepository repository;

  GetKegiatanList(this.repository);

  Future<Either<Failure, List<Kegiatan>>> call() async {
    return await repository.getKegiatanList();
  }
}
