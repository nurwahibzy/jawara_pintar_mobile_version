import 'package:equatable/equatable.dart';
import '../../domain/entities/kependudukan_entity.dart';

/// Base class untuk Dashboard Kependudukan States
abstract class DashboardKependudukanState extends Equatable {
  const DashboardKependudukanState();

  @override
  List<Object> get props => [];
}

/// Initial state
class DashboardKependudukanInitial extends DashboardKependudukanState {}

/// Loading state
class DashboardKependudukanLoading extends DashboardKependudukanState {}

/// Loaded state dengan data
class DashboardKependudukanLoaded extends DashboardKependudukanState {
  final DashboardKependudukanEntity dashboard;

  const DashboardKependudukanLoaded({required this.dashboard});

  @override
  List<Object> get props => [dashboard];
}

/// Error state
class DashboardKependudukanError extends DashboardKependudukanState {
  final String message;

  const DashboardKependudukanError(this.message);

  @override
  List<Object> get props => [message];
}
