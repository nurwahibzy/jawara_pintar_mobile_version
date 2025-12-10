import 'package:equatable/equatable.dart';

import '../../domain/entities/users.dart';

abstract class UsersEvent extends Equatable {
  const UsersEvent();
  @override
  List<Object?> get props => [];
}

class LoadUsers extends UsersEvent {
  const LoadUsers();
}

class RefreshUsers extends UsersEvent {
  const RefreshUsers();
}

class DeleteUsersEvent extends UsersEvent {
  final int id;
  const DeleteUsersEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class CreateUsersEvent extends UsersEvent {
  final Users user;

  const CreateUsersEvent(this.user);
}

class UpdateUsersEvent extends UsersEvent {
  final Users user;

  const UpdateUsersEvent( this.user);

  @override
  List<Object?> get props => [user];
}

class LoadKategoriUsers extends UsersEvent {}
// Event untuk menambah user baru
class AddUser extends UsersEvent {
  final String email;
  final String password;
  final int wargaId;
  final String role;

  const AddUser({
    required this.email,
    required this.password,
    required this.wargaId,
    required this.role,
  });

  @override
  List<Object> get props => [email, password, wargaId, role];
}


