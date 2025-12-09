import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/channel_transfer_entities.dart';
import '../repositories/channel_transfer_repository.dart';

class UpdateTransferChannel {
  final TransferChannelRepository repository;

  UpdateTransferChannel(this.repository);

  Future<Either<Failure, bool>> call(
    TransferChannel channel, {
    File? qrFile,
    File? thumbnailFile,
  }) async {
    return await repository.updateChannel(
      channel,
      qrFile: qrFile,
      thumbnailFile: thumbnailFile,
    );
  }
}