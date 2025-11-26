import 'package:supabase_flutter/supabase_flutter.dart';

// Import domain layer - Dashboard Keuangan
import '../../features/dashboard-keuangan/domain/repositories/dashboard_repository.dart';
import '../../features/dashboard-keuangan/domain/usecases/get_dashboard_summary_usecase.dart';
import '../../features/dashboard-keuangan/domain/usecases/get_available_years_usecase.dart';

// Import data layer - Dashboard Keuangan
import '../../features/dashboard-keuangan/data/repositories/dashboard_repository_impl.dart';
import '../../features/dashboard-keuangan/data/datasources/dashboard_remote_datasource.dart';

// Import domain layer - Dashboard Kegiatan
import '../../features/dashboard-kegiatan/domain/repositories/dashboard_repository.dart';
import '../../features/dashboard-kegiatan/domain/usecases/get_dashboard_kegiatan_usecase.dart';

// Import data layer - Dashboard Kegiatan
import '../../features/dashboard-kegiatan/data/repositories/dashboard_repository_impl.dart';
import '../../features/dashboard-kegiatan/data/datasources/dashboard_remote_datasource.dart';

// Import core
import '../network/network_info.dart';

/// Simple Service Locator (tanpa get_it)
class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();
  factory ServiceLocator() => _instance;
  ServiceLocator._internal();

  final Map<Type, dynamic> _services = {};

  void register<T>(T service) {
    _services[T] = service;
  }

  T get<T>() {
    final service = _services[T];
    if (service == null) {
      throw Exception('Service of type $T not registered');
    }
    return service as T;
  }

  void clear() {
    _services.clear();
  }
}

final sl = ServiceLocator();

/// Initialize dependency injection
Future<void> init() async {
  //! Core
  final networkInfo = NetworkInfoImpl();
  sl.register<NetworkInfo>(networkInfo);

  //! External - Supabase Client
  final supabaseClient = Supabase.instance.client;

  //! Features - Dashboard Keuangan
  
  // Data sources
  final dashboardKeuanganRemoteDataSource = DashboardRemoteDataSourceImpl(
    supabaseClient: supabaseClient,
  );
  sl.register<DashboardRemoteDataSource>(dashboardKeuanganRemoteDataSource);

  // Repository
  final dashboardKeuanganRepository = DashboardKeuanganRepositoryImpl(
    remoteDataSource: dashboardKeuanganRemoteDataSource,
  );
  sl.register<DashboardKeuanganRepository>(dashboardKeuanganRepository);

  // Use cases
  final getDashboardSummaryUseCase = GetDashboardSummaryUseCase(dashboardKeuanganRepository);
  sl.register<GetDashboardSummaryUseCase>(getDashboardSummaryUseCase);
  
  final getAvailableYearsUseCase = GetAvailableYearsUseCase(dashboardKeuanganRepository);
  sl.register<GetAvailableYearsUseCase>(getAvailableYearsUseCase);

  //! Features - Dashboard Kegiatan
  
  // Data sources
  final dashboardKegiatanRemoteDataSource = DashboardKegiatanRemoteDataSourceImpl(
    supabaseClient: supabaseClient,
  );
  sl.register<DashboardKegiatanRemoteDataSource>(dashboardKegiatanRemoteDataSource);

  // Repository
  final dashboardKegiatanRepository = DashboardKegiatanRepositoryImpl(
    remoteDataSource: dashboardKegiatanRemoteDataSource,
  );
  sl.register<DashboardKegiatanRepository>(dashboardKegiatanRepository);

  // Use cases
  final getDashboardKegiatanUseCase = GetDashboardKegiatanUseCase(dashboardKegiatanRepository);
  sl.register<GetDashboardKegiatanUseCase>(getDashboardKegiatanUseCase);
}
