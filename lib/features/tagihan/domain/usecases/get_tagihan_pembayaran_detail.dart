import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/tagihan_pembayaran.dart';
import '../repositories/tagihan_repository.dart';

class GetTagihanPembayaranDetail {
  final TagihanRepository repository;

  GetTagihanPembayaranDetail(this.repository);

  Future<Either<Failure, TagihanPembayaran>> call(int id) async {
    return await repository.getTagihanPembayaranDetail(id);
  }
}
