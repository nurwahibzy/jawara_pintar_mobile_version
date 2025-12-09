part of 'tagih_iuran_bloc.dart';

abstract class TagihIuranState extends Equatable {
  const TagihIuranState();

  @override
  List<Object> get props => [];
}

class TagihIuranInitial extends TagihIuranState {}

class TagihIuranLoading extends TagihIuranState {}

class DropdownLoaded extends TagihIuranState {
  final List<MasterIuranDropdown> masterIuranList;

  const DropdownLoaded(this.masterIuranList);

  @override
  List<Object> get props => [masterIuranList];
}

class TagihIuranSuccess extends TagihIuranState {
  final String message;

  const TagihIuranSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class TagihIuranError extends TagihIuranState {
  final String message;

  const TagihIuranError(this.message);

  @override
  List<Object> get props => [message];
}
