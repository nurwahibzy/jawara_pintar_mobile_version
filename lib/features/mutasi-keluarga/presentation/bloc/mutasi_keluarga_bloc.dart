import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:jawara_pintar_mobile_version/features/mutasi-keluarga/data/models/mutasi_keluarga_models.dart';
import 'package:jawara_pintar_mobile_version/features/mutasi-keluarga/domain/usecases/get_form_data_options.dart';

import '../../../../core/errors/failure.dart';
import '../../domain/entities/mutasi_keluarga.dart';
import '../../domain/usecases/create_mutasi_keluarga.dart';
import '../../domain/usecases/get_all_mutasi_keluarga.dart';
import '../../domain/usecases/get_mutasi_keluarga.dart';

part 'mutasi_keluarga_event.dart';
part 'mutasi_keluarga_state.dart';

class MutasiKeluargaBloc
    extends Bloc<MutasiKeluargaEvent, MutasiKeluargaState> {
  final GetAllMutasiKeluarga getAllMutasiKeluarga;
  final GetMutasiKeluarga getMutasiKeluarga;
  final CreateMutasiKeluarga createMutasiKeluarga;
  final GetFormDataOptions getFormDataOptions;

  MutasiKeluargaBloc({
    required this.getAllMutasiKeluarga,
    required this.getMutasiKeluarga,
    required this.createMutasiKeluarga,
    required this.getFormDataOptions,
  }) : super(MutasiKeluargaInitial()) {
    on<MutasiKeluargaEventGetAll>((event, emit) async {
      Either<Failure, List<MutasiKeluarga>> result = await getAllMutasiKeluarga
          .execute();
      result.fold(
        (failure) {
          emit(MutasiKeluargaError("Failed to fetch data"));
        },
        (mutasiKeluargaList) {
          emit(MutasiKeluargaLoaded(mutasiKeluargaList));
        },
      );
    });
    on<MutasiKeluargaEventGet>((event, emit) async {
      Either<Failure, MutasiKeluarga> result = await getMutasiKeluarga.execute(
        event.id,
      );
      result.fold(
        (failure) {
          emit(MutasiKeluargaError("Failed to fetch data"));
        },
        (mutasiKeluarga) {
          emit(MutasiKeluargaLoadedSingle(mutasiKeluarga));
        },
      );
    });
    on<MutasiKeluargaEventCreate>((event, emit) async {
      Either<Failure, bool> result = await createMutasiKeluarga.execute(
        event.mutasi,
      );
      result.fold(
        (failure) {
          emit(MutasiKeluargaError("Failed to create data"));
        },
        (success) {
          emit(MutasiKeluargaActionSuccess("Data created successfully"));
        },
      );
    });
    on<MutasiKeluargaEventLoadForm>((event, emit) async {
      emit(MutasiKeluargaLoading());

      final result = await getFormDataOptions.execute();

      result.fold((failure) => emit(MutasiKeluargaError(failure.message)), (
        data,
      ) {
        emit(
          MutasiKeluargaFormReady(
            listKeluarga: data['keluarga']!,
            listRumah: data['rumah']!,
            listWarga: data['warga']!,
          ),
        );
      });
    });
  }
}
