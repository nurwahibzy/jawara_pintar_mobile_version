import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:jawara_pintar_mobile_version/core/errors/failure.dart';
import 'package:jawara_pintar_mobile_version/features/rumah/domain/entities/rumah.dart';
import 'package:jawara_pintar_mobile_version/features/rumah/domain/repositories/rumah_repository.dart';
import 'package:jawara_pintar_mobile_version/features/rumah/domain/usecases/filter_rumah.dart';

part 'rumah_event.dart';
part 'rumah_state.dart';

class RumahBloc extends Bloc<RumahEvent, RumahState> {
  final RumahRepository repository;

  RumahBloc({required this.repository}) : super(RumahInitial()) {
    on<LoadAllRumah>(_onLoad);
    on<RefreshRumah>(_onLoad);
    on<GetDetailRumah>(_onGetDetail);
    on<CreateRumahEvent>(_onCreate);
    on<UpdateRumahEvent>(_onUpdate);
    on<DeleteRumahEvent>(_onDelete);
    on<FilterRumahEvent>(_onFilter);
  }

  Future<void> _onLoad(RumahEvent event, Emitter<RumahState> emit) async {
    emit(RumahLoading());
    final Either<Failure, List<Rumah>> res = await repository.getAllRumah();

    res.fold((failure) => emit(RumahError(failure.message)), (list) {
      if (list.isEmpty) {
        emit(RumahEmpty());
      } else {
        emit(RumahLoaded(list));
      }
    });
  }

  Future<void> _onGetDetail(
    GetDetailRumah event,
    Emitter<RumahState> emit,
  ) async {
    emit(RumahLoading());
    final Either<Failure, Rumah> res = await repository.getRumahDetail(
      event.id,
    );

    res.fold(
      (failure) => emit(RumahError(failure.message)),
      (data) => emit(RumahDetailLoaded(data)),
    );
  }

  Future<void> _onCreate(
    CreateRumahEvent event,
    Emitter<RumahState> emit,
  ) async {
    emit(RumahLoading());
    final res = await repository.createRumah(event.rumah);

    res.fold((failure) => emit(RumahError(failure.message)), (success) {
      emit(const RumahActionSuccess('Tambah rumah berhasil'));
      add(RefreshRumah());
    });
  }

  Future<void> _onUpdate(
    UpdateRumahEvent event,
    Emitter<RumahState> emit,
  ) async {
    emit(RumahLoading());
    final res = await repository.updateRumah(event.rumah);

    res.fold((failure) => emit(RumahError(failure.message)), (success) {
      emit(const RumahActionSuccess('Update rumah berhasil'));
      add(RefreshRumah());
    });
  }

  Future<void> _onDelete(
    DeleteRumahEvent event,
    Emitter<RumahState> emit,
  ) async {
    emit(RumahLoading());
    final res = await repository.deleteRumah(event.id);

    res.fold((failure) => emit(RumahError(failure.message)), (success) {
      emit(const RumahActionSuccess('Hapus rumah berhasil'));
      add(RefreshRumah());
    });
  }

  Future<void> _onFilter(
    FilterRumahEvent event,
    Emitter<RumahState> emit,
  ) async {
    emit(RumahLoading());
    final Either<Failure, List<Rumah>> res = await repository.filterRumah(
      event.params,
    );

    res.fold((failure) => emit(RumahError(failure.message)), (list) {
      if (list.isEmpty) {
        emit(const RumahLoaded([]));
      } else {
        emit(RumahLoaded(list));
      }
    });
  }
}
