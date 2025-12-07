import 'package:equatable/equatable.dart';
import '../../domain/entities/master_iuran.dart';

abstract class MasterIuranState extends Equatable {
  const MasterIuranState();

  @override
  List<Object?> get props => [];
}

class MasterIuranInitial extends MasterIuranState {}

class MasterIuranLoading extends MasterIuranState {}

class MasterIuranLoaded extends MasterIuranState {
  final List<MasterIuran> masterIuranList;

  const MasterIuranLoaded(this.masterIuranList);

  @override
  List<Object?> get props => [masterIuranList];
}

class MasterIuranDetailLoaded extends MasterIuranState {
  final MasterIuran masterIuran;

  const MasterIuranDetailLoaded(this.masterIuran);

  @override
  List<Object?> get props => [masterIuran];
}

class MasterIuranEmpty extends MasterIuranState {}

class MasterIuranError extends MasterIuranState {
  final String message;

  const MasterIuranError(this.message);

  @override
  List<Object?> get props => [message];
}

class MasterIuranActionSuccess extends MasterIuranState {
  final String message;

  const MasterIuranActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}
