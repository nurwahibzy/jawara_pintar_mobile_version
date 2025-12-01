import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Core
import '../network/network_info.dart';

// DASHBOARD KEUANGAN
import '../../features/dashboard-keuangan/domain/repositories/dashboard_repository.dart';
import '../../features/dashboard-keuangan/domain/usecases/get_dashboard_summary_usecase.dart';
import '../../features/dashboard-keuangan/domain/usecases/get_available_years_usecase.dart';
import '../../features/dashboard-keuangan/data/repositories/dashboard_repository_impl.dart';
import '../../features/dashboard-keuangan/data/datasources/dashboard_remote_datasource.dart';

// DASHBOARD KEGIATAN
import '../../features/dashboard-kegiatan/domain/repositories/dashboard_repository.dart';
import '../../features/dashboard-kegiatan/domain/usecases/get_dashboard_kegiatan_usecase.dart';
import '../../features/dashboard-kegiatan/data/repositories/dashboard_repository_impl.dart';
import '../../features/dashboard-kegiatan/data/datasources/dashboard_remote_datasource.dart';

// DASHBOARD KEPENDUDUKAN
import '../../features/dashboard-kependudukan/domain/repositories/dashboard_repository.dart';
import '../../features/dashboard-kependudukan/domain/usecases/get_dashboard_kependudukan_usecase.dart';
import '../../features/dashboard-kependudukan/data/repositories/dashboard_repository_impl.dart';
import '../../features/dashboard-kependudukan/data/datasources/dashboard_remote_datasource.dart';

// PENGELUARAN
import '../../features/pengeluaran/data/datasources/remote_datasource.dart';
import '../../features/pengeluaran/data/repositories/pengeluaran_repository_implementation.dart';
import '../../features/pengeluaran/domain/repositories/pengeluaran_repository.dart';

import '../../features/pengeluaran/domain/usecases/create_pengeluaran.dart';
import '../../features/pengeluaran/domain/usecases/delete_pengeluaran.dart';
import '../../features/pengeluaran/domain/usecases/get_all_pengeluaran.dart';
import '../../features/pengeluaran/domain/usecases/get_pengeluaran.dart';
import '../../features/pengeluaran/domain/usecases/update_pengeluaran.dart';

import '../../features/pengeluaran/presentation/bloc/pengeluaran_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());

  //! External - Supabase
  final supabaseClient = Supabase.instance.client;

  // --------------------------------------------------------------------------
  // DASHBOARD KEUANGAN
  // --------------------------------------------------------------------------
  sl.registerLazySingleton<DashboardRemoteDataSource>(
    () => DashboardRemoteDataSourceImpl(supabaseClient: supabaseClient),
  );

  sl.registerLazySingleton<DashboardKeuanganRepository>(
    () => DashboardKeuanganRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton(() => GetDashboardSummaryUseCase(sl()));
  sl.registerLazySingleton(() => GetAvailableYearsUseCase(sl()));

  // --------------------------------------------------------------------------
  // DASHBOARD KEGIATAN
  // --------------------------------------------------------------------------
  sl.registerLazySingleton<DashboardKegiatanRemoteDataSource>(
    () => DashboardKegiatanRemoteDataSourceImpl(supabaseClient: supabaseClient),
  );

  sl.registerLazySingleton<DashboardKegiatanRepository>(
    () => DashboardKegiatanRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton(() => GetDashboardKegiatanUseCase(sl()));

  // --------------------------------------------------------------------------
  // DASHBOARD KEPENDUDUKAN
  // --------------------------------------------------------------------------
  sl.registerLazySingleton<DashboardKependudukanRemoteDataSource>(
    () => DashboardKependudukanRemoteDataSourceImpl(supabaseClient: supabaseClient),
  );

  sl.registerLazySingleton<DashboardKependudukanRepository>(
    () => DashboardKependudukanRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton(() => GetDashboardKependudukanUseCase(sl()));

  // --------------------------------------------------------------------------
  // PENGELUARAN
  // --------------------------------------------------------------------------
  sl.registerLazySingleton<PengeluaranRemoteDataSource>(
    () => PengeluaranRemoteDataSourceImpl(),
  );

  sl.registerLazySingleton<PengeluaranRepository>(
    () => PengeluaranRepositoryImpl(sl()),
  );

  sl.registerLazySingleton(() => GetPengeluaranList(sl()));
  sl.registerLazySingleton(() => GetPengeluaranById(sl()));
  sl.registerLazySingleton(() => CreatePengeluaran(sl()));
  sl.registerLazySingleton(() => UpdatePengeluaran(sl()));
  sl.registerLazySingleton(() => DeletePengeluaran(sl()));

  sl.registerFactory(
    () => PengeluaranBloc(repository: sl<PengeluaranRepository>()),
  );
}