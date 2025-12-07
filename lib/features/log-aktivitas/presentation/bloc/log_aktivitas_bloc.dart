import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:jawara_pintar_mobile_version/core/errors/failure.dart';
import 'package:jawara_pintar_mobile_version/features/log-aktivitas/domain/entities/log_aktivitas.dart';
import 'package:jawara_pintar_mobile_version/features/log-aktivitas/domain/usecases/get_all_log_aktivitas.dart';

part 'log_aktivitas_event.dart';
part 'log_aktivitas_state.dart';

class LogAktivitasBloc extends Bloc<LogAktivitasEvent, LogAktivitasState> {

  final GetAllLogAktivitas getAllLogAktivitas;
  LogAktivitasBloc({required this.getAllLogAktivitas}) : super(LogAktivitasInitial()) {
    
    on<LogAktivitasEventGetAll>((event, emit) async {
      Either<Failure, List<LogAktivitas>> result = await getAllLogAktivitas
          .execute();
      result.fold(
        (failure) { 
          emit(LogAktivitasError(failure.message));
        },
        (logAktivitasList) {
          emit(LogAktivitasLoaded(logAktivitasList));
        },
      );
    });
  }
}
