import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../domain/entities/users.dart';
import '../../domain/repositories/users_repository.dart';
import 'users_event.dart';
import 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final UsersRepository repository;

  UsersBloc({required this.repository}) : super(UsersInitial()) {
    on<LoadUsers>(_onLoad);
    on<RefreshUsers>(_onLoad);
    on<DeleteUsersEvent>(_onDelete);
    on<CreateUsersEvent>(_onCreate);
    on<UpdateUsersEvent>(_onUpdate);
    on<AddUser>((event, emit) async {
      emit(UsersLoading()); // Tampilkan loading
      
      try {
        await repository.addUser(
          email: event.email,
          password: event.password,
          wargaId: event.wargaId,
          role: event.role,
        );

        // Jika sukses
        emit(const UsersActionSuccess("Berhasil menambahkan user baru!"));
        
        // Refresh list user agar data baru muncul
        add(const LoadUsers()); 
        
      } catch (e) {
        // Jika gagal, tampilkan pesan error
        emit(UsersError(e.toString()));
      }
    });
  }

  Future<void> _onLoad(UsersEvent event, Emitter<UsersState> emit) async {
    emit(UsersLoading());
    final Either<Failure, List<Users>> res = await repository.getAllUsers();
    res.fold((failure) => emit(UsersError(failure.message)), (list) {
      if (list.isEmpty) {
        emit(UsersEmpty());
      } else {
        emit(UsersLoaded(list));
      }
    });
  }

  Future<void> _onDelete(
    DeleteUsersEvent event,
    Emitter<UsersState> emit,
  ) async {
    emit(UsersLoading());
    final Either<Failure, bool> res = await repository.deleteUser(event.id);
    res.fold((failure) => emit(UsersError(failure.message)), (ok) {
      if (ok) {
        add(const RefreshUsers());
        emit(const UsersActionSuccess('Hapus berhasil'));
      } else {
        emit(const UsersError('Hapus gagal'));
      }
    });
  }

  Future<void> _onCreate(
    CreateUsersEvent event,
    Emitter<UsersState> emit,
  ) async {
    emit(UsersLoading());

    try {
      final res = await repository.createUser(event.user);

      res.fold((failure) => emit(UsersError(failure.message)), (ok) {
        if (ok) {
          add(const RefreshUsers());
          emit(const UsersActionSuccess("Create User berhasil"));
        } else {
          emit(const UsersError("Create User gagal"));
        }
      });
    } catch (e) {
      emit(UsersError(e.toString()));
    }
  }

  Future<void> _onUpdate(
    UpdateUsersEvent event,
    Emitter<UsersState> emit,
  ) async {
    emit(UsersLoading());
    try {
      final Either<Failure, bool> res = await repository.updateUser(event.user);

      res.fold((failure) => emit(UsersError(failure.message)), (ok) {
        if (ok) {
          emit(const UsersActionSuccess('Update berhasil'));
          add(const RefreshUsers());
        } else {
          emit(const UsersError('Update gagal'));
        }
      });
    } catch (e) {
      emit(UsersError(e.toString()));
    }
  }
  
}
