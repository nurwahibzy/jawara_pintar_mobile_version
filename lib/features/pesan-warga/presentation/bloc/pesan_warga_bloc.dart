import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/pesan_warga.dart';
import '../../domain/repositories/pesan_warga_repository.dart';

part 'pesan_warga_event.dart';
part 'pesan_warga_state.dart';

class AspirasiBloc extends Bloc<AspirasiEvent, AspirasiState> {
  final AspirasiRepository repository;
  String? currentRole;
  int? currentUserId;

  AspirasiBloc({required this.repository}) : super(AspirasiInitial()) {
    on<LoadAspirasi>((event, emit) async {
      emit(AspirasiLoading());
      try {
        final aspirasiList = await repository.getAllAspirasi();
        if (aspirasiList.isEmpty) {
          emit(const AspirasiOperationFailure("Belum ada aspirasi."));
        } else {
          emit(AspirasiLoaded(aspirasiList));
        }
      } catch (e) {
        emit(AspirasiOperationFailure(e.toString()));
      }
    });

    on<GetAspirasiById>((event, emit) async {
      emit(AspirasiLoading());
      try {
        final aspirasi = await repository.getAspirasiById(event.id);
        emit(AspirasiDetailLoaded(aspirasi));
      } catch (e) {
        emit(AspirasiOperationFailure(e.toString()));
      }
    });

    on<AddAspirasi>((event, emit) async {
      try {
        await repository.addAspirasi(event.aspirasi);
        emit(const AspirasiOperationSuccess("Aspirasi berhasil ditambahkan"));
        add(LoadAspirasi()); 
      } catch (e) {
        emit(AspirasiOperationFailure(e.toString()));
      }
    });

   on<UpdateAspirasi>((event, emit) async {
      try {
        await repository.updateAspirasi(event.aspirasi);
        final updated = await repository.getAspirasiById(event.aspirasi.id);
        emit(AspirasiDetailLoaded(updated));
        emit(const AspirasiOperationSuccess("Aspirasi berhasil diperbarui"));
        add(LoadAspirasi());
      } catch (e) {
        emit(AspirasiOperationFailure(e.toString()));
      }
    });

    on<DeleteAspirasi>((event, emit) async {
      try {
        await repository.deleteAspirasi(event.id);
        emit(const AspirasiOperationSuccess("Aspirasi berhasil dihapus"));
        add(LoadAspirasi());
      } catch (e) {
        emit(AspirasiOperationFailure(e.toString()));
      }
    });

   on<GetUserRoleEvent>((event, emit) async {
      try {
        final role = await repository
            .getCurrentUserRole(); 
        currentRole = role;

        final s = state;
        if (s is AspirasiLoaded) {
          emit(AspirasiLoaded(s.aspirasiList));
        } else if (s is AspirasiInitial) {
          emit(AspirasiInitial());
        } else if (s is AspirasiLoading) {
          emit(AspirasiLoading());
        } else if (s is AspirasiDetailLoaded) {
          emit(AspirasiDetailLoaded(s.aspirasi));
        } else if (s is AspirasiOperationFailure) {
          emit(AspirasiOperationFailure(s.message));
        } else {
          emit(AspirasiInitial());
        }
      } catch (e) {
        emit(AspirasiOperationFailure("Gagal mengambil role: $e"));
      }
    });

    on<GetUserIdEvent>((event, emit) async {
      try {
        final id = await repository
            .getCurrentUserId(); 
        currentUserId = id;
      } catch (e) {
        emit(AspirasiOperationFailure("Gagal mendapatkan userId: $e"));
      }
    });

on<LoadUserData>((event, emit) async {
  try {
    currentRole = await repository.getCurrentUserRole();
    currentUserId = await repository.getCurrentUserId();

    if (state is AspirasiLoaded) {
      emit(AspirasiLoaded((state as AspirasiLoaded).aspirasiList));
    }
  } catch (e) {
    emit(AspirasiOperationFailure("Gagal memuat user data: $e"));
  }
});
  }
}