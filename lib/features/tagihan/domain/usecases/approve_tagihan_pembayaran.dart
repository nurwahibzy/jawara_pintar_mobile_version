import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../repositories/tagihan_repository.dart';

class ApproveTagihanPembayaran {
  final TagihanRepository repository;

  ApproveTagihanPembayaran(this.repository);

  Future<Either<Failure, void>> call({required int id, String? catatan}) async {
    return await repository.approveTagihanPembayaran(id: id, catatan: catatan);
  }
}
