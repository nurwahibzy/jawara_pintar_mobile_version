import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/pemasukan.dart';
import '../repositories/pemasukan_repository.dart';

class GetPemasukanDetail {
  final PemasukanRepository repository;

  GetPemasukanDetail(this.repository);

  Future<Either<Failure, Pemasukan>> call(int id) {
    return repository.getPemasukanDetail(id);
  }
}
