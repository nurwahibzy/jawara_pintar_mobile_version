part of 'warga_bloc.dart';

sealed class WargaState extends Equatable {
  const WargaState();

  @override
  List<Object?> get props => [];
}

class WargaInitial extends WargaState {}

class WargaLoading extends WargaState {}

class WargaEmpty extends WargaState {}

class WargaError extends WargaState {
  final String message;
  const WargaError(this.message);

  @override
  List<Object?> get props => [message];
}

class WargaLoaded extends WargaState {
  final List<Warga> result;
  const WargaLoaded(this.result);

  @override
  List<Object?> get props => [result];
}

class WargaDetailLoaded extends WargaState {
  final Warga warga;
  const WargaDetailLoaded(this.warga);

  @override
  List<Object?> get props => [warga];
}

class WargaActionSuccess extends WargaState {
  final String message;
  const WargaActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

// Keluarga States
class KeluargaLoading extends WargaState {}

class KeluargaLoaded extends WargaState {
  final List<Keluarga> keluargaList;
  const KeluargaLoaded(this.keluargaList);

  @override
  List<Object?> get props => [keluargaList];
}

class KeluargaError extends WargaState {
  final String message;
  const KeluargaError(this.message);

  @override
  List<Object?> get props => [message];
}

class KeluargaListLoaded extends WargaState {
  final List<Keluarga> keluargaList;
  const KeluargaListLoaded(this.keluargaList);

  @override
  List<Object?> get props => [keluargaList];
}

class KeluargaDetailLoaded extends WargaState {
  final Keluarga keluarga;
  const KeluargaDetailLoaded(this.keluarga);

  @override
  List<Object?> get props => [keluarga];
}

class KeluargaActionSuccess extends WargaState {
  final String message;
  final int? keluargaId;
  const KeluargaActionSuccess(this.message, {this.keluargaId});

  @override
  List<Object?> get props => [message, keluargaId];
}

// Rumah States
class RumahLoading extends WargaState {}

class RumahListLoaded extends WargaState {
  final List<Map<String, dynamic>> rumahList;
  const RumahListLoaded(this.rumahList);

  @override
  List<Object?> get props => [rumahList];
}

class RumahError extends WargaState {
  final String message;
  const RumahError(this.message);

  @override
  List<Object?> get props => [message];
}

// Warga Tanpa Keluarga States
class WargaTanpaKeluargaLoaded extends WargaState {
  final List<Warga> wargaList;
  const WargaTanpaKeluargaLoaded(this.wargaList);

  @override
  List<Object?> get props => [wargaList];
}
