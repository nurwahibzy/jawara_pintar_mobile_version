import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/pesan_warga.dart';
import '../../domain/repositories/pesan_warga_repository.dart';

part 'pesan_warga_event.dart';
part 'pesan_warga_state.dart';

class AspirasiBloc extends Bloc<AspirasiEvent, AspirasiState> {
  final AspirasiRepository repository;

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
        final updated = await repository.getAspirasiById(event.aspirasi.id!);
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
  }
}