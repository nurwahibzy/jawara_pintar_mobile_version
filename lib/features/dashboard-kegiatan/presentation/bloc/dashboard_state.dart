import 'package:equatable/equatable.dart';
import '../../domain/entities/kegiatan_entity.dart';

/// Base class untuk Dashboard Kegiatan States
abstract class DashboardKegiatanState extends Equatable {
  const DashboardKegiatanState();

  @override
  List<Object> get props => [];
}

/// Initial state
class DashboardKegiatanInitial extends DashboardKegiatanState {}

/// Loading state
class DashboardKegiatanLoading extends DashboardKegiatanState {}

/// Loaded state dengan data
class DashboardKegiatanLoaded extends DashboardKegiatanState {
  final DashboardKegiatanEntity dashboard;

  const DashboardKegiatanLoaded({required this.dashboard});

  @override
  List<Object> get props => [dashboard];
}

/// Error state
class DashboardKegiatanError extends DashboardKegiatanState {
  final String message;

  const DashboardKegiatanError(this.message);

  @override
  List<Object> get props => [message];
}
