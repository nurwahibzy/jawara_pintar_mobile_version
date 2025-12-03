import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:jawara_pintar_mobile_version/core/errors/failure.dart';
import 'package:jawara_pintar_mobile_version/features/warga/domain/entities/warga.dart';
import 'package:jawara_pintar_mobile_version/features/warga/domain/entities/keluarga.dart';
import 'package:jawara_pintar_mobile_version/features/warga/domain/repositories/warga_repository.dart';
import 'package:jawara_pintar_mobile_version/features/warga/domain/usecases/filter_warga.dart';

part 'warga_event.dart';
part 'warga_state.dart';

class WargaBloc extends Bloc<WargaEvent, WargaState> {
  final WargaRepository repository;

  WargaBloc({required this.repository}) : super(WargaInitial()) {
    on<LoadWarga>(_onLoad);
    on<RefreshWarga>(_onLoad);
    on<GetDetailWarga>(_onGetDetail);
    on<CreateWargaEvent>(_onCreate);
    on<UpdateWargaEvent>(_onUpdate);
    on<FilterWargaEvent>(_onFilter);
    on<LoadKeluargaEvent>(_onLoadKeluarga);
    on<SearchKeluargaEvent>(_onSearchKeluarga);
    on<LoadAllKeluargaWithRelations>(_onLoadAllKeluargaWithRelations);
    on<GetDetailKeluarga>(_onGetDetailKeluarga);
    on<LoadRumahEvent>(_onLoadRumah);
    on<SearchRumahEvent>(_onSearchRumah);
  }

  Future<void> _onLoad(WargaEvent event, Emitter<WargaState> emit) async {
    emit(WargaLoading());
    final Either<Failure, List<Warga>> res = await repository.getAllWarga();

    res.fold((failure) => emit(WargaError(failure.message)), (list) {
      if (list.isEmpty) {
        emit(WargaEmpty());
      } else {
        emit(WargaLoaded(list));
      }
    });
  }

  Future<void> _onGetDetail(
    GetDetailWarga event,
    Emitter<WargaState> emit,
  ) async {
    emit(WargaLoading());
    final Either<Failure, Warga> res = await repository.getWarga(event.id);

    res.fold(
      (failure) => emit(WargaError(failure.message)),
      (data) => emit(WargaDetailLoaded(data)),
    );
  }

  Future<void> _onCreate(
    CreateWargaEvent event,
    Emitter<WargaState> emit,
  ) async {
    emit(WargaLoading());
    final res = await repository.createWarga(event.warga);

    res.fold((failure) => emit(WargaError(failure.message)), (success) {
      add(RefreshWarga());
      emit(const WargaActionSuccess('Tambah warga berhasil'));
    });
  }

  Future<void> _onUpdate(
    UpdateWargaEvent event,
    Emitter<WargaState> emit,
  ) async {
    emit(WargaLoading());
    final res = await repository.updateWarga(event.warga);

    res.fold((failure) => emit(WargaError(failure.message)), (success) {
      add(RefreshWarga());
      emit(const WargaActionSuccess('Update warga berhasil'));
    });
  }

  Future<void> _onFilter(
    FilterWargaEvent event,
    Emitter<WargaState> emit,
  ) async {
    emit(WargaLoading());
    final Either<Failure, List<Warga>> res = await repository.filterWarga(
      event.params,
    );

    res.fold((failure) => emit(WargaError(failure.message)), (list) {
      if (list.isEmpty) {
        emit(const WargaLoaded([]));
      } else {
        emit(WargaLoaded(list));
      }
    });
  }

  Future<void> _onLoadKeluarga(
    LoadKeluargaEvent event,
    Emitter<WargaState> emit,
  ) async {
    emit(KeluargaLoading());
    final Either<Failure, List<Keluarga>> res = await repository
        .getAllKeluarga();

    res.fold(
      (failure) => emit(KeluargaError(failure.message)),
      (list) => emit(KeluargaLoaded(list)),
    );
  }

  Future<void> _onSearchKeluarga(
    SearchKeluargaEvent event,
    Emitter<WargaState> emit,
  ) async {
    emit(KeluargaLoading());
    final Either<Failure, List<Keluarga>> res = await repository.searchKeluarga(
      event.query,
    );

    res.fold(
      (failure) => emit(KeluargaError(failure.message)),
      (list) => emit(KeluargaLoaded(list)),
    );
  }

  Future<void> _onLoadAllKeluargaWithRelations(
    LoadAllKeluargaWithRelations event,
    Emitter<WargaState> emit,
  ) async {
    emit(KeluargaLoading());
    final Either<Failure, List<Keluarga>> res = await repository
        .getAllKeluargaWithRelations();

    res.fold(
      (failure) => emit(KeluargaError(failure.message)),
      (list) => emit(KeluargaListLoaded(list)),
    );
  }

  Future<void> _onGetDetailKeluarga(
    GetDetailKeluarga event,
    Emitter<WargaState> emit,
  ) async {
    emit(KeluargaLoading());
    final Either<Failure, Keluarga> res = await repository.getKeluargaById(
      event.id,
    );

    res.fold(
      (failure) => emit(KeluargaError(failure.message)),
      (keluarga) => emit(KeluargaDetailLoaded(keluarga)),
    );
  }

  Future<void> _onLoadRumah(
    LoadRumahEvent event,
    Emitter<WargaState> emit,
  ) async {
    emit(RumahLoading());
    final Either<Failure, List<Map<String, dynamic>>> res = await repository
        .getAllRumahSimple();

    res.fold(
      (failure) => emit(RumahError(failure.message)),
      (list) => emit(RumahListLoaded(list)),
    );
  }

  Future<void> _onSearchRumah(
    SearchRumahEvent event,
    Emitter<WargaState> emit,
  ) async {
    emit(RumahLoading());
    final Either<Failure, List<Map<String, dynamic>>> res = await repository
        .searchRumah(event.query);

    res.fold(
      (failure) => emit(RumahError(failure.message)),
      (list) => emit(RumahListLoaded(list)),
    );
  }
}
