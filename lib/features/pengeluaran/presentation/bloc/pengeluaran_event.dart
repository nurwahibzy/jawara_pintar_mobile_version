import 'package:equatable/equatable.dart';
import '../../domain/entities/pengeluaran.dart';

abstract class PengeluaranEvent extends Equatable {
  const PengeluaranEvent();
  @override
  List<Object?> get props => [];
}

class LoadPengeluaran extends PengeluaranEvent {
  const LoadPengeluaran();
}

class RefreshPengeluaran extends PengeluaranEvent {
  const RefreshPengeluaran();
}

class DeletePengeluaranEvent extends PengeluaranEvent {
  final int id;
  const DeletePengeluaranEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class CreatePengeluaranEvent extends PengeluaranEvent {
  final Pengeluaran pengeluaran;
  const CreatePengeluaranEvent(this.pengeluaran);

  @override
  List<Object?> get props => [pengeluaran];
}

class UpdatePengeluaranEvent extends PengeluaranEvent {
  final Pengeluaran pengeluaran;
  const UpdatePengeluaranEvent(this.pengeluaran);

  @override
  List<Object?> get props => [pengeluaran];
}