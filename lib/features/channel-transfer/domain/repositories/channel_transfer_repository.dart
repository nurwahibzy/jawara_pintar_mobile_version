import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/channel_transfer_entities.dart';

abstract class TransferChannelRepository {
  Future<Either<Failure, List<TransferChannel>>> getAllChannels();
  Future<Either<Failure, TransferChannel>> getChannelById(int id);
  Future<Either<Failure, bool>> createChannel(TransferChannel channel, {File? qrFile,File? thumbnailFile,});
  Future<Either<Failure, bool>> updateChannel(TransferChannel channel, {File? qrFile,File? thumbnailFile,});
  Future<Either<Failure, bool>> deleteChannel(int id);
  Future<String?> uploadQr(File file, {String? oldUrl});
  Future<String?> uploadThumbnail(File file, {String? oldUrl});
}