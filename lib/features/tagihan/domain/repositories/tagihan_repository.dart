import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/tagihan_pembayaran.dart';

abstract class TagihanRepository {
  Future<Either<Failure, List<TagihanPembayaran>>> getTagihanPembayaranList({
    String? statusFilter,
    String? metodeFilter,
  });
  Future<Either<Failure, TagihanPembayaran>> getTagihanPembayaranDetail(int id);
  Future<Either<Failure, void>> approveTagihanPembayaran({
    required int id,
    String? keterangan,
  });
  Future<Either<Failure, void>> rejectTagihanPembayaran({
    required int id,
    required String keterangan,
  });
}
