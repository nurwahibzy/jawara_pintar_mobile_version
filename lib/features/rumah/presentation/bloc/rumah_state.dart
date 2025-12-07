part of 'rumah_bloc.dart';

sealed class RumahState extends Equatable {
  const RumahState();

  @override
  List<Object?> get props => [];
}

class RumahInitial extends RumahState {}

class RumahLoading extends RumahState {}

class RumahEmpty extends RumahState {}

class RumahError extends RumahState {
  final String message;
  const RumahError(this.message);

  @override
  List<Object?> get props => [message];
}

class RumahLoaded extends RumahState {
  final List<Rumah> result;
  const RumahLoaded(this.result);

  @override
  List<Object?> get props => [result];
}

class RumahDetailLoaded extends RumahState {
  final Rumah rumah;
  const RumahDetailLoaded(this.rumah);

  @override
  List<Object?> get props => [rumah];
}

class RumahActionSuccess extends RumahState {
  final String message;
  const RumahActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}
