import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jawara_pintar_mobile_version/core/auth/register_page.dart';
import 'package:jawara_pintar_mobile_version/features/broad_cast/presentation/blocs/broadcast_bloc.dart';
import 'package:jawara_pintar_mobile_version/features/broad_cast/presentation/pages/broad_cast_page.dart';
import 'package:jawara_pintar_mobile_version/features/channel-transfer/domain/repositories/channel_transfer_repository.dart';
import 'package:jawara_pintar_mobile_version/features/channel-transfer/presentation/bloc/channel_transfer_event.dart';
import 'package:jawara_pintar_mobile_version/features/kategori-tagihan/presentation/bloc/master_iuran_bloc.dart';
import 'package:jawara_pintar_mobile_version/features/kategori-tagihan/presentation/bloc/master_iuran_event.dart';
import 'package:jawara_pintar_mobile_version/features/kategori-tagihan/presentation/pages/daftar_kategori_tagihan.dart';
import 'package:jawara_pintar_mobile_version/features/tagih-iuran/presentation/bloc/tagih_iuran_bloc.dart';
import 'package:jawara_pintar_mobile_version/features/tagih-iuran/presentation/pages/tambah_tagih_iuran_page.dart';
import 'package:jawara_pintar_mobile_version/features/warga/presentation/bloc/warga_bloc.dart';
import 'package:jawara_pintar_mobile_version/features/warga/presentation/pages/daftar_keluarga.dart';
import 'package:jawara_pintar_mobile_version/features/warga/presentation/pages/daftar_warga.dart';
import 'package:jawara_pintar_mobile_version/features/profile/profil.dart';
import '../injections/injection.dart';
import '../../features/pengeluaran/domain/entities/pengeluaran.dart';
import '../../features/pengeluaran/presentation/bloc/pengeluaran_bloc.dart';
import '../../features/pengeluaran/presentation/bloc/pengeluaran_event.dart';
import 'app_routes.dart';
// import halaman yg dibutuhkan
// import 'package:jawara_pintar_mobile_version/pages/login/login_page.dart';
import 'package:jawara_pintar_mobile_version/core/auth/login_page.dart';
import 'package:jawara_pintar_mobile_version/features/dashboard-keuangan/presentation/pages/dashboard_keuangan_page.dart';
import 'package:jawara_pintar_mobile_version/features/dashboard-kegiatan/presentation/pages/dashboard_kegiatan_page.dart';
import 'package:jawara_pintar_mobile_version/features/dashboard-kependudukan/presentation/pages/dashboard_kependudukan_page.dart';
import 'package:jawara_pintar_mobile_version/features/pengeluaran/presentation/pages/daftar_pengeluaran.dart';
import 'package:jawara_pintar_mobile_version/features/pengeluaran/presentation/pages/tambah_pengeluaran.dart';
import 'package:jawara_pintar_mobile_version/features/pengeluaran/presentation/pages/edit_pengeluaran.dart';
import '../../features/pesan-warga/domain/entities/pesan_warga.dart';
import '../../features/pesan-warga/presentation/bloc/pesan_warga_bloc.dart';
import '../../features/pesan-warga/presentation/pages/daftar_pesan_warga.dart';
import '../../features/pesan-warga/presentation/pages/edit_pesan_warga.dart';
import '../../features/pesan-warga/presentation/pages/detail_pesan_warga.dart';
import '../../features/pesan-warga/presentation/pages/tambah_pesan_warga.dart';
// import '../../features/penerimaan-warga/presentation/pages/penerimaan_warga_page.dart';

import '../../features/mutasi-keluarga/presentation/bloc/mutasi_keluarga_bloc.dart';
import '../../features/mutasi-keluarga/presentation/pages/daftar_mutasi_keluarga.dart';
import '../../features/mutasi-keluarga/presentation/pages/tambah_mutasi_keluarga.dart';
import '../../features/rumah/presentation/pages/daftar_rumah.dart';
import '../../features/rumah/presentation/bloc/rumah_bloc.dart';

import '../../features/laporan-keuangan/presentation/bloc/laporan_keuangan_bloc.dart';
import '../../features/laporan-keuangan/presentation/pages/laporan_keuangan_main_page.dart';

