import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/pemasukan.dart';
import '../../domain/usecases/get_pemasukan_list.dart';
import '../../domain/usecases/get_pemasukan_detail.dart';
import '../../domain/usecases/create_pemasukan.dart';
import '../../domain/usecases/update_pemasukan.dart';
import '../../domain/usecases/delete_pemasukan.dart';
import '../../domain/repositories/pemasukan_repository.dart';

part 'pemasukan_event.dart';
part 'pemasukan_state.dart';

class PemasukanBloc extends Bloc<PemasukanEvent, PemasukanState> {
  final GetPemasukanList getPemasukanList;
  final GetPemasukanDetail getPemasukanDetail;
  final CreatePemasukan createPemasukan;
  final UpdatePemasukan updatePemasukan;
  final DeletePemasukan deletePemasukan;
  final PemasukanRepository repository;

  PemasukanBloc({
    required this.getPemasukanList,
    required this.getPemasukanDetail,
    required this.createPemasukan,
    required this.updatePemasukan,
    required this.deletePemasukan,
    required this.repository,
  }) : super(PemasukanInitial()) {
    on<GetPemasukanListEvent>(_onGetPemasukanList);
    on<GetPemasukanDetailEvent>(_onGetPemasukanDetail);
    on<CreatePemasukanEvent>(_onCreatePemasukan);
    on<UpdatePemasukanEvent>(_onUpdatePemasukan);
    on<DeletePemasukanEvent>(_onDeletePemasukan);
  }

  Future<void> _onGetPemasukanList(
    GetPemasukanListEvent event,
    Emitter<PemasukanState> emit,
  ) async {
    emit(PemasukanLoading());
    final result = await getPemasukanList(kategoriFilter: event.kategoriFilter);
    result.fold(
      (failure) => emit(PemasukanError(failure.message)),
      (pemasukanList) => emit(PemasukanListLoaded(pemasukanList)),
    );
  }

  Future<void> _onGetPemasukanDetail(
    GetPemasukanDetailEvent event,
    Emitter<PemasukanState> emit,
  ) async {
    emit(PemasukanLoading());
    final result = await getPemasukanDetail(event.id);
    result.fold(
      (failure) => emit(PemasukanError(failure.message)),
      (pemasukan) => emit(PemasukanDetailLoaded(pemasukan)),
    );
  }

  Future<void> _onCreatePemasukan(
    CreatePemasukanEvent event,
    Emitter<PemasukanState> emit,
  ) async {
    emit(PemasukanLoading());

    try {
      String? fotoUrl;
      if (event.buktiFile != null) {
        fotoUrl = await repository.uploadBukti(event.buktiFile!);
      }

      final result = await createPemasukan(
        judul: event.judul,
        kategoriTransaksiId: event.kategoriTransaksiId,
        nominal: event.nominal,
        tanggalTransaksi: event.tanggalTransaksi,
        buktiFoto: fotoUrl ?? event.buktiFoto,
        keterangan: event.keterangan,
      );
      result.fold(
        (failure) => emit(PemasukanError(failure.message)),
        (_) => emit(
          const PemasukanActionSuccess('Pemasukan berhasil ditambahkan'),
        ),
      );
    } catch (e) {
      emit(PemasukanError(e.toString()));
    }
  }

  Future<void> _onUpdatePemasukan(
    UpdatePemasukanEvent event,
    Emitter<PemasukanState> emit,
  ) async {
    emit(PemasukanLoading());

    try {
      String? fotoUrl = event.buktiFoto;

      if (event.buktiFile != null) {
        fotoUrl = await repository.uploadBukti(
          event.buktiFile!,
          oldUrl: event.oldBuktiUrl,
        );
      }

      final result = await updatePemasukan(
        id: event.id,
        judul: event.judul,
        kategoriTransaksiId: event.kategoriTransaksiId,
        nominal: event.nominal,
        tanggalTransaksi: event.tanggalTransaksi,
        buktiFoto: fotoUrl,
        keterangan: event.keterangan,
      );
      result.fold(
        (failure) => emit(PemasukanError(failure.message)),
        (_) =>
            emit(const PemasukanActionSuccess('Pemasukan berhasil diperbarui')),
      );
    } catch (e) {
      emit(PemasukanError(e.toString()));
    }
  }

  Future<void> _onDeletePemasukan(
    DeletePemasukanEvent event,
    Emitter<PemasukanState> emit,
  ) async {
    emit(PemasukanLoading());
    final result = await deletePemasukan(event.id);
    result.fold(
      (failure) => emit(PemasukanError(failure.message)),
      (_) => emit(const PemasukanActionSuccess('Pemasukan berhasil dihapus')),
    );
  }
}
