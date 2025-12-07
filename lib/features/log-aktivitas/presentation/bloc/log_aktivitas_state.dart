part of 'log_aktivitas_bloc.dart';

abstract class LogAktivitasState extends Equatable {
  const LogAktivitasState();  

  @override
  List<Object?> get props => [];
}
class LogAktivitasInitial extends LogAktivitasState {}

class LogAktivitasLoading extends LogAktivitasState {}

class LogAktivitasLoaded extends LogAktivitasState {
  final List<LogAktivitas> items;
  const LogAktivitasLoaded(this.items);

  @override
  List<Object?> get props => [items];
}

class LogAktivitasError extends LogAktivitasState {
  final String message;
  const LogAktivitasError(this.message);

  @override
  List<Object?> get props => [message];
}

