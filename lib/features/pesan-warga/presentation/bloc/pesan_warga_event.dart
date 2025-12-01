part of 'pesan_warga_bloc.dart';

abstract class AspirasiEvent extends Equatable {
  const AspirasiEvent();

  @override
  List<Object?> get props => [];
}

class LoadAspirasi extends AspirasiEvent {}

class GetAspirasiById extends AspirasiEvent {
  final int id;
  const GetAspirasiById(this.id);

  @override
  List<Object?> get props => [id];
}

class AddAspirasi extends AspirasiEvent {
  final Aspirasi aspirasi;
  const AddAspirasi(this.aspirasi);

  @override
  List<Object?> get props => [aspirasi];
}

class UpdateAspirasi extends AspirasiEvent {
  final Aspirasi aspirasi;
  const UpdateAspirasi(this.aspirasi);

  @override
  List<Object?> get props => [aspirasi];
}

class DeleteAspirasi extends AspirasiEvent {
  final int id;
  const DeleteAspirasi(this.id);

  @override
  List<Object?> get props => [id];
}