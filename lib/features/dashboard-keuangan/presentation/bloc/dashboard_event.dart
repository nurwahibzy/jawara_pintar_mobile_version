import 'package:equatable/equatable.dart';

/// Base class untuk Dashboard Events
abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object> get props => [];
}

/// Event untuk load dashboard summary
class LoadDashboardSummaryEvent extends DashboardEvent {
  final String year;

  const LoadDashboardSummaryEvent(this.year);

  @override
  List<Object> get props => [year];
}

/// Event untuk change year
class ChangeYearEvent extends DashboardEvent {
  final String year;

  const ChangeYearEvent(this.year);

  @override
  List<Object> get props => [year];
}

/// Event untuk load available years
class LoadAvailableYearsEvent extends DashboardEvent {
  const LoadAvailableYearsEvent();
}
