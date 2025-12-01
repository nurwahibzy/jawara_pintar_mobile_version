import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_dashboard_kependudukan_usecase.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

/// BLoC untuk Dashboard Kependudukan
class DashboardKependudukanBloc
    extends Bloc<DashboardKependudukanEvent, DashboardKependudukanState> {
  final GetDashboardKependudukanUseCase getDashboardKependudukanUseCase;

  DashboardKependudukanBloc({
    required this.getDashboardKependudukanUseCase,
  }) : super(DashboardKependudukanInitial()) {
    on<LoadDashboardKependudukanEvent>(_onLoadDashboard);
    on<RefreshDashboardKependudukanEvent>(_onRefreshDashboard);
  }

  /// Handler untuk load dashboard
  Future<void> _onLoadDashboard(
    LoadDashboardKependudukanEvent event,
    Emitter<DashboardKependudukanState> emit,
  ) async {
    emit(DashboardKependudukanLoading());

    final result = await getDashboardKependudukanUseCase();

    result.fold(
      (failure) => emit(DashboardKependudukanError(failure.message)),
      (dashboard) => emit(DashboardKependudukanLoaded(dashboard: dashboard)),
    );
  }

  /// Handler untuk refresh dashboard
  Future<void> _onRefreshDashboard(
    RefreshDashboardKependudukanEvent event,
    Emitter<DashboardKependudukanState> emit,
  ) async {
    // Refresh tanpa loading indicator
    final result = await getDashboardKependudukanUseCase();

    result.fold(
      (failure) => emit(DashboardKependudukanError(failure.message)),
      (dashboard) => emit(DashboardKependudukanLoaded(dashboard: dashboard)),
    );
  }
}
