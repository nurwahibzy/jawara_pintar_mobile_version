part of 'mutasi_keluarga_bloc.dart';

abstract class MutasiKeluargaEvent extends Equatable {}

class MutasiKeluargaEventGetAll extends MutasiKeluargaEvent {
  @override
  List<Object?> get props => [];
}

class MutasiKeluargaEventGet extends MutasiKeluargaEvent {
  final int id;
  MutasiKeluargaEventGet(this.id);
  @override
  List<Object?> get props => [];
}

class MutasiKeluargaEventCreate extends MutasiKeluargaEvent {
  final MutasiKeluargaModel mutasi;
  MutasiKeluargaEventCreate(this.mutasi);
  @override
  List<Object?> get props => [];
}

class MutasiKeluargaEventLoadForm extends MutasiKeluargaEvent {
  @override
  List<Object?> get props => [];
}
