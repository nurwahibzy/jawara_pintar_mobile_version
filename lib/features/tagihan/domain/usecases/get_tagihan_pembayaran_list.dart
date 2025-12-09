import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/tagihan_pembayaran.dart';
import '../repositories/tagihan_repository.dart';

class GetTagihanPembayaranList {
  final TagihanRepository repository;

  GetTagihanPembayaranList(this.repository);

  Future<Either<Failure, List<TagihanPembayaran>>> call({
    String? statusFilter,
  }) async {
    return await repository.getTagihanPembayaranList(
      statusFilter: statusFilter,
    );
  }
}
