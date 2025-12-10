import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../repositories/pemasukan_repository.dart';

class DeletePemasukan {
  final PemasukanRepository repository;

  DeletePemasukan(this.repository);

  Future<Either<Failure, void>> call(int id) {
    return repository.deletePemasukan(id);
  }
}
