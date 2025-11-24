import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jawara_pintar_mobile_version/core/injections/injection.dart';
import 'package:jawara_pintar_mobile_version/features/pengeluaran/domain/entities/pengeluaran.dart';
import 'package:jawara_pintar_mobile_version/features/pengeluaran/presentation/bloc/pengeluaran_bloc.dart';
import 'package:jawara_pintar_mobile_version/features/pengeluaran/presentation/bloc/pengeluaran_event.dart';
import 'app_routes.dart';
// import halaman yg dibutuhkan
import 'package:jawara_pintar_mobile_version/pages/login/login_page.dart';
import 'package:jawara_pintar_mobile_version/features/pengeluaran/presentation/pages/daftar_pengeluaran.dart';
import 'package:jawara_pintar_mobile_version/features/pengeluaran/presentation/pages/tambah_pengeluaran.dart';
import 'package:jawara_pintar_mobile_version/features/pengeluaran/presentation/pages/edit_pengeluaran.dart';


class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Mengambil arguments (jika ada)
    final args = settings.arguments;

    switch (settings.name) {
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
  //pengeluaran
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
            child: EditPengeluaranPage(pengeluaran: pengeluaran),
          ),
        );

      // dikebutt moasss
      default:
        return _errorRoute();
    }
  }

  // Halaman Error jika route tidak ditemukan
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
