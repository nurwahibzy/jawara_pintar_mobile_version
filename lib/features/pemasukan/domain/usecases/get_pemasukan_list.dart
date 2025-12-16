import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/pemasukan.dart';
import '../repositories/pemasukan_repository.dart';

class GetPemasukanList {
  final PemasukanRepository repository;

  GetPemasukanList(this.repository);

  Future<Either<Failure, List<Pemasukan>>> call({String? kategoriFilter}) {
    return repository.getPemasukanList(kategoriFilter: kategoriFilter);
  }
}
