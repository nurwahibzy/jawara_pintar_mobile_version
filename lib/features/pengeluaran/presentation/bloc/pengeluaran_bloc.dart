import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../domain/entities/kategori_transaksi.dart';
import '../../domain/entities/pengeluaran.dart';
import '../../domain/repositories/pengeluaran_repository.dart';
import 'pengeluaran_event.dart';
import 'pengeluaran_state.dart';

class PengeluaranBloc extends Bloc<PengeluaranEvent, PengeluaranState> {
  final PengeluaranRepository repository;

  PengeluaranBloc({required this.repository}) : super(PengeluaranInitial()) {
    on<LoadPengeluaran>(_onLoad);
    on<RefreshPengeluaran>(_onLoad);
    on<DeletePengeluaranEvent>(_onDelete);
    on<CreatePengeluaranEvent>(_onCreate);
    on<UpdatePengeluaranEvent>(_onUpdate);
    on<LoadKategoriPengeluaran>(_onLoadKategori);
  }

  Future<void> _onLoad(
    PengeluaranEvent event,
    Emitter<PengeluaranState> emit,
  ) async {
    emit(PengeluaranLoading());
    final Either<Failure, List<Pengeluaran>> res = await repository
        .getAllPengeluaran();
    res.fold((failure) => emit(PengeluaranError(failure.message)), (list) {
      if (list.isEmpty) {
        emit(PengeluaranEmpty());
      } else {
        emit(PengeluaranLoaded(list));
      }
    });
  }

  Future<void> _onDelete(
    DeletePengeluaranEvent event,
    Emitter<PengeluaranState> emit,
  ) async {
    emit(PengeluaranLoading());
    final Either<Failure, bool> res = await repository.deletePengeluaran(
      event.id,
    );
    res.fold((failure) => emit(PengeluaranError(failure.message)), (ok) {
      if (ok) {
        add(const RefreshPengeluaran());
        emit(const PengeluaranActionSuccess('Hapus berhasil'));
      } else {
        emit(const PengeluaranError('Hapus gagal'));
      }
    });
  }

  Future<void> _onCreate(
    CreatePengeluaranEvent event,
    Emitter<PengeluaranState> emit,
  ) async {
    emit(PengeluaranLoading());
    final Either<Failure, bool> res = await repository.createPengeluaran(
      event.pengeluaran,
    );
    res.fold((failure) => emit(PengeluaranError(failure.message)), (ok) {
      if (ok) {
        add(const RefreshPengeluaran());
        emit(const PengeluaranActionSuccess('Create berhasil'));
      } else {
        emit(const PengeluaranError('Create gagal'));
      }
    });
  }

  Future<void> _onUpdate(
    UpdatePengeluaranEvent event,
    Emitter<PengeluaranState> emit,
  ) async {
    emit(PengeluaranLoading());
    final Either<Failure, bool> res = await repository.updatePengeluaran(
      event.pengeluaran,
    );
    res.fold((failure) => emit(PengeluaranError(failure.message)), (ok) {
      if (ok) {
        add(const RefreshPengeluaran());
        emit(const PengeluaranActionSuccess('Update berhasil'));
      } else {
        emit(const PengeluaranError('Update gagal'));
      }
    });
  }

 Future<void> _onLoadKategori(
    LoadKategoriPengeluaran event,
    Emitter<PengeluaranState> emit,
  ) async {
    emit(PengeluaranLoading());

    final res = await repository.getKategoriPengeluaran();
    res.fold((failure) => emit(PengeluaranError(failure.message)), (list) {
      final kategoriEntities = list
          .map(
            (m) => KategoriEntity(
              id: m.id,
              jenis: m.jenis,
              nama_kategori: m.nama_kategori, 
            ),
          )
          .toList();

      emit(KategoriPengeluaranLoaded(kategoriEntities));
    });
  }
}