import '../../features/cetak-laporan/presentation/bloc/cetak_laporan_bloc.dart';
import '../../features/cetak-laporan/presentation/pages/cetak_laporan_page.dart';

import '../../features/log-aktivitas/presentation/pages/daftar_log_aktivitas.dart';
import '../../features/log-aktivitas/presentation/bloc/log_aktivitas_bloc.dart';

import '../../features/channel-transfer/domain/entities/channel_transfer_entities.dart';
import '../../features/channel-transfer/presentation/bloc/channel_transfer_bloc.dart';
import '../../features/channel-transfer/presentation/pages/daftar_channel_transfer.dart';
import '../../features/channel-transfer/presentation/pages/tambah_channel_transfer.dart';
import '../../features/channel-transfer/presentation/pages/edit_channel_transfer.dart';
import '../../features/channel-transfer/presentation/pages/detail_channel_transfer.dart';

// import 'package:flutter/material.dart';
import '../../features/tagihan/presentation/bloc/tagihan_bloc.dart';
import '../../features/tagihan/presentation/pages/daftar_tagihan_pembayaran.dart';
import '../../features/tagihan/presentation/pages/detail_tagihan_pembayaran.dart';

import '../../features/pemasukan/presentation/bloc/pemasukan_bloc.dart';
import '../../features/pemasukan/presentation/pages/daftar_pemasukan_page.dart';
import '../../features/pemasukan/presentation/pages/detail_pemasukan_page.dart';
import '../../features/pemasukan/presentation/pages/form_pemasukan_page.dart';

import 'package:jawara_pintar_mobile_version/manajemen-pengguna/presentation/bloc/users_bloc.dart';
import 'package:jawara_pintar_mobile_version/manajemen-pengguna/presentation/bloc/users_event.dart';
import 'package:jawara_pintar_mobile_version/manajemen-pengguna/presentation/pages/daftar_users.dart';
import 'package:jawara_pintar_mobile_version/manajemen-pengguna/presentation/pages/tambah_users.dart';


