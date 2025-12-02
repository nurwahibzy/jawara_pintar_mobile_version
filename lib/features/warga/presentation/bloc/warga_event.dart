part of 'warga_bloc.dart';

sealed class WargaEvent extends Equatable {
  const WargaEvent();

  @override
  List<Object?> get props => [];
}

class LoadWarga extends WargaEvent {}

class RefreshWarga extends WargaEvent {}

class GetDetailWarga extends WargaEvent {
  final int id;
  const GetDetailWarga(this.id);

  @override
  List<Object?> get props => [id];
}

class CreateWargaEvent extends WargaEvent {
  final Warga warga;
  const CreateWargaEvent(this.warga);

  @override
  List<Object?> get props => [warga];
}

class UpdateWargaEvent extends WargaEvent {
  final Warga warga;
  const UpdateWargaEvent(this.warga);

  @override
  List<Object?> get props => [warga];
}

class FilterWargaEvent extends WargaEvent {
  final FilterWargaParams params;
  const FilterWargaEvent(this.params);

  @override
  List<Object?> get props => [params];
}

class LoadKeluargaEvent extends WargaEvent {}

class SearchKeluargaEvent extends WargaEvent {
  final String query;
  const SearchKeluargaEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class LoadAllKeluargaWithRelations extends WargaEvent {}

class GetDetailKeluarga extends WargaEvent {
  final int id;
  const GetDetailKeluarga(this.id);

  @override
  List<Object?> get props => [id];
}

class LoadRumahEvent extends WargaEvent {}

class SearchRumahEvent extends WargaEvent {
  final String query;
  const SearchRumahEvent(this.query);

  @override
  List<Object?> get props => [query];
}
