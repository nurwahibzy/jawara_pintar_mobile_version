import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/master_iuran.dart';
import '../../domain/usecases/get_master_iuran_list.dart';
import '../../domain/usecases/get_master_iuran_by_id.dart';
import '../../domain/usecases/get_master_iuran_by_kategori.dart';
import '../../domain/usecases/create_master_iuran.dart';
import '../../domain/usecases/update_master_iuran.dart';
import '../../domain/usecases/delete_master_iuran.dart';
import 'master_iuran_event.dart';
import 'master_iuran_state.dart';

class MasterIuranBloc extends Bloc<MasterIuranEvent, MasterIuranState> {
  final GetMasterIuranList getMasterIuranList;
  final GetMasterIuranById getMasterIuranById;
  final GetMasterIuranByKategori getMasterIuranByKategori;
  final CreateMasterIuran createMasterIuran;
  final UpdateMasterIuran updateMasterIuran;
  final DeleteMasterIuran deleteMasterIuran;

  MasterIuranBloc({
    required this.getMasterIuranList,
    required this.getMasterIuranById,
    required this.getMasterIuranByKategori,
    required this.createMasterIuran,
    required this.updateMasterIuran,
    required this.deleteMasterIuran,
  }) : super(MasterIuranInitial()) {
    on<LoadMasterIuranList>(_onLoadList);
    on<RefreshMasterIuranList>(_onLoadList);
    on<LoadMasterIuranById>(_onLoadById);
    on<LoadMasterIuranByKategori>(_onLoadByKategori);
    on<CreateMasterIuranEvent>(_onCreate);
    on<UpdateMasterIuranEvent>(_onUpdate);
    on<DeleteMasterIuranEvent>(_onDelete);
  }

  Future<void> _onLoadList(
    MasterIuranEvent event,
    Emitter<MasterIuranState> emit,
  ) async {
    emit(MasterIuranLoading());
    final Either<Failure, List<MasterIuran>> result =
        await getMasterIuranList();

    result.fold((failure) => emit(MasterIuranError(failure.message)), (list) {
      if (list.isEmpty) {
        emit(MasterIuranEmpty());
      } else {
        emit(MasterIuranLoaded(list));
      }
    });
  }

  Future<void> _onLoadById(
    LoadMasterIuranById event,
    Emitter<MasterIuranState> emit,
  ) async {
    emit(MasterIuranLoading());
    final Either<Failure, MasterIuran> result = await getMasterIuranById(
      event.id,
    );

    result.fold(
      (failure) => emit(MasterIuranError(failure.message)),
      (masterIuran) => emit(MasterIuranDetailLoaded(masterIuran)),
    );
  }

  Future<void> _onLoadByKategori(
    LoadMasterIuranByKategori event,
    Emitter<MasterIuranState> emit,
  ) async {
    emit(MasterIuranLoading());
    final Either<Failure, List<MasterIuran>> result =
        await getMasterIuranByKategori(event.kategoriId);

    result.fold((failure) => emit(MasterIuranError(failure.message)), (list) {
      if (list.isEmpty) {
        emit(MasterIuranEmpty());
      } else {
        emit(MasterIuranLoaded(list));
      }
    });
  }

  Future<void> _onCreate(
    CreateMasterIuranEvent event,
    Emitter<MasterIuranState> emit,
  ) async {
    emit(MasterIuranLoading());
    final Either<Failure, MasterIuran> result = await createMasterIuran(
      event.masterIuran,
    );

    result.fold((failure) => emit(MasterIuranError(failure.message)), (
      masterIuran,
    ) {
      emit(const MasterIuranActionSuccess('Iuran berhasil ditambahkan'));
    });
  }

  Future<void> _onUpdate(
    UpdateMasterIuranEvent event,
    Emitter<MasterIuranState> emit,
  ) async {
    emit(MasterIuranLoading());
    final Either<Failure, MasterIuran> result = await updateMasterIuran(
      event.masterIuran,
    );

    result.fold((failure) => emit(MasterIuranError(failure.message)), (
      masterIuran,
    ) {
      emit(const MasterIuranActionSuccess('Iuran berhasil diperbarui'));
    });
  }

  Future<void> _onDelete(
    DeleteMasterIuranEvent event,
    Emitter<MasterIuranState> emit,
  ) async {
    emit(MasterIuranLoading());
    final Either<Failure, void> result = await deleteMasterIuran(event.id);

    result.fold((failure) => emit(MasterIuranError(failure.message)), (_) {
      emit(const MasterIuranActionSuccess('Iuran berhasil dihapus'));
    });
  }
}