class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginPage());

      case AppRoutes.profil:
        return MaterialPageRoute(builder: (_) => Profil());

      case AppRoutes.register:
        return MaterialPageRoute(builder: (_) => RegisterPage());

      //PENGELUARAN
      case AppRoutes.daftarPengeluaran:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => sl<PengeluaranBloc>()..add(const LoadPengeluaran()),
            child: const DaftarPengeluaran(),
          ),
        );

      case AppRoutes.tambahPengeluaran:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => sl<PengeluaranBloc>(),
            child: const TambahPengeluaranPage(),
          ),
        );

      case AppRoutes.editPengeluaran:
        final pengeluaran = settings.arguments as Pengeluaran;
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: BlocProvider.of<PengeluaranBloc>(context),
            child: EditPengeluaranPage(
              pengeluaran: pengeluaran,
              kategoriList: [],
            ),
          ),
        );

      // DASHBOARD
      case AppRoutes.dashboardKeuangan:
        return MaterialPageRoute(builder: (_) => const DashboardKeuanganPage());

      case AppRoutes.dashboardKegiatan:
        return MaterialPageRoute(builder: (_) => const DashboardKegiatanPage());

      case AppRoutes.kependudukan:
        return MaterialPageRoute(
          builder: (_) => const DashboardKependudukanPage(),
        );
      // PESAN WARGA
      case AppRoutes.daftarPesanWarga:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => sl<AspirasiBloc>()..add(LoadAspirasi()),
            child: const DaftarPesanWarga(),
          ),
        );

      case AppRoutes.tambahPesanWarga:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => sl<AspirasiBloc>(),
            child: const TambahPesanWarga(),
          ),
        );

      case AppRoutes.editPesanWarga:
        final pesan = args as Aspirasi;
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: BlocProvider.of<AspirasiBloc>(context),
            child: EditPesanWarga(pesan: pesan),
          ),
        );

      case AppRoutes.detailPesanWarga:
        final pesan = args as Aspirasi;
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: BlocProvider.of<AspirasiBloc>(context),
            child: DetailPesanWarga(pesan: pesan),
          ),
        );

      // MUTASI KELUARGA
      case AppRoutes.daftarMutasiKeluarga:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => sl<MutasiKeluargaBloc>(),
            child: const DaftarMutasiKeluarga(),
          ),
        );

      case AppRoutes.tambahMutasiKeluarga:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => sl<MutasiKeluargaBloc>(),
            child: const TambahMutasiKeluarga(),
          ),
        );

      case AppRoutes.logout:
        // Implement logout logic here if needed
        return MaterialPageRoute(builder: (_) => const LoginPage());

      case AppRoutes.daftarWarga:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => sl<WargaBloc>()..add(LoadWarga()),
            child: const DaftarWargaPage(),
          ),
        );

      case AppRoutes.daftarKeluarga:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => sl<WargaBloc>()..add(LoadAllKeluargaWithRelations()),
            child: const DaftarKeluargaPage(),
          ),
        );

      // LAPORAN KEUANGAN
      case AppRoutes.laporanKeuangan:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => sl<LaporanKeuanganBloc>(),
            child: const LaporanKeuanganMainPage(),
          ),
        );

      // CETAK LAPORAN
      case AppRoutes.cetakLaporan:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => sl<CetakLaporanBloc>(),
            child: const CetakLaporanPage(),
          ),
        );

      // DAFTAR RUMAH
      case AppRoutes.daftarRumah:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => sl<RumahBloc>()..add(LoadAllRumah()),
            child: const DaftarRumahPage(),
          ),
        );

      // DAFTR KATEGORI IURAN
      case AppRoutes.daftarKategoriIuran:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) =>
                sl<MasterIuranBloc>()..add(const LoadMasterIuranList()),
            child: const DaftarKategoriTagihanPage(),
          ),
        );

      // TAGIH IURAN
      case AppRoutes.tambahTagihIuran:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => sl<TagihIuranBloc>(),
            child: const TambahTagihIuranPage(),
          ),
        );

      case AppRoutes.daftarLogAktivitas:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => sl<LogAktivitasBloc>(),
            child: const DaftarLogAktivitas(),
          ),
        );

      // DAFTAR CHANNEL TRANSFER
      case AppRoutes.daftarChannelTransfer:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) =>
                TransferChannelBloc(repository: sl<TransferChannelRepository>())
                  ..add(LoadTransferChannels()),
            child: const DaftarTransferChannel(),
          ),
        );

      // TAMBAH CHANNEL TRANSFER
      case AppRoutes.tambahChannelTransfer:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => TransferChannelBloc(
              repository: sl<TransferChannelRepository>(),
            ),
            child: const TambahTransferChannelPage(),
          ),
        );

      case AppRoutes.editChannelTransfer:
        final channel = settings.arguments as TransferChannel;
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: BlocProvider.of<TransferChannelBloc>(context),
            child: EditTransferChannelPage(channel: channel),
          ),
        );

      case AppRoutes.detailChannelTransfer:
        final channel = settings.arguments as TransferChannel;
        return MaterialPageRoute(
          builder: (context) => DetailTransferChannelPage(channel: channel),
        );

      // TAGIHAN PEMBAYARAN
      case AppRoutes.daftarTagihanPembayaran:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) =>
                sl<TagihanBloc>()..add(const LoadTagihanPembayaranList()),
            child: const DaftarTagihanPembayaranPage(),
          ),
        );

      case AppRoutes.detailTagihanPembayaran:
        final tagihanId = settings.arguments as int;
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (_) =>
                sl<TagihanBloc>()..add(LoadTagihanPembayaranDetail(tagihanId)),
            child: DetailTagihanPembayaranPage(tagihanId: tagihanId),
          ),
        );

      // BROADCAST
      case AppRoutes.BroadCast:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) =>
                sl<BroadcastBloc>()..add(const GetPemasukanListEvent()),
            child: BroadCastPage(addBroadcast: null,),
          ),
        );



      // dikebutt moasss
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text('Error')),
          body: const Center(child: Text('Halaman tidak ditemukan!')),
        );
      },
    );
  }
}
