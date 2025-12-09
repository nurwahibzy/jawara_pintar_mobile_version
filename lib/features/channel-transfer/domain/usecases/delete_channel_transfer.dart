import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../repositories/channel_transfer_repository.dart';

class DeleteTransferChannel {
  final TransferChannelRepository repository;

  DeleteTransferChannel(this.repository);

  Future<Either<Failure, bool>> call(int id) async {
    return await repository.deleteChannel(id);
  }
}