import 'package:get_it/get_it.dart';
import 'package:jawara_pintar_mobile_version/features/rumah/presentation/bloc/rumah_bloc.dart';
import 'package:jawara_pintar_mobile_version/features/log-aktivitas/data/datasources/log_aktivitas_datasource.dart';
import 'package:jawara_pintar_mobile_version/features/log-aktivitas/data/repositories/log_aktivitas_repository_implementation.dart';
import 'package:jawara_pintar_mobile_version/features/log-aktivitas/domain/repositories/log_aktivitas_repository.dart';
import 'package:jawara_pintar_mobile_version/features/log-aktivitas/domain/usecases/get_all_log_aktivitas.dart';
import 'package:jawara_pintar_mobile_version/features/log-aktivitas/presentation/bloc/log_aktivitas_bloc.dart';
import 'package:jawara_pintar_mobile_version/features/warga/presentation/bloc/warga_bloc.dart';
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

// PESAN WARGA
import '../../features/pesan-warga/data/datasources/pesan_warga_remote.dart';
import '../../features/pesan-warga/data/repositories/pesan_warga_impl.dart';
import '../../features/pesan-warga/domain/repositories/pesan_warga_repository.dart';
import '../../features/pesan-warga/presentation/bloc/pesan_warga_bloc.dart';
import '../../features/pesan-warga/domain/usecases/create_pesan_warga.dart';
import '../../features/pesan-warga/domain/usecases/get_all_pesan_warga.dart';
import '../../features/pesan-warga/domain/usecases/get_pesan_warga.dart';
import '../../features/pesan-warga/domain/usecases/update_pesan_warga.dart';
import '../../features/pesan-warga/domain/usecases/delete_pesan_warga.dart';

// Mutasi Keluarga
import '../../features/mutasi-keluarga/data/datasources/mutasi_keluarga_datasource.dart';
import '../../features/mutasi-keluarga/data/repositories/mutasi_keluarga_repository_implementation.dart';
import '../../features/mutasi-keluarga/domain/repositories/mutasi_keluarga_repository.dart';
import '../../features/mutasi-keluarga/domain/usecases/create_mutasi_keluarga.dart';
import '../../features/mutasi-keluarga/domain/usecases/get_all_mutasi_keluarga.dart';
import '../../features/mutasi-keluarga/domain/usecases/get_form_data_options.dart';
import '../../features/mutasi-keluarga/domain/usecases/get_mutasi_keluarga.dart';
import '../../features/mutasi-keluarga/presentation/bloc/mutasi_keluarga_bloc.dart';

// WARGA
import '../../features/warga/data/datasources/warga_remote_datasource.dart';
import '../../features/warga/data/repositories/warga_repository_impl.dart';
import '../../features/warga/domain/repositories/warga_repository.dart';

import '../../features/warga/domain/usecases/create_warga.dart';
import '../../features/warga/domain/usecases/filter_warga.dart';
import '../../features/warga/domain/usecases/get_all_warga.dart';
import '../../features/warga/domain/usecases/get_warga.dart';
import '../../features/warga/domain/usecases/update_warga.dart';

// LAPORAN KEUANGAN
import '../../features/laporan-keuangan/domain/repositories/laporan_repository.dart';
import '../../features/laporan-keuangan/domain/usecases/get_all_pemasukan_usecase.dart';
import '../../features/laporan-keuangan/domain/usecases/get_all_pengeluaran_usecase.dart';
import '../../features/laporan-keuangan/domain/usecases/get_laporan_summary_usecase.dart';
import '../../features/laporan-keuangan/domain/usecases/generate_pdf_laporan_usecase.dart';
import '../../features/laporan-keuangan/data/repositories/laporan_repository_impl.dart';
import '../../features/laporan-keuangan/data/datasources/laporan_remote_data_source.dart';
import '../../features/laporan-keuangan/presentation/bloc/laporan_keuangan_bloc.dart';

// CETAK LAPORAN
import '../../features/cetak-laporan/domain/repositories/cetak_laporan_repository.dart';
import '../../features/cetak-laporan/domain/usecases/get_laporan_data_usecase.dart';
import '../../features/cetak-laporan/domain/usecases/generate_pdf_usecase.dart';
import '../../features/cetak-laporan/domain/usecases/share_pdf_usecase.dart';
import '../../features/cetak-laporan/data/repositories/cetak_laporan_repository_impl.dart';
import '../../features/cetak-laporan/data/datasources/cetak_laporan_remote_datasource.dart';
import '../../features/cetak-laporan/presentation/bloc/cetak_laporan_bloc.dart';

