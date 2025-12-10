import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/master_iuran_dropdown.dart';
import '../../domain/usecases/get_master_iuran_dropdown.dart';
import '../../domain/usecases/create_tagih_iuran.dart';

part 'tagih_iuran_event.dart';
part 'tagih_iuran_state.dart';

class TagihIuranBloc extends Bloc<TagihIuranEvent, TagihIuranState> {
  final GetMasterIuranDropdown getMasterIuranDropdown;
  final CreateTagihIuran createTagihIuran;

  TagihIuranBloc({
    required this.getMasterIuranDropdown,
    required this.createTagihIuran,
  }) : super(TagihIuranInitial()) {
    on<LoadMasterIuranDropdown>(_onLoadMasterIuranDropdown);
    on<CreateTagihIuranEvent>(_onCreateTagihIuran);
    on<ResetTagihIuranState>(_onResetState);
  }

  Future<void> _onLoadMasterIuranDropdown(
    LoadMasterIuranDropdown event,
    Emitter<TagihIuranState> emit,
  ) async {
    emit(TagihIuranLoading());

    final result = await getMasterIuranDropdown();

    result.fold((failure) => emit(TagihIuranError(failure.message)), (
      masterIuranList,
    ) {
      if (masterIuranList.isEmpty) {
        emit(const TagihIuranError('Tidak ada master iuran aktif'));
      } else {
        emit(DropdownLoaded(masterIuranList));
      }
    });
  }

  Future<void> _onCreateTagihIuran(
    CreateTagihIuranEvent event,
    Emitter<TagihIuranState> emit,
  ) async {
    emit(TagihIuranLoading());

    final result = await createTagihIuran(
      masterIuranId: event.masterIuranId,
      periode: event.periode,
    );

    result.fold(
      (failure) => emit(TagihIuranError(failure.message)),
      (_) => emit(const TagihIuranSuccess('Tagihan berhasil digenerate')),
    );
  }

  void _onResetState(
    ResetTagihIuranState event,
    Emitter<TagihIuranState> emit,
  ) {
    emit(TagihIuranInitial());
  }
}
