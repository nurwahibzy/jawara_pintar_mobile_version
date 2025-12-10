import 'package:equatable/equatable.dart';

import '../../domain/entities/users.dart';

abstract class UsersState extends Equatable {
  const UsersState();
  @override
  List<Object?> get props => [];
}

class UsersInitial extends UsersState {}

class UsersLoading extends UsersState {}

class UsersLoaded extends UsersState {
  final List<Users> items;
  const UsersLoaded(this.items);

  @override
  List<Object?> get props => [items];
}

class UsersEmpty extends UsersState {}

class UsersError extends UsersState {
  final String message;
  const UsersError(this.message);

  @override
  List<Object?> get props => [message];
}

class UsersActionSuccess extends UsersState {
  final String message;
  const UsersActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

