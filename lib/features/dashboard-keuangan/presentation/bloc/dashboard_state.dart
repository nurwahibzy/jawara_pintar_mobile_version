import 'package:equatable/equatable.dart';
import '../../domain/entities/keuangan_entity.dart';

/// Base class untuk Dashboard States
abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object> get props => [];
}

/// Initial state
class DashboardInitial extends DashboardState {}

/// Loading state
class DashboardLoading extends DashboardState {}

/// Loaded state dengan data
class DashboardLoaded extends DashboardState {
  final DashboardSummaryEntity summary;
  final List<String> availableYears;

  const DashboardLoaded({
    required this.summary,
    required this.availableYears,
  });

  @override
  List<Object> get props => [summary, availableYears];

  /// Copy with untuk state update
  DashboardLoaded copyWith({
    DashboardSummaryEntity? summary,
    List<String>? availableYears,
  }) {
    return DashboardLoaded(
      summary: summary ?? this.summary,
      availableYears: availableYears ?? this.availableYears,
    );
  }
}

/// Error state
class DashboardError extends DashboardState {
  final String message;

  const DashboardError(this.message);

  @override
  List<Object> get props => [message];
}
