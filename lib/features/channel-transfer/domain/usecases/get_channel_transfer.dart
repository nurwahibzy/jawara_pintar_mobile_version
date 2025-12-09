import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/channel_transfer_entities.dart';
import '../repositories/channel_transfer_repository.dart';

class GetTransferChannelById {
  final TransferChannelRepository repository;

  GetTransferChannelById(this.repository);

  Future<Either<Failure, TransferChannel>> call(int id) async {
    return await repository.getChannelById(id);
  }
}