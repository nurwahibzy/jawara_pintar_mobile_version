import 'dart:io';

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
  final File? buktiFile;

  CreatePengeluaranEvent(this.pengeluaran, {this.buktiFile});
}

class UpdatePengeluaranEvent extends PengeluaranEvent {
  final Pengeluaran pengeluaran;
  final File? buktiFile;
  final String? oldBuktiUrl; 

  const UpdatePengeluaranEvent({
    required this.pengeluaran,
    this.buktiFile,
    this.oldBuktiUrl,
  });

  @override
  List<Object?> get props => [pengeluaran, buktiFile, oldBuktiUrl];
}

class LoadKategoriPengeluaran extends PengeluaranEvent {}