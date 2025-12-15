import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/penerimaan_warga.dart';
import '../../domain/use_cases/get_penerimaan_warga.dart';


// EVENT
abstract class PenerimaanWargaEvent {}


class LoadPenerimaanWarga extends PenerimaanWargaEvent {}


// STATE
abstract class PenerimaanWargaState {}


class PenerimaanWargaInitial extends PenerimaanWargaState {}
class PenerimaanWargaLoading extends PenerimaanWargaState {}


class PenerimaanWargaLoaded extends PenerimaanWargaState {
final List<PenerimaanWarga> data;
PenerimaanWargaLoaded(this.data);
}


class PenerimaanWargaError extends PenerimaanWargaState {
final String message;
PenerimaanWargaError(this.message);
}


// BLOC
class PenerimaanWargaBloc
extends Bloc<PenerimaanWargaEvent, PenerimaanWargaState> {
final GetPenerimaanWarga getData;


PenerimaanWargaBloc(this.getData)
: super(PenerimaanWargaInitial()) {
on<LoadPenerimaanWarga>((event, emit) async {
emit(PenerimaanWargaLoading());
try {
final result = await getData();
emit(PenerimaanWargaLoaded(result));
} catch (e) {
emit(PenerimaanWargaError(e.toString()));
}
});
}
}