// RUMAH
import '../../features/rumah/data/datasources/rumah_remote_datasource.dart';
import '../../features/rumah/data/repositories/rumah_repository_impl.dart';
import '../../features/rumah/domain/repositories/rumah_repository.dart';

import '../../features/rumah/domain/usecases/create_rumah.dart';
import '../../features/rumah/domain/usecases/delete_rumah.dart';
import '../../features/rumah/domain/usecases/filter_rumah.dart';
import '../../features/rumah/domain/usecases/get_all_rumah.dart';
import '../../features/rumah/domain/usecases/get_rumah_detail.dart';
import '../../features/rumah/domain/usecases/update_rumah.dart';

// MASTER IURAN
import '../../features/kategori-tagihan/data/datasources/master_iuran_remote_datasource.dart';
import '../../features/kategori-tagihan/data/repositories/master_iuran_repository_impl.dart';
import '../../features/kategori-tagihan/domain/repositories/master_iuran_repository.dart';
import '../../features/kategori-tagihan/domain/usecases/get_master_iuran_list.dart';
import '../../features/kategori-tagihan/domain/usecases/get_master_iuran_by_id.dart';
import '../../features/kategori-tagihan/domain/usecases/create_master_iuran.dart';
import '../../features/kategori-tagihan/domain/usecases/update_master_iuran.dart';
import '../../features/kategori-tagihan/domain/usecases/delete_master_iuran.dart';
import '../../features/kategori-tagihan/domain/usecases/get_master_iuran_by_kategori.dart';
import '../../features/kategori-tagihan/presentation/bloc/master_iuran_bloc.dart';

// CHANNEL TRANSFER
import '../../features/channel-transfer/data/datasources/channel_transfer_datasource.dart';
import '../../features/channel-transfer/data/repositories/channel_transfer_impl.dart';
import '../../features/channel-transfer/domain/repositories/channel_transfer_repository.dart';
import '../../features/channel-transfer/domain/usecases/get_all_channel_transfer.dart';
import '../../features/channel-transfer/domain/usecases/get_channel_transfer.dart';
import '../../features/channel-transfer/domain/usecases/create_channel_transfer.dart';
import '../../features/channel-transfer/domain/usecases/update_channel_transfer.dart';
import '../../features/channel-transfer/domain/usecases/delete_channel_transfer.dart';
import '../../features/channel-transfer/presentation/bloc/channel_transfer_bloc.dart';

// TAGIH IURAN
import '../../features/tagih-iuran/data/datasources/tagih_iuran_remote_datasource.dart';
import '../../features/tagih-iuran/data/repositories/tagih_iuran_repository_impl.dart';
import '../../features/tagih-iuran/domain/repositories/tagih_iuran_repository.dart';
import '../../features/tagih-iuran/domain/usecases/get_master_iuran_dropdown.dart';
import '../../features/tagih-iuran/domain/usecases/create_tagih_iuran.dart';
import '../../features/tagih-iuran/presentation/bloc/tagih_iuran_bloc.dart';

// TAGIHAN PEMBAYARAN
import '../../features/tagihan/data/datasources/tagihan_remote_datasource.dart';
import '../../features/tagihan/data/repositories/tagihan_repository_impl.dart';
import '../../features/tagihan/domain/repositories/tagihan_repository.dart';
import '../../features/tagihan/domain/usecases/get_tagihan_pembayaran_list.dart';
import '../../features/tagihan/domain/usecases/get_tagihan_pembayaran_detail.dart';
import '../../features/tagihan/domain/usecases/approve_tagihan_pembayaran.dart';
import '../../features/tagihan/domain/usecases/reject_tagihan_pembayaran.dart';
import '../../features/tagihan/presentation/bloc/tagihan_bloc.dart';

