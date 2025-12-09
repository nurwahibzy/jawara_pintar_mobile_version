import 'package:equatable/equatable.dart';
import '../../domain/entities/channel_transfer_entities.dart';

abstract class TransferChannelState extends Equatable {
  const TransferChannelState();

  @override
  List<Object?> get props => [];
}

class TransferChannelInitial extends TransferChannelState {}

class TransferChannelLoading extends TransferChannelState {}

class TransferChannelLoaded extends TransferChannelState {
  final List<TransferChannel> channels;
  const TransferChannelLoaded(this.channels);

  @override
  List<Object?> get props => [channels];
}

class TransferChannelEmpty extends TransferChannelState {}

class TransferChannelError extends TransferChannelState {
  final String message;
  const TransferChannelError(this.message);

  @override
  List<Object?> get props => [message];
}

class TransferChannelActionSuccess extends TransferChannelState {
  final String message;
  const TransferChannelActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}