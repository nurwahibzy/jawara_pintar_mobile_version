part of 'pemasukan_bloc.dart';

abstract class PemasukanState extends Equatable {
  const PemasukanState();

  @override
  List<Object> get props => [];
}

class PemasukanInitial extends PemasukanState {}

class PemasukanLoading extends PemasukanState {}

class PemasukanListLoaded extends PemasukanState {
  final List<Pemasukan> pemasukanList;

  const PemasukanListLoaded(this.pemasukanList);

  @override
  List<Object> get props => [pemasukanList];
}

class PemasukanDetailLoaded extends PemasukanState {
  final Pemasukan pemasukan;

  const PemasukanDetailLoaded(this.pemasukan);

  @override
  List<Object> get props => [pemasukan];
}

class PemasukanActionSuccess extends PemasukanState {
  final String message;

  const PemasukanActionSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class PemasukanError extends PemasukanState {
  final String message;

  const PemasukanError(this.message);

  @override
  List<Object> get props => [message];
}
