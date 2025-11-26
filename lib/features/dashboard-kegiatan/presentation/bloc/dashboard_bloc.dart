import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_dashboard_kegiatan_usecase.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

/// BLoC untuk Dashboard Kegiatan
class DashboardKegiatanBloc extends Bloc<DashboardKegiatanEvent, DashboardKegiatanState> {
  final GetDashboardKegiatanUseCase getDashboardKegiatanUseCase;

  DashboardKegiatanBloc({
    required this.getDashboardKegiatanUseCase,
  }) : super(DashboardKegiatanInitial()) {
    on<LoadDashboardKegiatanEvent>(_onLoadDashboard);
    on<RefreshDashboardKegiatanEvent>(_onRefreshDashboard);
  }

  /// Handler untuk load dashboard
  Future<void> _onLoadDashboard(
    LoadDashboardKegiatanEvent event,
    Emitter<DashboardKegiatanState> emit,
  ) async {
    emit(DashboardKegiatanLoading());

    final result = await getDashboardKegiatanUseCase();

    result.fold(
      (failure) => emit(DashboardKegiatanError(failure.message)),
      (dashboard) => emit(DashboardKegiatanLoaded(dashboard: dashboard)),
    );
  }

  /// Handler untuk refresh dashboard
  Future<void> _onRefreshDashboard(
    RefreshDashboardKegiatanEvent event,
    Emitter<DashboardKegiatanState> emit,
  ) async {
    // Refresh tanpa loading indicator
    final result = await getDashboardKegiatanUseCase();

    result.fold(
      (failure) => emit(DashboardKegiatanError(failure.message)),
      (dashboard) => emit(DashboardKegiatanLoaded(dashboard: dashboard)),
    );
  }
}
