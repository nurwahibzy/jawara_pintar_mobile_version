import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jawara_pintar_mobile_version/features/mutasi-keluarga/presentation/pages/tambah_mutasi_keluarga.dart';
import 'app_routes.dart';
// import halaman yg dibutuhkan
import 'package:jawara_pintar_mobile_version/pages/login/login_page.dart';
import 'package:jawara_pintar_mobile_version/features/mutasi-keluarga/injection.dart';
import 'package:jawara_pintar_mobile_version/features/mutasi-keluarga/presentation/bloc/mutasi_keluarga_bloc.dart';
import 'package:jawara_pintar_mobile_version/features/mutasi-keluarga/presentation/pages/daftar_mutasi_keluarga.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Mengambil arguments (jika ada)
    final args = settings.arguments;

    switch (settings.name) {
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginPage());

      case AppRoutes.daftarMutasiKeluarga:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => myInjection<MutasiKeluargaBloc>(),
            child: const DaftarMutasiKeluarga(),
          ),
        );

      case AppRoutes.tambahMutasiKeluarga:
      return MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (context) => myInjection<MutasiKeluargaBloc>(),
          child: const TambahMutasiKeluarga(),
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
