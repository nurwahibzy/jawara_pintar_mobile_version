import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../injections/injection.dart';
import '../../features/pengeluaran/domain/entities/pengeluaran.dart';
import '../../features/pengeluaran/presentation/bloc/pengeluaran_bloc.dart';
import '../../features/pengeluaran/presentation/bloc/pengeluaran_event.dart';
import 'app_routes.dart';
// import halaman yg dibutuhkan
import 'package:jawara_pintar_mobile_version/pages/login/login_page.dart';
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


class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginPage());

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
            child: EditPengeluaranPage(pengeluaran: pengeluaran, kategoriList: [],),
          ),
        );
        
  // DASHBOARD
      case AppRoutes.dashboardKeuangan:
        return MaterialPageRoute(builder: (_) => const DashboardKeuanganPage());

      case AppRoutes.dashboardKegiatan:
        return MaterialPageRoute(builder: (_) => const DashboardKegiatanPage());

      case AppRoutes.kependudukan:
        return MaterialPageRoute(builder: (_) => const DashboardKependudukanPage());
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
