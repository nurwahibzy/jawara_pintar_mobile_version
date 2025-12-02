part of 'mutasi_keluarga_bloc.dart';

abstract class MutasiKeluargaState extends Equatable {
  const MutasiKeluargaState();

  @override
  List<Object?> get props => [];
}

class MutasiKeluargaInitial extends MutasiKeluargaState {}

class MutasiKeluargaLoading extends MutasiKeluargaState {}

class MutasiKeluargaLoaded extends MutasiKeluargaState {
  final List<MutasiKeluarga> items;
  const MutasiKeluargaLoaded(this.items);

  @override
  List<Object?> get props => [items];
}

class MutasiKeluargaLoadedSingle extends MutasiKeluargaState {
  final MutasiKeluarga item;
  const MutasiKeluargaLoadedSingle(this.item);

  @override
  List<Object?> get props => [item];
}

class MutasiKeluargaEmpty extends MutasiKeluargaState {}

class MutasiKeluargaError extends MutasiKeluargaState {
  final String message;
  const MutasiKeluargaError(this.message);

  @override
  List<Object?> get props => [message];
}

class MutasiKeluargaActionSuccess extends MutasiKeluargaState {
  final String message;
  const MutasiKeluargaActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class MutasiKeluargaFormReady extends MutasiKeluargaState {
  final List<dynamic> listKeluarga;
  final List<dynamic> listRumah;
  final List<dynamic> listWarga;

  const MutasiKeluargaFormReady({required this.listKeluarga, required this.listRumah, required this.listWarga});
  
  @override
  List<Object?> get props => [listKeluarga, listRumah];
}