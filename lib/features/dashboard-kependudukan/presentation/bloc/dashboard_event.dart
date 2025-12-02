import 'package:equatable/equatable.dart';

/// Base class untuk Dashboard Kependudukan Events
abstract class DashboardKependudukanEvent extends Equatable {
  const DashboardKependudukanEvent();

  @override
  List<Object> get props => [];
}

/// Event untuk load dashboard kependudukan
class LoadDashboardKependudukanEvent extends DashboardKependudukanEvent {
  const LoadDashboardKependudukanEvent();
}

/// Event untuk refresh dashboard
class RefreshDashboardKependudukanEvent extends DashboardKependudukanEvent {
  const RefreshDashboardKependudukanEvent();
}