// PEMASUKAN
import '../../features/pemasukan/data/datasources/pemasukan_remote_datasource.dart';
import '../../features/pemasukan/data/repositories/pemasukan_repository_impl.dart';
import '../../features/pemasukan/domain/repositories/pemasukan_repository.dart';
import '../../features/pemasukan/domain/usecases/get_pemasukan_list.dart';
import '../../features/pemasukan/domain/usecases/get_pemasukan_detail.dart';
import '../../features/pemasukan/domain/usecases/create_pemasukan.dart';
import '../../features/pemasukan/domain/usecases/update_pemasukan.dart';
import '../../features/pemasukan/domain/usecases/delete_pemasukan.dart';
import '../../features/pemasukan/presentation/bloc/pemasukan_bloc.dart';

// Manajemen Pengguna
import 'package:jawara_pintar_mobile_version/manajemen-pengguna/data/datasources/users_datasource.dart';
import 'package:jawara_pintar_mobile_version/manajemen-pengguna/data/repositories/users_repository_implementation.dart';
import 'package:jawara_pintar_mobile_version/manajemen-pengguna/domain/repositories/users_repository.dart';
import 'package:jawara_pintar_mobile_version/manajemen-pengguna/domain/usecases/create_user.dart';
import 'package:jawara_pintar_mobile_version/manajemen-pengguna/domain/usecases/delete_user.dart';
import 'package:jawara_pintar_mobile_version/manajemen-pengguna/domain/usecases/get_all_users.dart';
import 'package:jawara_pintar_mobile_version/manajemen-pengguna/domain/usecases/get_user.dart';
import 'package:jawara_pintar_mobile_version/manajemen-pengguna/domain/usecases/update_user.dart';
import 'package:jawara_pintar_mobile_version/manajemen-pengguna/presentation/bloc/users_bloc.dart';

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
    () => DashboardKependudukanRemoteDataSourceImpl(
      supabaseClient: supabaseClient,
    ),
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

  // --------------------------------------------------------------------------
  // PESAN WARGA
  // --------------------------------------------------------------------------
  sl.registerLazySingleton<AspirasiRemoteDataSource>(
    () => AspirasiRemoteDataSourceImpl(),
  );

  sl.registerLazySingleton<AspirasiRepository>(
    () => AspirasiRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton(() => GetAllAspirasi(sl<AspirasiRepository>()));
  sl.registerLazySingleton(
    () => GetAspirasiByIdUseCase(sl<AspirasiRepository>()),
  );
  sl.registerLazySingleton(() => AddAspirasiUseCase(sl<AspirasiRepository>()));
  sl.registerLazySingleton(
    () => UpdateAspirasiUseCase(sl<AspirasiRepository>()),
  );
  sl.registerLazySingleton(
    () => DeleteAspirasiUseCase(sl<AspirasiRepository>()),
  );

  sl.registerFactory(() => AspirasiBloc(repository: sl<AspirasiRepository>()));

  // --------------------------------------------------------------------------
  // MUTASI KELUARGA
  // --------------------------------------------------------------------------

  // datasource
  sl.registerLazySingleton<MutasiKeluargaDatasource>(
    () => MutasiKeluargaDatasourceImplementation(),
  );

  // repository
  sl.registerLazySingleton<MutasiKeluargaRepository>(
    () => MutasiKeluargaRepositoryImplementation(datasource: sl()),
  );

  // Usecases
  sl.registerLazySingleton(() => GetAllMutasiKeluarga(sl()));
  sl.registerLazySingleton(() => GetMutasiKeluarga(sl()));
  sl.registerLazySingleton(() => CreateMutasiKeluarga(sl()));
  sl.registerLazySingleton(() => GetFormDataOptions(sl()));

  // bloc
  sl.registerFactory(
    () => MutasiKeluargaBloc(
      getAllMutasiKeluarga: sl(),
      getMutasiKeluarga: sl(),
      createMutasiKeluarga: sl(),
      getFormDataOptions: sl(),
    ),
  );

  // --------------------------------------------------------------------------
  // LOG AKTIVITAS
  // --------------------------------------------------------------------------

  // datasource
  sl.registerLazySingleton<LogAktivitasDatasource>(
    () => LogAktivitasDatasourceImplementation(),
  );

  // repository
  sl.registerLazySingleton<LogAktivitasRepository>(
    () => LogAktivitasRepositoryImplementation(datasource: sl()),
  );

  // Usecases
  sl.registerLazySingleton(() => GetAllLogAktivitas(sl()));

  // bloc
  sl.registerFactory(() => LogAktivitasBloc(getAllLogAktivitas: sl()));

  // --------------------------------------------------------------------------
  // WARGA & KELUARGA
  // --------------------------------------------------------------------------
  sl.registerLazySingleton<WargaRemoteDataSource>(
    () => WargaRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<WargaRepository>(() => WargaRepositoryImpl(sl()));

  sl.registerLazySingleton(() => CreateWarga(sl()));
  sl.registerLazySingleton(() => FilterWarga(sl()));
  sl.registerLazySingleton(() => GetWarga(sl()));
  sl.registerLazySingleton(() => GetAllWarga(sl()));
  sl.registerLazySingleton(() => UpdateWarga(sl()));

  sl.registerFactory(() => WargaBloc(repository: sl<WargaRepository>()));

  // --------------------------------------------------------------------------
  // LAPORAN KEUANGAN
  // --------------------------------------------------------------------------
  sl.registerLazySingleton<LaporanRemoteDataSource>(
    () => LaporanRemoteDataSourceImpl(supabaseClient: supabaseClient),
  );

  sl.registerLazySingleton<LaporanRepository>(
    () => LaporanRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton(() => GetAllPemasukanUseCase(sl()));
  sl.registerLazySingleton(() => GetAllPengeluaranUseCase(sl()));
  sl.registerLazySingleton(() => GetLaporanSummaryUseCase(sl()));
  sl.registerLazySingleton(() => GeneratePdfLaporanUseCase(sl()));

  sl.registerFactory(
    () => LaporanKeuanganBloc(
      getAllPemasukanUseCase: sl(),
      getAllPengeluaranUseCase: sl(),
      getLaporanSummaryUseCase: sl(),
      generatePdfLaporanUseCase: sl(),
    ),
  );

  // --------------------------------------------------------------------------
  // CETAK LAPORAN
  // --------------------------------------------------------------------------
  sl.registerLazySingleton<CetakLaporanRemoteDataSource>(
    () => CetakLaporanRemoteDataSourceImpl(supabaseClient: supabaseClient),
  );

  sl.registerLazySingleton<CetakLaporanRepository>(
    () => CetakLaporanRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton(() => GetLaporanDataUseCase(sl()));
  sl.registerLazySingleton(() => GeneratePdfUseCase(sl()));
  sl.registerLazySingleton(() => SharePdfUseCase(sl()));

  sl.registerFactory(
    () => CetakLaporanBloc(
      getLaporanDataUseCase: sl(),
      generatePdfUseCase: sl(),
      sharePdfUseCase: sl(),
    ),
  );

  // --------------------------------------------------------------------------
  // RUMAH
  // --------------------------------------------------------------------------
  sl.registerLazySingleton<RumahRemoteDataSource>(
    () => RumahRemoteDataSourceImpl(supabaseClient: supabaseClient),
  );
  sl.registerLazySingleton<RumahRepository>(
    () => RumahRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton(() => CreateRumah(sl()));
  sl.registerLazySingleton(() => DeleteRumah(sl()));
  sl.registerLazySingleton(() => FilterRumah(sl()));
  sl.registerLazySingleton(() => GetAllRumah(sl()));
  sl.registerLazySingleton(() => GetRumahDetail(sl()));
  sl.registerLazySingleton(() => UpdateRumah(sl()));

  sl.registerFactory(() => RumahBloc(repository: sl<RumahRepository>()));

  // --------------------------------------------------------------------------
  // MASTER IURAN
  // --------------------------------------------------------------------------
  sl.registerLazySingleton<MasterIuranRemoteDataSource>(
    () => MasterIuranRemoteDataSourceImpl(supabaseClient: supabaseClient),
  );

  sl.registerLazySingleton<MasterIuranRepository>(
    () => MasterIuranRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton(() => GetMasterIuranList(sl()));
  sl.registerLazySingleton(() => GetMasterIuranById(sl()));
  sl.registerLazySingleton(() => CreateMasterIuran(sl()));
  sl.registerLazySingleton(() => UpdateMasterIuran(sl()));
  sl.registerLazySingleton(() => DeleteMasterIuran(sl()));
  sl.registerLazySingleton(() => GetMasterIuranByKategori(sl()));

  sl.registerFactory(
    () => MasterIuranBloc(
      getMasterIuranList: sl(),
      getMasterIuranById: sl(),
      createMasterIuran: sl(),
      updateMasterIuran: sl(),
      deleteMasterIuran: sl(),
      getMasterIuranByKategori: sl(),
    ),
  );

  // --------------------------------------------------------------------------
  // CHANNEL TRANSFER
  // --------------------------------------------------------------------------

  sl.registerLazySingleton<TransferChannelRemoteDataSource>(
    () => TransferChannelRemoteDataSourceImpl(),
  );

  sl.registerLazySingleton<TransferChannelRepository>(
    () => TransferChannelRepositoryImpl(sl<TransferChannelRemoteDataSource>()),
  );

  sl.registerLazySingleton(() => GetAllTransferChannels(sl()));
  sl.registerLazySingleton(() => GetTransferChannelById(sl()));
  sl.registerLazySingleton(() => CreateTransferChannel(sl()));
  sl.registerLazySingleton(() => UpdateTransferChannel(sl()));
  sl.registerLazySingleton(() => DeleteTransferChannel(sl()));

  sl.registerFactory(
    () => TransferChannelBloc(repository: sl<TransferChannelRepository>()),
  );

  // --------------------------------------------------------------------------
  // TAGIH IURAN
  // --------------------------------------------------------------------------
  sl.registerLazySingleton<TagihIuranRemoteDataSource>(
    () => TagihIuranRemoteDataSourceImpl(supabaseClient: supabaseClient),
  );

  sl.registerLazySingleton<TagihIuranRepository>(
    () => TagihIuranRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton(() => GetMasterIuranDropdown(sl()));
  sl.registerLazySingleton(() => CreateTagihIuran(sl()));

  sl.registerFactory(
    () => TagihIuranBloc(getMasterIuranDropdown: sl(), createTagihIuran: sl()),
  );

  // --------------------------------------------------------------------------
  // TAGIHAN PEMBAYARAN
  // --------------------------------------------------------------------------
  sl.registerLazySingleton<TagihanRemoteDataSource>(
    () => TagihanRemoteDataSourceImpl(supabaseClient: supabaseClient),
  );

  sl.registerLazySingleton<TagihanRepository>(
    () => TagihanRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton(() => GetTagihanPembayaranList(sl()));
  sl.registerLazySingleton(() => GetTagihanPembayaranDetail(sl()));
  sl.registerLazySingleton(() => ApproveTagihanPembayaran(sl()));
  sl.registerLazySingleton(() => RejectTagihanPembayaran(sl()));

  sl.registerFactory(
    () => TagihanBloc(
      getTagihanPembayaranList: sl(),
      getTagihanPembayaranDetail: sl(),
      approveTagihanPembayaran: sl(),
      rejectTagihanPembayaran: sl(),
    ),
  );

  // PEMASUKAN
  sl.registerLazySingleton<PemasukanRemoteDataSource>(
    () => PemasukanRemoteDataSourceImpl(supabaseClient: supabaseClient),
  );

  sl.registerLazySingleton<PemasukanRepository>(
    () => PemasukanRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton(() => GetPemasukanList(sl()));
  sl.registerLazySingleton(() => GetPemasukanDetail(sl()));
  sl.registerLazySingleton(() => CreatePemasukan(sl()));
  sl.registerLazySingleton(() => UpdatePemasukan(sl()));
  sl.registerLazySingleton(() => DeletePemasukan(sl()));

  sl.registerFactory(
    () => PemasukanBloc(
      getPemasukanList: sl(),
      getPemasukanDetail: sl(),
      createPemasukan: sl(),
      updatePemasukan: sl(),
      deletePemasukan: sl(),
      repository: sl(),
    ),
  );

  // --------------------------------------------------------------------------
  // Manajemen Pengguna
  // --------------------------------------------------------------------------
  sl.registerLazySingleton<UsersDataSource>(
    () => UsersDataSourceImplementation(),
  );

  sl.registerLazySingleton<UsersRepository>(
    () => UsersRepositoryImplementation(sl(), supabaseClient),
  );

  sl.registerLazySingleton(() => GetAllUsers(sl()));
  sl.registerLazySingleton(() => GetUserById(sl()));
  sl.registerLazySingleton(() => CreateUser(sl()));
  sl.registerLazySingleton(() => UpdateUser(sl()));
  sl.registerLazySingleton(() => DeleteUser(sl()));
  // sl.registerLazySingleton(() => DeleteUser(sl()));

  sl.registerFactory(() => UsersBloc(repository: sl<UsersRepository>()));
}
