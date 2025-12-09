import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/channel_transfer_entities.dart';
import '../repositories/channel_transfer_repository.dart';

class GetAllTransferChannels {
  final TransferChannelRepository repository;

  GetAllTransferChannels(this.repository);

  Future<Either<Failure, List<TransferChannel>>> call() async {
    return await repository.getAllChannels();
  }
}
