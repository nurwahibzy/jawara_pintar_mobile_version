import 'package:equatable/equatable.dart';
import '../../domain/entities/master_iuran.dart';

abstract class MasterIuranEvent extends Equatable {
  const MasterIuranEvent();

  @override
  List<Object?> get props => [];
}

class LoadMasterIuranList extends MasterIuranEvent {
  const LoadMasterIuranList();
}

class RefreshMasterIuranList extends MasterIuranEvent {
  const RefreshMasterIuranList();
}

class LoadMasterIuranById extends MasterIuranEvent {
  final int id;

  const LoadMasterIuranById(this.id);

  @override
  List<Object?> get props => [id];
}

class LoadMasterIuranByKategori extends MasterIuranEvent {
  final int kategoriId;

  const LoadMasterIuranByKategori(this.kategoriId);

  @override
  List<Object?> get props => [kategoriId];
}

class CreateMasterIuranEvent extends MasterIuranEvent {
  final MasterIuran masterIuran;

  const CreateMasterIuranEvent(this.masterIuran);

  @override
  List<Object?> get props => [masterIuran];
}

class UpdateMasterIuranEvent extends MasterIuranEvent {
  final MasterIuran masterIuran;

  const UpdateMasterIuranEvent(this.masterIuran);

  @override
  List<Object?> get props => [masterIuran];
}

class DeleteMasterIuranEvent extends MasterIuranEvent {
  final int id;

  const DeleteMasterIuranEvent(this.id);

  @override
  List<Object?> get props => [id];
}
