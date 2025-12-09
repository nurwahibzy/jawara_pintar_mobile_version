import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/tagihan_pembayaran.dart';
import '../../domain/usecases/get_tagihan_pembayaran_list.dart';
import '../../domain/usecases/get_tagihan_pembayaran_detail.dart';
import '../../domain/usecases/approve_tagihan_pembayaran.dart';
import '../../domain/usecases/reject_tagihan_pembayaran.dart';

part 'tagihan_event.dart';
part 'tagihan_state.dart';

class TagihanBloc extends Bloc<TagihanEvent, TagihanState> {
  final GetTagihanPembayaranList getTagihanPembayaranList;
  final GetTagihanPembayaranDetail getTagihanPembayaranDetail;
  final ApproveTagihanPembayaran approveTagihanPembayaran;
  final RejectTagihanPembayaran rejectTagihanPembayaran;

  TagihanBloc({
    required this.getTagihanPembayaranList,
    required this.getTagihanPembayaranDetail,
    required this.approveTagihanPembayaran,
    required this.rejectTagihanPembayaran,
  }) : super(TagihanInitial()) {
    on<LoadTagihanPembayaranList>(_onLoadTagihanList);
    on<LoadTagihanPembayaranDetail>(_onLoadTagihanDetail);
    on<ApproveTagihan>(_onApproveTagihan);
    on<RejectTagihan>(_onRejectTagihan);
  }

  Future<void> _onLoadTagihanList(
    LoadTagihanPembayaranList event,
    Emitter<TagihanState> emit,
  ) async {
    emit(TagihanLoading());
    final result = await getTagihanPembayaranList(
      statusFilter: event.statusFilter,
    );
    result.fold(
      (failure) => emit(TagihanError(failure.message)),
      (tagihanList) => emit(TagihanListLoaded(tagihanList)),
    );
  }

  Future<void> _onLoadTagihanDetail(
    LoadTagihanPembayaranDetail event,
    Emitter<TagihanState> emit,
  ) async {
    emit(TagihanLoading());
    final result = await getTagihanPembayaranDetail(event.id);
    result.fold(
      (failure) => emit(TagihanError(failure.message)),
      (tagihan) => emit(TagihanDetailLoaded(tagihan)),
    );
  }

  Future<void> _onApproveTagihan(
    ApproveTagihan event,
    Emitter<TagihanState> emit,
  ) async {
    emit(TagihanLoading());
    final result = await approveTagihanPembayaran(
      id: event.id,
      catatan: event.catatan,
    );
    result.fold(
      (failure) => emit(TagihanError(failure.message)),
      (_) => emit(const TagihanActionSuccess('Pembayaran berhasil disetujui')),
    );
  }

  Future<void> _onRejectTagihan(
    RejectTagihan event,
    Emitter<TagihanState> emit,
  ) async {
    emit(TagihanLoading());
    final result = await rejectTagihanPembayaran(
      id: event.id,
      catatan: event.catatan,
    );
    result.fold(
      (failure) => emit(TagihanError(failure.message)),
      (_) => emit(const TagihanActionSuccess('Pembayaran berhasil ditolak')),
    );
  }
}
