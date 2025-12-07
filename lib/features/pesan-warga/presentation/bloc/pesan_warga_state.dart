part of 'pesan_warga_bloc.dart';

abstract class AspirasiState extends Equatable {
  const AspirasiState();

  @override
  List<Object?> get props => [];
}

class AspirasiInitial extends AspirasiState {}

class AspirasiLoading extends AspirasiState {}

class AspirasiLoaded extends AspirasiState {
  final List<Aspirasi> aspirasiList;
  const AspirasiLoaded(this.aspirasiList);

  @override
  List<Object?> get props => [aspirasiList];
}

class AspirasiOperationSuccess extends AspirasiState {
  final String message;
  const AspirasiOperationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class AspirasiOperationFailure extends AspirasiState {
  final String message;
  const AspirasiOperationFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class AspirasiDetailLoaded extends AspirasiState {
  final Aspirasi aspirasi;
  const AspirasiDetailLoaded(this.aspirasi);

  @override
  List<Object?> get props => [aspirasi];
}

class UserRoleLoaded extends AspirasiState {
  final String? role; 
  UserRoleLoaded(this.role);
}

class GetUserIdEvent extends AspirasiEvent {} 