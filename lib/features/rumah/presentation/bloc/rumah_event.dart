part of 'rumah_bloc.dart';

sealed class RumahEvent extends Equatable {
  const RumahEvent();

  @override
  List<Object?> get props => [];
}

class LoadAllRumah extends RumahEvent {}

class RefreshRumah extends RumahEvent {}

class GetDetailRumah extends RumahEvent {
  final int id;
  const GetDetailRumah(this.id);

  @override
  List<Object?> get props => [id];
}

class CreateRumahEvent extends RumahEvent {
  final Rumah rumah;
  const CreateRumahEvent(this.rumah);

  @override
  List<Object?> get props => [rumah];
}

class UpdateRumahEvent extends RumahEvent {
  final Rumah rumah;
  const UpdateRumahEvent(this.rumah);

  @override
  List<Object?> get props => [rumah];
}

class DeleteRumahEvent extends RumahEvent {
  final int id;
  const DeleteRumahEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class FilterRumahEvent extends RumahEvent {
  final FilterRumahParams params;
  const FilterRumahEvent(this.params);

  @override
  List<Object?> get props => [params];
}
