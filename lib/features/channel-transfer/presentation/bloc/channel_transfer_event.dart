import 'dart:io';
import 'package:equatable/equatable.dart';
import '../../domain/entities/channel_transfer_entities.dart';

abstract class TransferChannelEvent extends Equatable {
  const TransferChannelEvent();

  @override
  List<Object?> get props => [];
}

class LoadTransferChannels extends TransferChannelEvent {}

class RefreshTransferChannels extends TransferChannelEvent {}

class DeleteTransferChannelEvent extends TransferChannelEvent {
  final int id;
  const DeleteTransferChannelEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class CreateTransferChannelEvent extends TransferChannelEvent {
  final TransferChannel channel;
  final File? qrFile;
  final File? thumbnailFile;

  const CreateTransferChannelEvent(
    this.channel, {
    this.qrFile,
    this.thumbnailFile,
  });

  @override
  List<Object?> get props => [channel, qrFile, thumbnailFile];
}

class UpdateTransferChannelEvent extends TransferChannelEvent {
  final TransferChannel channel;
  final File? qrFile;
  final File? thumbnailFile;

  const UpdateTransferChannelEvent({
    required this.channel,
    this.qrFile,
    this.thumbnailFile,
  });

  @override
  List<Object?> get props => [channel, qrFile, thumbnailFile];
}