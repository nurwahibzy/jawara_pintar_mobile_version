import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../repositories/tagihan_repository.dart';

class RejectTagihanPembayaran {
  final TagihanRepository repository;

  RejectTagihanPembayaran(this.repository);

  Future<Either<Failure, void>> call({
    required int id,
    required String catatan,
  }) async {
    return await repository.rejectTagihanPembayaran(id: id, catatan: catatan);
  }
}
