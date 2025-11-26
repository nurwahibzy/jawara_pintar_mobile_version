import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_dashboard_summary_usecase.dart';
import '../../domain/usecases/get_available_years_usecase.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

/// BLoC untuk Dashboard Keuangan
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetDashboardSummaryUseCase getDashboardSummaryUseCase;
  final GetAvailableYearsUseCase getAvailableYearsUseCase;

  DashboardBloc({
    required this.getDashboardSummaryUseCase,
    required this.getAvailableYearsUseCase,
  }) : super(DashboardInitial()) {
    on<LoadDashboardSummaryEvent>(_onLoadDashboardSummary);
    on<ChangeYearEvent>(_onChangeYear);
    on<LoadAvailableYearsEvent>(_onLoadAvailableYears);
  }

  /// Handler untuk load dashboard summary
  Future<void> _onLoadDashboardSummary(
    LoadDashboardSummaryEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardLoading());

    // Load dashboard summary dan available years secara parallel
    final summaryResult = await getDashboardSummaryUseCase(event.year);
    final yearsResult = await getAvailableYearsUseCase();

    summaryResult.fold(
      (failure) => emit(DashboardError(failure.message)),
      (summary) {
        yearsResult.fold(
          (failure) => emit(DashboardError(failure.message)),
          (years) => emit(DashboardLoaded(
            summary: summary,
            availableYears: years,
          )),
        );
      },
    );
  }

  /// Handler untuk change year
  Future<void> _onChangeYear(
    ChangeYearEvent event,
    Emitter<DashboardState> emit,
  ) async {
    // Jika state saat ini loaded, tetap tampilkan data lama sambil loading
    if (state is DashboardLoaded) {
      final currentState = state as DashboardLoaded;
      emit(DashboardLoading());
      
      final result = await getDashboardSummaryUseCase(event.year);
      
      result.fold(
        (failure) => emit(DashboardError(failure.message)),
        (summary) => emit(currentState.copyWith(summary: summary)),
      );
    } else {
      // Jika belum ada data, load dari awal
      add(LoadDashboardSummaryEvent(event.year));
    }
  }

  /// Handler untuk load available years
  Future<void> _onLoadAvailableYears(
    LoadAvailableYearsEvent event,
    Emitter<DashboardState> emit,
  ) async {
    if (state is DashboardLoaded) {
      final currentState = state as DashboardLoaded;
      
      final result = await getAvailableYearsUseCase();
      
      result.fold(
        (failure) {
          // Jika gagal, tetap keep state yang ada
        },
        (years) => emit(currentState.copyWith(availableYears: years)),
      );
    }
  }
}
