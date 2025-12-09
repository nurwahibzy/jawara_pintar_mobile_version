part of 'tagihan_bloc.dart';

abstract class TagihanState extends Equatable {
  const TagihanState();

  @override
  List<Object?> get props => [];
}

class TagihanInitial extends TagihanState {}

class TagihanLoading extends TagihanState {}

class TagihanListLoaded extends TagihanState {
  final List<TagihanPembayaran> tagihanList;

  const TagihanListLoaded(this.tagihanList);

  @override
  List<Object> get props => [tagihanList];
}

class TagihanDetailLoaded extends TagihanState {
  final TagihanPembayaran tagihan;

  const TagihanDetailLoaded(this.tagihan);

  @override
  List<Object> get props => [tagihan];
}

class TagihanActionSuccess extends TagihanState {
  final String message;

  const TagihanActionSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class TagihanError extends TagihanState {
  final String message;

  const TagihanError(this.message);

  @override
  List<Object> get props => [message];
}
