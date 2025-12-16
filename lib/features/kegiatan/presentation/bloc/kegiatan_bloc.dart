import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/kegiatan.dart';
import '../../domain/entities/transaksi_kegiatan.dart';
import '../../domain/usecases/get_kegiatan_list.dart';
import '../../domain/usecases/get_kegiatan_detail.dart';
import '../../domain/usecases/create_kegiatan.dart';
import '../../domain/usecases/update_kegiatan.dart';
import '../../domain/usecases/get_transaksi_kegiatan.dart';
import '../../domain/usecases/create_transaksi_kegiatan.dart';
import '../../domain/usecases/delete_transaksi_kegiatan.dart';

part 'kegiatan_event.dart';
part 'kegiatan_state.dart';

class KegiatanBloc extends Bloc<KegiatanEvent, KegiatanState> {
  final GetKegiatanList getKegiatanList;
  final GetKegiatanDetail getKegiatanDetail;
  final CreateKegiatan createKegiatan;
  final UpdateKegiatan updateKegiatan;
  final GetTransaksiKegiatan getTransaksiKegiatan;
  final CreateTransaksiKegiatan createTransaksiKegiatan;
  final DeleteTransaksiKegiatan deleteTransaksiKegiatan;

  KegiatanBloc({
    required this.getKegiatanList,
    required this.getKegiatanDetail,
    required this.createKegiatan,
    required this.updateKegiatan,
    required this.getTransaksiKegiatan,
    required this.createTransaksiKegiatan,
    required this.deleteTransaksiKegiatan,
  }) : super(KegiatanInitial()) {
    on<GetKegiatanListEvent>(_onGetKegiatanList);
    on<GetKegiatanDetailEvent>(_onGetKegiatanDetail);
    on<CreateKegiatanEvent>(_onCreateKegiatan);
    on<UpdateKegiatanEvent>(_onUpdateKegiatan);
    on<GetTransaksiKegiatanEvent>(_onGetTransaksiKegiatan);
    on<CreateTransaksiKegiatanEvent>(_onCreateTransaksiKegiatan);
    on<DeleteTransaksiKegiatanEvent>(_onDeleteTransaksiKegiatan);
  }

  Future<void> _onGetKegiatanList(
    GetKegiatanListEvent event,
    Emitter<KegiatanState> emit,
  ) async {
    emit(KegiatanLoading());
    final result = await getKegiatanList();
    result.fold(
      (failure) => emit(KegiatanError(failure.message)),
      (kegiatanList) => emit(KegiatanListLoaded(kegiatanList)),
    );
  }

  Future<void> _onGetKegiatanDetail(
    GetKegiatanDetailEvent event,
    Emitter<KegiatanState> emit,
  ) async {
    emit(KegiatanLoading());
    final result = await getKegiatanDetail(event.id);
    result.fold(
      (failure) => emit(KegiatanError(failure.message)),
      (kegiatan) => emit(KegiatanDetailLoaded(kegiatan)),
    );
  }

  Future<void> _onCreateKegiatan(
    CreateKegiatanEvent event,
    Emitter<KegiatanState> emit,
  ) async {
    emit(KegiatanLoading());
    final result = await createKegiatan(event.kegiatan);
    result.fold(
      (failure) => emit(KegiatanError(failure.message)),
      (_) => emit(const KegiatanActionSuccess('Kegiatan berhasil ditambahkan')),
    );
  }

  Future<void> _onUpdateKegiatan(
    UpdateKegiatanEvent event,
    Emitter<KegiatanState> emit,
  ) async {
    emit(KegiatanLoading());
    final result = await updateKegiatan(event.kegiatan);
    result.fold(
      (failure) => emit(KegiatanError(failure.message)),
      (_) => emit(const KegiatanActionSuccess('Kegiatan berhasil diperbarui')),
    );
  }

  // ==================== TRANSAKSI HANDLERS ====================

  Future<void> _onGetTransaksiKegiatan(
    GetTransaksiKegiatanEvent event,
    Emitter<KegiatanState> emit,
  ) async {
    emit(KegiatanLoading());
    final result = await getTransaksiKegiatan(event.kegiatanId);
    result.fold(
      (failure) => emit(KegiatanError(failure.message)),
      (transaksiList) => emit(TransaksiKegiatanLoaded(transaksiList)),
    );
  }

  Future<void> _onCreateTransaksiKegiatan(
    CreateTransaksiKegiatanEvent event,
    Emitter<KegiatanState> emit,
  ) async {
    emit(KegiatanLoading());
    final result = await createTransaksiKegiatan(event.transaksi);
    result.fold(
      (failure) => emit(KegiatanError(failure.message)),
      (_) =>
          emit(const TransaksiActionSuccess('Transaksi berhasil ditambahkan')),
    );
  }

  Future<void> _onDeleteTransaksiKegiatan(
    DeleteTransaksiKegiatanEvent event,
    Emitter<KegiatanState> emit,
  ) async {
    emit(KegiatanLoading());
    final result = await deleteTransaksiKegiatan(event.transaksiId);
    result.fold((failure) => emit(KegiatanError(failure.message)), (_) {
      emit(const TransaksiActionSuccess('Transaksi berhasil dihapus'));
      // Reload transaksi list
      add(GetTransaksiKegiatanEvent(event.kegiatanId));
    });
  }
}
