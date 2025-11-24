import 'package:equatable/equatable.dart';
import '../../domain/entities/pengeluaran.dart';

abstract class PengeluaranState extends Equatable {
  const PengeluaranState();
  @override
  List<Object?> get props => [];
}

class PengeluaranInitial extends PengeluaranState {}

class PengeluaranLoading extends PengeluaranState {}

class PengeluaranLoaded extends PengeluaranState {
  final List<Pengeluaran> items;
  const PengeluaranLoaded(this.items);

  @override
  List<Object?> get props => [items];
}

class PengeluaranEmpty extends PengeluaranState {}

class PengeluaranError extends PengeluaranState {
  final String message;
  const PengeluaranError(this.message);

  @override
  List<Object?> get props => [message];
}

class PengeluaranActionSuccess extends PengeluaranState {
  final String message;
  const PengeluaranActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}